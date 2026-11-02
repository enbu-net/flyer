# enbu flyer

A4 の「enbu はじめかたガイド」チラシ。[minitype](https://typeset.jp/)（TypeScript の組版ライブラリ）で書いています。

- PDF: https://enbu-net.github.io/flyer/

## ビルド

```sh
npm ci            # Node.js 22.18 以降（TypeScript をそのまま実行）
npm run build     # _site/flyer.pdf, index.html
```

図（`assets/how.svg`、`assets/arrow-*.svg`）は手書きの SVG です。minitype は SVG に mm 単位の width / height を求めます。
手順カードと「ふだんの使い方」のタイルは高さ固定です。minitype は収まらない中身を描かないので、文言を足したら `flyer.ts` の高さも増やしてください。
minitype 本体は PolyForm Noncommercial 1.0.0 です（非商用は可、生成した PDF はライセンスの対象外）。
QR コードは `python scripts/qr.py`（`pip install qrcode`）で作り直せます。

フォントは [UDEV Gothic](https://github.com/yuru7/udev-gothic) 35NF（SIL OFL 1.1、`fonts/`）。
踊る人のイラストは [Twemoji](https://github.com/twitter/twemoji)（CC-BY 4.0）です。
