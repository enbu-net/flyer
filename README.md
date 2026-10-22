# enbu flyer

A4 の「enbu はじめかたガイド」チラシ。Typst で書いています。

- PDF: https://enbu-net.github.io/flyer/

## ビルド

```sh
pip install typst==0.15.0
python scripts/build.py _site   # _site/flyer.pdf, index.html
```

`typst compile --font-path fonts --ignore-system-fonts flyer.typ` でも同じものが出ます。
QR コードは `python scripts/qr.py`（`pip install qrcode`）で作り直せます。

フォントは [UDEV Gothic](https://github.com/yuru7/udev-gothic) 35NF（SIL OFL 1.1、`fonts/`）。
踊る人のイラストは [Twemoji](https://github.com/twitter/twemoji)（CC-BY 4.0）です。
