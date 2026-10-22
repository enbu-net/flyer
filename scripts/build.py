"""Build the flyer PDF and the Pages index into a directory."""

import shutil
import sys
from pathlib import Path

import typst

ROOT = Path(__file__).resolve().parent.parent
out = Path(sys.argv[1] if len(sys.argv) > 1 else "_site")
out.mkdir(parents=True, exist_ok=True)

source = ROOT / "flyer.typ"
typst.compile(source, output=out / "flyer.pdf", font_paths=[ROOT / "fonts"], ignore_system_fonts=True)
shutil.copy(ROOT / "site" / "index.html", out / "index.html")
