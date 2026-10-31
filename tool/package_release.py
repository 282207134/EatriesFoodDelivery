"""Collect release APKs, archive portable sources and write SHA-256 checksums."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "artifacts"
EXCLUDED = {
    ".dart_tool", ".idea", ".git", ".gradle", "build", "build_temp",
    "artifacts", "__pycache__", "node_modules",
}
GENERATED = {"local.properties", ".flutter-plugins-dependencies", "GeneratedPluginRegistrant.java"}


def main():
    version = re.search(r"^version:\s*([^\s+]+)", (ROOT / "pubspec.yaml").read_text(encoding="utf-8"), re.M)[1]
    metadata = json.loads((ROOT / "build/app/outputs/apk/release/output-metadata.json").read_text())
    if any(item["versionName"] != version for item in metadata["elements"]):
        raise SystemExit("Release output is stale. Build lib/main.dart first.")
    registrant = ROOT / "android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java"
    if registrant.exists() and "IntegrationTestPlugin" in registrant.read_text(encoding="utf-8"):
        raise SystemExit("Build the production release after running integration tests.")
    OUTPUT.mkdir(exist_ok=True)
    for arch in ("arm64-v8a", "x86_64"):
        source = ROOT / f"build/app/outputs/flutter-apk/app-{arch}-release.apk"
        shutil.copy2(source, OUTPUT / f"eateries-{arch}.apk")
    archive = OUTPUT / "eateries-source.zip"
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as handle:
        for source in sorted(ROOT.rglob("*")):
            relative = source.relative_to(ROOT)
            if not source.is_file() or any(part in EXCLUDED for part in relative.parts):
                continue
            if source.name in GENERATED or source.suffix in {".iml", ".log", ".pyc"}:
                continue
            handle.write(source, str(relative))
    with zipfile.ZipFile(archive) as handle:
        assert handle.testzip() is None, "Source archive failed verification."
    lines = [
        f"{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.name}"
        for path in sorted(OUTPUT.iterdir()) if path.suffix in {".apk", ".zip"}
    ]
    (OUTPUT / "SHA256SUMS.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Packaged Eateries {version}.")
    for path in OUTPUT.iterdir():
        print(path.name, path.stat().st_size)


if __name__ == "__main__":
    main()

