"""Regenerate the QR codes in assets/ (pip install qrcode)."""

import qrcode
import qrcode.image.svg

CODES = {
    "assets/qr-download.svg": "https://github.com/enbu-net/enbu/releases/latest",
    "assets/qr-repo.svg": "https://github.com/enbu-net/enbu",
}

for path, url in CODES.items():
    img = qrcode.make(url, image_factory=qrcode.image.svg.SvgPathImage, border=0,
                      error_correction=qrcode.constants.ERROR_CORRECT_M)
    img.save(path)
