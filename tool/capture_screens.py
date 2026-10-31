"""Capture the real Flutter renderer and build the documentation preview boards."""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import os
import threading

from PIL import Image, ImageDraw
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs/screenshots"
LONG_PAGES = {15: 2600, 21: 2200, 23: 1800, 38: 1600}


class QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass


def build_directory():
    candidates = [ROOT / "build_temp/web", ROOT / "build/web"]
    return max(
        (path for path in candidates if (path / "main.dart.js").exists()),
        key=lambda path: (path / "main.dart.js").stat().st_mtime,
    )


def preview_boards():
    for theme in ("light", "dark"):
        for group in range(4):
            board = Image.new("RGB", (1000, 1695), "#e7e7e7")
            draw = ImageDraw.Draw(board)
            for index, number in enumerate(range(group * 12 + 1, group * 12 + 13)):
                with Image.open(OUTPUT / theme / f"{number:02}.png") as source:
                    shot = source.convert("RGB")
                shot.thumbnail((240, 520))
                x, y = (index % 4) * 250 + 5, (index // 4) * 565
                draw.text((x, y + 5), f"{theme} {number:02}", fill="#111111")
                board.paste(shot, (x, y + 25))
            board.save(OUTPUT / f"qa-{theme}-{group + 1}.jpg", quality=85)
    selected = [
        ("light", 15, "Home"), ("light", 21, "Restaurant"), ("light", 24, "Cart"),
        ("light", 37, "Order"), ("light", 38, "Account"), ("dark", 15, "Dark mode"),
    ]
    board = Image.new("RGB", (900, 1360), "#ece8e2")
    draw = ImageDraw.Draw(board)
    for index, (theme, number, label) in enumerate(selected):
        with Image.open(OUTPUT / theme / f"{number:02}.png") as source:
            shot = source.convert("RGB")
        shot.thumbnail((280, 620))
        x, y = (index % 3) * 300 + 10, (index // 3) * 680 + 35
        board.paste(shot, (x, y))
        draw.text((x, y - 22), label, fill="#242424")
    board.save(OUTPUT / "overview.jpg", quality=92)


def main():
    server = ThreadingHTTPServer(
        ("127.0.0.1", 8765),
        partial(QuietHandler, directory=str(build_directory())),
    )
    threading.Thread(target=server.serve_forever, daemon=True).start()
    errors = []
    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(
                executable_path=os.environ.get(
                    "CHROME_PATH", "C:/Program Files/Google/Chrome/Application/chrome.exe"
                ),
                headless=True, args=["--disable-gpu"],
            )
            page = browser.new_page(
                viewport={"width": 375, "height": 812}, device_scale_factor=2
            )
            page.on("pageerror", lambda error: errors.append(str(error)))

            def capture(theme, screen, target, height=812):
                page.set_viewport_size({"width": 375, "height": height})
                page.goto(
                    f"http://127.0.0.1:8765/?screen={screen}&theme={theme}",
                    wait_until="networkidle", timeout=90000,
                )
                page.wait_for_selector("flt-glass-pane", state="attached", timeout=90000)
                page.wait_for_timeout(800)
                page.screenshot(path=str(target))
                print(f"Captured {target.relative_to(OUTPUT)}", flush=True)

            for theme in ("light", "dark"):
                folder = OUTPUT / theme
                folder.mkdir(parents=True, exist_ok=True)
                for screen in range(1, 49):
                    capture(theme, screen, folder / f"{screen:02}.png")
            folder = OUTPUT / "long"
            folder.mkdir(exist_ok=True)
            for theme in ("light", "dark"):
                for screen, height in LONG_PAGES.items():
                    capture(theme, screen, folder / f"{theme}-{screen:02}.png", height)
            browser.close()
    finally:
        server.shutdown()
        server.server_close()
    if errors:
        raise RuntimeError("\n".join(errors))
    preview_boards()


if __name__ == "__main__":
    main()

