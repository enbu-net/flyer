// enbu はじめかたガイド (A4)
//
// Design rules used throughout:
// - Grid: 15 mm margins, content split into halves or thirds, every block starts on a column edge.
// - Type scale: 8.5 / 10 / 12.5 / 16 / 34 pt. Nothing else.
// - Color carries one meaning: red = 管理者, blue = メンバー. Everything else is ink or gray.
// - Spacing: 3 mm inside a group, 9 mm between sections.

#let ink = rgb("#1e293b")
#let muted = rgb("#64748b")
#let hair = rgb("#cbd5e1")
#let surface = rgb("#f1f5f9")
#let admin = rgb("#d62839")
#let admin-soft = rgb("#fcecee")
#let member = rgb("#2563eb")
#let member-soft = rgb("#e9f0fd")

#let s-note = 8.5pt
#let s-body = 10pt
#let s-title = 12.5pt
#let s-head = 16pt
#let s-hero = 34pt

#set document(title: "enbu はじめかたガイド", author: "enbu")
#set page(paper: "a4", margin: (x: 15mm, top: 14mm, bottom: 12mm))
#set text(font: "UDEV Gothic 35NF", size: s-body, fill: ink, lang: "ja")
#set par(leading: 0.6em, spacing: 0.8em)
#show raw: set text(font: "UDEV Gothic 35NF", size: s-body)

#let gap-section = 9mm

#let heading-row(title, aside: none) = block(below: 4mm, {
  text(size: s-head, weight: "bold", title)
  if aside != none { h(3mm); text(size: s-note, fill: muted, aside) }
})

// One command, shown the same way everywhere.
#let cmd(body, fill: white) = block(
  width: 100%, fill: fill, radius: 2mm, inset: (x: 3mm, y: 2.2mm), above: 2mm, below: 2mm,
  text(size: s-body, body),
)

#let note(body) = text(size: s-note, fill: muted, body)

// ───────────────────────────── Header ─────────────────────────────

#grid(
  columns: (26mm, 1fr),
  column-gutter: 5mm,
  align: horizon,
  image("assets/enbu.png", width: 26mm),
  {
    text(size: s-title, fill: muted)[はじめかたガイド]
    v(-1mm)
    text(size: s-hero, weight: "bold")[enbu をはじめよう]
    v(-1mm)
    text(size: s-title)[チームの `.env` を、パスワードを配らずに共有する]
  },
)

#v(gap-section)

// ───────────────────────────── Install ─────────────────────────────

#heading-row([まずはインストール], aside: [管理者もメンバーも])

#let os(name) = text(size: s-title, weight: "bold", name)

#grid(
  columns: (40mm, 1fr, 21mm),
  column-gutter: 5mm,
  row-gutter: 1mm,
  align: horizon,
  os[macOS ・ Linux], cmd(fill: surface, `curl -fsSL https://enbu.net/install.sh | sh`),
  grid.cell(rowspan: 3, align(center, {
    image("assets/qr-download.svg", width: 19mm)
    v(-1.5mm)
    note[Releases]
  })),
  [#os[Windows] #h(1mm) #note[PowerShell]], cmd(fill: surface, `irm https://enbu.net/install.ps1 | iex`),
  [], note[入ったか確認：`enbu --version`],
)

#v(gap-section)

// ───────────────────────────── Flow ─────────────────────────────

#heading-row([チームをつくる・参加する], aside: [番号の順に進めます])

#let pill(c, body) = box(
  fill: c, radius: 4mm, inset: (x: 3mm, y: 1.5mm),
  text(fill: white, weight: "bold", size: s-body, body),
)

#let dot(c, n) = box(
  width: 9mm, height: 9mm, radius: 50%, fill: c, stroke: 1.2mm + white,
  align(center + horizon, text(fill: white, weight: "bold", size: s-title, str(n))),
)

#let card(c, soft, title, body) = block(
  width: 100%, fill: soft, radius: 2.5mm, inset: (x: 4mm, y: 3mm),
  {
    text(size: s-title, weight: "bold", fill: c, title)
    v(-0.5mm)
    body
  },
)

// Steps alternate between the two lanes. A step on the other lane starts a little
// below the previous one, so the cards zigzag down a shared numbered spine.
#let flow(steps, spine: 14mm, gutter: 3mm, stagger: 15mm) = layout(size => {
  let lane = (size.width - spine) / 2
  let cursor = (a: 0pt, m: 0pt)
  let prev = none
  let placed = ()
  let dots = ()
  for (role, n, title, body) in steps {
    let (c, soft) = if role == "a" { (admin, admin-soft) } else { (member, member-soft) }
    let it = block(width: lane, card(c, soft, title, body))
    let h = measure(it).height
    let start = cursor.at(role)
    if prev != none and prev.role != role { start = calc.max(start, prev.start + stagger) }
    let dx = if role == "a" { 0pt } else { lane + spine }
    placed.push(place(top + left, dx: dx, dy: start, it))
    dots.push(place(top + left, dx: lane + spine / 2 - 4.5mm, dy: start + 2.2mm, dot(c, n)))
    cursor.insert(role, start + h + gutter)
    prev = (role: role, start: start)
  }
  let height = calc.max(cursor.a, cursor.m) - gutter
  let last = prev.start + 2.2mm
  block(width: 100%, height: height, {
    place(top + left, dx: lane + spine / 2 - 0.3mm, dy: 6.7mm,
      line(angle: 90deg, length: last - 2.2mm, stroke: 0.6mm + hair))
    for p in placed { p }
    for d in dots { d }
  })
})

#grid(
  columns: (1fr, 14mm, 1fr),
  align(center, pill(admin)[管理者 ・ チームを作る人]),
  [],
  align(center, pill(member)[メンバー ・ 参加する人]),
)
#v(2mm)
#flow((
  ("a", 1, [チームを作る], [
    #cmd(`enbu init --storage <保存先>`)
    #note[最初に実行した人が管理者になります]
  ]),
  ("a", 2, [秘密を入れて共有する], [
    #cmd(`enbu import`)
    #note[手元の `.env` を取り込み、できた `enbu.toml` を `git push`]
  ]),
  ("m", 3, [参加を申請する], [
    #cmd(`enbu init`)
    #note[リポジトリを clone して実行。表示される *指紋* を、チャットや口頭で管理者に伝えます]
  ]),
  ("a", 4, [指紋を確かめて承認する], [
    #cmd(`enbu member approve`)
    #note[聞いた指紋と一致したときだけ承認します]
  ]),
  ("m", 5, [秘密を受け取る], [
    #cmd(`enbu pull`)
    #note[`.env` ができたら準備完了です]
  ]),
))

#v(3mm)
#block(width: 100%, stroke: (left: 0.8mm + hair), inset: (left: 4mm, y: 1mm), text(size: s-note)[
  *保存先の例* #h(2mm) `oci://ghcr.io/org/app-enbu`（GitHub）・ `s3://bucket/app`（S3）\
  GitHub に置くときは、管理者もメンバーも先に `enbu auth login`。1 の `init` には `--oci-auth github` を付けます。
])

#v(gap-section)

// ───────────────────────────── Daily ─────────────────────────────

#grid(
  columns: (1fr, 24mm),
  column-gutter: 5mm,
  {
    heading-row([ふだんの使い方])
    let row(c, d) = (box(fill: surface, radius: 1.5mm, inset: (x: 2mm, y: 1.6mm), raw(c)), d)
    grid(
      columns: (auto, 1fr, auto, 1fr),
      column-gutter: 3mm,
      row-gutter: 2.5mm,
      align: horizon,
      ..row("enbu pull", [最新を `.env` に]),
      ..row("enbu add KEY", [秘密を追加]),
      ..row("enbu run -- CMD", [`.env` なしで実行]),
      ..row("enbu edit KEY", [値を変更]),
    )
  },
  align(center + bottom, {
    image("assets/qr-repo.svg", width: 21mm)
    v(-1mm)
    note[くわしい使い方]
  }),
)

#place(bottom, block(width: 100%, {
  line(length: 100%, stroke: 0.3mm + hair)
  v(-2mm)
  grid(
    columns: (1fr, auto),
    note[github.com/enbu-net/enbu],
    text(size: 6.5pt, fill: muted)[Dancer graphic: Twemoji (CC-BY 4.0)],
  )
}))
