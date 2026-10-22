# enbu flyer

A4 の「enbu はじめかたガイド」チラシ。Typst で書いています。

- プレビュー: https://enbu-net.github.io/flyer/
- PDF: https://enbu-net.github.io/flyer/flyer.pdf

## ビルド

Noto Sans CJK JP と DejaVu Sans Mono が必要です。

```sh
pip install typst==0.15.0
python scripts/build.py _site   # _site/flyer.pdf, flyer.png, index.html
```

`typst compile flyer.typ` でも同じものが出ます。
QR コードは `python scripts/qr.py`（`pip install qrcode`）で作り直せます。

踊る人のイラストは [Twemoji](https://github.com/twitter/twemoji)（CC-BY 4.0）です。
