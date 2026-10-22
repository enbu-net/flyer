// enbu はじめかたガイド (A4)
// Colors carry one meaning each: red = 管理者, blue = メンバー, gray = shared.

#let ink = rgb("#1e293b")
#let muted = rgb("#64748b")
#let line-c = rgb("#e2e8f0")
#let code-bg = rgb("#f1f5f9")
#let admin = rgb("#d62839")
#let admin-bg = rgb("#fdf0f1")
#let member = rgb("#2563eb")
#let member-bg = rgb("#eef3fe")

#set document(title: "enbu はじめかたガイド", author: "enbu")
#set page(paper: "a4", margin: (x: 12mm, top: 11mm, bottom: 9mm))
#set text(font: "UDEV Gothic 35NF", size: 8.6pt, fill: ink, lang: "ja")
#set par(leading: 0.55em, spacing: 0.7em)
#show raw: set text(font: "UDEV Gothic 35NF", size: 7.8pt)
#show raw.where(block: false): it => box(
  fill: code-bg, inset: (x: 2.5pt), outset: (y: 2pt), radius: 2pt, it,
)

// A code block. `#` starts a comment, drawn in muted color.
#let cmd(body) = block(
  width: 100%, fill: code-bg, inset: (x: 6pt, y: 5pt), radius: 3pt, above: 4pt, below: 4pt,
  {
    show raw.line: l => {
      let t = l.text
      let i = t.position(" #")
      if i == none { t } else { t.slice(0, i); text(fill: muted, t.slice(i)) }
    }
    body
  },
)

#let section(n, title, note: none) = block(above: 9pt, below: 6pt, grid(
  columns: (auto, 1fr),
  column-gutter: 6pt,
  align: horizon,
  box(fill: ink, radius: 50%, width: 15pt, height: 15pt,
    align(center + horizon, text(fill: white, weight: "bold", size: 9pt, n))),
  {
    text(size: 12.5pt, weight: "bold", title)
    if note != none { h(8pt); text(size: 8pt, fill: muted, note) }
  },
))

#let role(name, c) = box(
  fill: c, inset: (x: 5pt, y: 2.5pt), radius: 8pt,
  text(fill: white, weight: "bold", size: 7.5pt, name),
)

// A step card in the setup flow.
#let step(c, bg, label, title, body) = block(
  width: 100%, fill: bg, stroke: (left: 2.5pt + c), radius: (right: 4pt),
  inset: (x: 7pt, y: 6pt),
  {
    text(fill: c, weight: "bold", size: 8pt, label)
    h(4pt)
    text(weight: "bold", size: 9.6pt, title)
    v(1pt)
    body
  },
)

// A horizontal arrow with a label, drawn in the middle column of the flow.
#let arrow(dir, c, label, sub: none) = align(center + horizon, block(width: 100%, {
  text(fill: c, weight: "bold", size: 7.6pt, label)
  if sub != none { linebreak(); text(fill: muted, size: 6.6pt, sub) }
  v(-1pt)
  let shaft = line(length: 100%, stroke: 1.4pt + c)
  let head = polygon(fill: c, (0pt, 0pt), (6pt, 3.5pt), (0pt, 7pt))
  let rev = polygon(fill: c, (6pt, 0pt), (0pt, 3.5pt), (6pt, 7pt))
  grid(
    columns: (auto, 1fr, auto),
    align: horizon,
    if dir == "left" { rev } else { [] },
    shaft,
    if dir == "right" { head } else { [] },
  )
}))

// ───────────────────────────── Header ─────────────────────────────

#grid(
  columns: (auto, 1fr, auto),
  column-gutter: 10pt,
  align: horizon,
  image("assets/enbu.png", height: 24mm),
  {
    text(size: 9pt, fill: muted, weight: "bold", tracking: 0.05em)[GETTING STARTED]
    v(-4pt)
    text(size: 25pt, weight: "bold")[enbu はじめかたガイド]
    v(-6pt)
    text(size: 10pt)[チームの `.env` を、鍵を配らずに共有する CLI]
  },
  grid(
    columns: 2,
    column-gutter: 8pt,
    row-gutter: 4pt,
    align: center,
    image("assets/qr-download.svg", width: 17mm),
    image("assets/qr-repo.svg", width: 17mm),
    text(size: 6.8pt, fill: muted)[ダウンロード],
    text(size: 6.8pt, fill: muted)[ドキュメント],
  ),
)

#v(1pt)
#block(
  width: 100%, stroke: 0.6pt + line-c, radius: 4pt, inset: (x: 8pt, y: 6pt),
  grid(
    columns: (auto, 1fr, auto, 1fr),
    column-gutter: 6pt,
    align: horizon,
    role("管理者", admin),
    [チームを作る人。保存先を決め、参加したい人を承認する],
    role("メンバー", member),
    [チームに参加する人。承認されたら `.env` を受け取れる],
  ),
)

// ───────────────────────────── 1. Install ─────────────────────────────

#section("1", "インストール", note: [管理者もメンバーも])

#let os-card(name, sub, body) = block(
  width: 100%, height: 100%, stroke: 0.6pt + line-c, radius: 4pt, inset: 7pt,
  {
    text(weight: "bold", size: 10pt, name)
    h(4pt)
    text(fill: muted, size: 7pt, sub)
    v(1pt)
    body
  },
)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 6pt,
  rows: 34mm,
  os-card("macOS", "Apple Silicon", [
    Homebrew で入れます。
    #cmd(```
brew install enbu-net/tap/enbu
```)
    画面で操作したい人はデスクトップ版も。
    #cmd(```
brew install --cask \
  enbu-net/tap/enbu-desktop
```)
  ]),
  os-card("Windows", "x64 / ARM64", [
    + Releases から `…_windows_amd64.zip` を取得して展開（ARM 機は `arm64`）
    + `enbu.exe` のフォルダを「環境変数を編集」で `Path` に追加
    + ターミナルを開き直す
  ]),
  os-card("Ubuntu", "x64 / ARM64", [
    Homebrew があれば macOS と同じ。なければ Releases の tar.gz から:
    #cmd(```
tar xzf enbu_*_linux_*.tar.gz
sudo mv enbu /usr/local/bin/
```)
  ]),
)

#v(3pt)
#grid(
  columns: (auto, 1fr),
  column-gutter: 6pt,
  align: horizon,
  text(fill: muted, size: 8pt)[入ったか確認],
  [`enbu --version` でバージョン、`enbu doctor` で鍵の保存先（TPM・Secure Enclave・キーチェーン）が使えるかを確認できます。],
)

// ───────────────────────────── 2. Flow ─────────────────────────────

#section("2", "チームをつくる・参加する", note: [上から順に。矢印はふたりの間のやりとり])

#let mid = 27mm
#grid(
  columns: (1fr, mid, 1fr),
  column-gutter: 4pt,
  row-gutter: 5pt,
  align(center, role("管理者", admin)),
  [],
  align(center, role("メンバー", member)),

  // Row 1: admin initializes
  step(admin, admin-bg, "A1", "保存先を決めて初期化", [
    GitHub (GHCR) に置く例:
    #cmd(```
enbu auth login
enbu init --oci-auth github \
  --storage oci://ghcr.io/ORG/REPO-enbu
```)
    最初に `init` した人が管理者になります。S3 なら\
    `--storage s3://BUCKET/PATH --region …`
  ]),
  [],
  align(horizon, block(width: 100%, inset: 8pt, text(fill: muted, size: 7.6pt)[
    管理者の準備ができるまで待ちます。インストールだけ済ませておきましょう。
  ])),

  // Row 2: admin shares enbu.toml, member joins
  step(admin, admin-bg, "A2", [秘密を登録して `enbu.toml` を共有], [
    #cmd(```
enbu import         # 手元の .env をまるごと
git add enbu.toml .gitignore
git commit -m "Add enbu" && git push
```)
    メンバーに保存先の読み書き権限も付けておきます。
  ]),
  arrow("right", admin, [`enbu.toml`], sub: [Git で届く]),
  grid.cell(rowspan: 2, step(member, member-bg, "M1", "クローンして参加を申請", [
    #cmd(```
git clone <リポジトリ> && cd <リポジトリ>
enbu auth login     # GHCR のときだけ
enbu init
```)
    デバイスの *指紋* が表示されます。
    #align(center, box(
      stroke: 1pt + member, radius: 3pt, inset: (x: 6pt, y: 4pt), fill: white,
      raw("a1b2-c3d4-e5f6-0718-293a"),
    ))
    チャットや対面など *別の経路で* 管理者に伝えます。
  ])),

  // Row 3: admin approves
  grid.cell(rowspan: 2, step(admin, admin-bg, "A3", "指紋を照合して承認", [
    #cmd(```
enbu member approve
```)
    申請の一覧から選び、表示された指紋が\
    メンバーから聞いたものと *一致するとき* だけ承認します。\
    承認すると全環境が自動で再暗号化されます。
  ])),
  arrow("left", member, [指紋], sub: [チャット・対面で]),

  // Row 4: member pulls
  arrow("right", admin, [承認]),
  step(member, member-bg, "M2", [`.env` を受け取る], [
    #cmd(```
enbu pull              # .env を書き出す
enbu run -- npm start  # 書き出さずに実行
```)
  ]),
)

// ───────────────────────────── 3. Daily use ─────────────────────────────

#section("3", "ふだんの使い方", note: [管理者もメンバーも同じ。`enbu` だけで起動すると画面操作もできます])

#let row(c, d) = (c, d)
#let table-cell-style = (x, y) => if calc.even(y) { code-bg.lighten(40%) } else { white }
#grid(
  columns: (1fr, 1fr),
  column-gutter: 10pt,
  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 5pt, y: 3.4pt),
    fill: table-cell-style,
    `enbu pull`, [最新の秘密を `.env` に書き出す],
    `enbu add KEY`, [秘密を追加（値は画面に出さずに入力）],
    `enbu edit KEY`, [既存の値を変更],
    `enbu delete KEY`, [秘密を削除],
    `enbu import`, [既存の `.env` をまとめて取り込む],
  ),
  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 5pt, y: 3.4pt),
    fill: table-cell-style,
    `enbu switch -c prod`, [環境 prod を作って切り替え],
    `enbu switch dev`, [環境 dev に切り替え],
    `-e prod`, [そのコマンドだけ別の環境を使う],
    `enbu run -- CMD`, [秘密を環境変数にしてコマンド実行],
    `enbu resolve`, [同時に変更された値をどちらか選ぶ],
  ),
)

// ───────────────────────────── 4. Admin ─────────────────────────────

#grid(
  columns: (1fr, 1fr),
  column-gutter: 10pt,
  {
    section("4", "管理者のしごと")
    block(stroke: (left: 2.5pt + admin), inset: (left: 7pt, y: 2pt), {
      table(
        columns: (auto, 1fr),
        stroke: none,
        inset: (x: 0pt, y: 2.6pt),
        column-gutter: 6pt,
        `enbu member requests`, [承認待ちの一覧],
        `enbu member list`, [メンバーの一覧],
        `enbu member remove`, [メンバーを外して再暗号化],
        `enbu member admin`, [管理者を追加する],
      )
      v(2pt)
      text(size: 7.8pt)[外したメンバーがすでに読んだ値は取り消せません。*キーをローテーション* してください。]
    })
  },
  {
    section("5", "困ったときは")
    block(stroke: (left: 2.5pt + muted), inset: (left: 7pt, y: 2pt), {
      table(
        columns: (auto, 1fr),
        stroke: none,
        inset: (x: 0pt, y: 2.6pt),
        column-gutter: 6pt,
        `enbu doctor`, [鍵の保存先が使えるか確認],
        `enbu auth status`, [ログイン状態を確認],
        `ENBU_DEBUG=1`, [エラーの詳しい原因を表示],
        `enbu --help`, [すべてのコマンド],
      )
      v(2pt)
      text(size: 7.8pt)[承認されるまで `pull` はできません。管理者に指紋を伝えたか確認しましょう。]
    })
  },
)

#place(bottom, float: false, dy: 4mm, block(width: 100%, {
  line(length: 100%, stroke: 0.5pt + line-c)
  v(-4pt)
  grid(
    columns: (1fr, auto),
    text(size: 7pt, fill: muted)[github.com/enbu-net/enbu ・ MIT License],
    text(size: 6pt, fill: muted)[Dancer graphic: Twemoji by Twitter, Inc. (CC-BY 4.0)],
  )
}))
