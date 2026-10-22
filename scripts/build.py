"""Build the flyer into a directory: PDF, PNG preview and the Pages index."""

import shutil
import sys
from pathlib import Path

import typst

ROOT = Path(__file__).resolve().parent.parent
out = Path(sys.argv[1] if len(sys.argv) > 1 else "_site")
out.mkdir(parents=True, exist_ok=True)

source = ROOT / "flyer.typ"
typst.compile(source, output=out / "flyer.pdf")
typst.compile(source, output=out / "flyer.png", format="png", ppi=200)
shutil.copy(ROOT / "site" / "index.html", out / "index.html")
