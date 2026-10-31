"""Run Chrome widget tests using local renderer assets, without changing the SDK."""
from pathlib import Path
from urllib.parse import unquote, urlsplit
import re
import shutil
import subprocess
import sys
import threading
import time

import psutil
from playwright.sync_api import Error, sync_playwright

ROOT = Path(__file__).resolve().parents[1]
sys.stdout.reconfigure(encoding="utf-8", errors="replace")


def chrome_port(process):
    try:
        for child in psutil.Process(process.pid).children(recursive=True):
            if child.name().lower() in {"chrome.exe", "chrome", "chromium", "chromium-browser", "google-chrome"}:
                for arg in child.cmdline():
                    match = re.fullmatch(r"--remote-debugging-port=(\d+)", arg)
                    if match:
                        return int(match[1])
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        pass
    return None


def main():
    flutter = shutil.which("flutter")
    if not flutter:
        raise SystemExit("Flutter is not on PATH.")
    assets = Path(flutter).resolve().parent / "cache/flutter_web_sdk/canvaskit"
    if not (assets / "canvaskit.js").exists():
        raise SystemExit(f"Cannot find local CanvasKit assets at {assets}")
    process = subprocess.Popen(
        [flutter, "test", "--platform", "chrome", "--reporter", "expanded", *sys.argv[1:]],
        cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        text=True, encoding="utf-8", errors="replace",
    )

    def output():
        for line in process.stdout:
            print(line, end="", flush=True)

    reader = threading.Thread(target=output, daemon=True)
    reader.start()
    try:
        deadline = time.monotonic() + 240
        port = None
        while process.poll() is None and not port and time.monotonic() < deadline:
            port = chrome_port(process)
            time.sleep(.2)
        if not port:
            raise RuntimeError("The test browser did not start.")
        with sync_playwright() as playwright:
            browser = playwright.chromium.connect_over_cdp(f"http://127.0.0.1:{port}")

            def serve_renderer(route):
                suffix = unquote(urlsplit(route.request.url).path.split("/canvaskit/", 1)[1])
                path = (assets / suffix).resolve()
                if not path.is_relative_to(assets.resolve()) or not path.is_file():
                    route.abort()
                    return
                mime = "application/wasm" if path.suffix == ".wasm" else "text/javascript"
                route.fulfill(path=str(path), content_type=mime)

            for context in browser.contexts:
                context.route("**/canvaskit/**", serve_renderer)
                context.route("**/assets/fonts/Manrope.ttf",
                    lambda route: route.fulfill(path=str(ROOT / "assets/fonts/Manrope.ttf"), content_type="font/ttf"))
                for page in context.pages:
                    page.on("console", lambda message: print(message.text, flush=True) if "EXCEPTION CAUGHT" in message.text or message.text.startswith("Another exception was thrown") else None)
                    for frame in page.frames:
                        # The Windows SDK test server can return 404 before we attach.
                        # Restart only a suite that has not initialized its renderer.
                        if "_test.html" in frame.url:
                            frame.evaluate("location.reload()")
            print("Test browser uses renderer assets from the installed SDK.", flush=True)
            while process.poll() is None:
                try:
                    browser.contexts[0].pages[0].wait_for_timeout(200)
                except (Error, IndexError):
                    time.sleep(.2)
    except Exception:
        if process.poll() is None:
            process.terminate()
        raise
    finally:
        reader.join(timeout=2)
    raise SystemExit(process.wait())


if __name__ == "__main__":
    main()

