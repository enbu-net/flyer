// enbu はじめかたガイド (A4), typeset with minitype (https://typeset.jp/).
//
// One page, read top to bottom in three glances:
//   1. Hero: what enbu does, with a picture of how secrets travel.
//   2. Steps: who runs what, in order. Red = 管理者, blue = メンバー, gray arrows = what
//      passes between them.
//   3. Daily use: four commands.
// Type scale: 8.5 / 10 / 12.5 / 16 / 22 / 34 pt. Spacing: 6 mm between sections.

import {
  type Block,
  box,
  type Box,
  command,
  fill,
  flexbox,
  hexToRgb,
  image,
  type InlineOrExtender,
  left,
  minitype,
  p,
  physical,
  pt,
  solid,
  top,
} from "@minitype/minitype";

const ink = hexToRgb("#1e293b");
const navy = hexToRgb("#0f172a");
const muted = hexToRgb("#64748b");
const faint = hexToRgb("#94a3b8");
const hair = hexToRgb("#cbd5e1");
const surface = hexToRgb("#f1f5f9");
const white = hexToRgb("#ffffff");
const gold = hexToRgb("#fbbf24");
const admin = hexToRgb("#d62839");
const adminSoft = hexToRgb("#fcecee");
const member = hexToRgb("#2563eb");
const memberSoft = hexToRgb("#e9f0fd");

const sNote = pt(8.5);
const sBody = pt(10);
const sTitle = pt(12.5);
const sHead = pt(16);
const sCatch = pt(22);
const sHero = pt(34);

const regular = "UDEVGothic35NF-Regular";
const bold = "UDEVGothic35NF-Bold";

const pageWidth = 210;
const margin = 15;
const width = pageWidth - margin * 2;
const heroHeight = 77;
const gapSection = 5;

type Color = ReturnType<typeof hexToRgb>;
type Lines = string | InlineOrExtender[];
type Align = "left" | "center" | "right";

// ───────────────────────────── Primitives ─────────────────────────────

// A paragraph with no indent; every text on the flyer goes through here.
const t = (body: Lines, o: { size?: number; font?: string; color?: Color; align?: Align; leading?: number } = {}) =>
  p([typeof body === "string" ? [body] : body], {
    size: o.size ?? sBody,
    font: o.font ?? regular,
    effects: [fill(o.color ?? ink)],
    align: o.align ?? "left",
    firstIndent: 0,
    lineHeight: (o.size ?? sBody) * (o.leading ?? 1.45),
  });

const note = (body: Lines, o: { align?: Align; color?: Color } = {}) =>
  t(body, { size: sNote, color: o.color ?? muted, align: o.align });

// vspace() is dropped at the top of a box, so fixed gaps are empty boxes.
const space = (h: number) => box([], { blockSize: h });

// Inline code: same face, its own pill.
const c = (s: string, bg: Color = surface) =>
  command(s, { style: { background: [fill(bg)], borderRadius: 0.8, padding: physical(0.3, 0.8) } });
const strong = (s: string, color?: Color) =>
  command(s, { style: { font: bold, ...(color ? { effects: [fill(color)] } : {}) } });

// One or more commands in a white (or gray) box.
const cmd = (lines: string | string[], bg: Color = white): Box =>
  box(
    (Array.isArray(lines) ? lines : [lines]).map((l) => t(l, { leading: 1.3 })),
    { background: [fill(bg)], borderRadius: 1.8, padding: physical(1.6, 3) },
  );

const pill = (label: string, bg: Color, o: { size?: number; width?: number } = {}) =>
  box([t(label, { size: o.size ?? sBody, font: bold, color: white, align: "center", leading: 1.3 })], {
    background: [fill(bg)],
    borderRadius: 3,
    padding: physical(1.1, 2.5),
    ...(o.width ? { inlineSize: o.width } : {}),
  });

const sectionHead = (n: string, title: string, aside?: string): Block =>
  flexbox(
    [
      box([t(n, { size: sTitle, font: bold, color: white, align: "center", leading: 1.25 })], {
        inlineSize: 7.5,
        blockSize: 7.5,
        borderRadius: 3.75,
        background: [fill(ink)],
        padding: top(0.9),
      }),
      box([
        t(
          aside
            ? [title, command(aside, { style: { size: sNote, effects: [fill(muted)], font: regular, padding: left(3) } })]
            : title,
          { size: sHead, font: bold, leading: 1.3 },
        ),
      ]),
    ],
    { gap: 2.5, alignItems: "start" },
  );

// ───────────────────────────── Hero ─────────────────────────────

const heroBackground = {
  type: "flow" as const,
  position: "page" as const,
  inlineSize: pageWidth,
  zIndex: -1,
  page: 0,
  blocks: [box([], { blockSize: heroHeight, background: [fill(navy)] })],
};

const heroLabel = (head: string, body: string, w: number) =>
  box(
    [t(head, { size: sBody, font: bold, color: white, align: "center", leading: 1.3 }), note(body, { align: "center", color: faint })],
    { inlineSize: w },
  );

const hero: Block[] = [
  flexbox(
    [
      box([image("assets/enbu.png", { width: 17 })], { inlineSize: 17 }),
      box([
        space(1.5),
        flexbox(
          [
            box([t("enbu", { size: sHero, font: bold, color: white, leading: 1.05 })], { inlineSize: 34 }),
            box([space(4.5), pill("はじめかたガイド", admin, { size: sNote, width: 30 })]),
          ],
          { gap: 2, alignItems: "start" },
        ),
      ]),
    ],
    { gap: 3, alignItems: "start" },
  ),
  space(2),
  t(["チームの ", strong(".env", gold), " を、パスワードを配らずに共有。"], {
    size: sCatch,
    font: bold,
    color: white,
    leading: 1.3,
  }),
  space(3),
  image("assets/how.svg", { width: 150, align: "center" }),
  space(1.5),
  flexbox(
    [
      heroLabel("自分の端末で暗号化", "メンバー全員の鍵にあてて", 56),
      heroLabel("保存先には暗号文だけ", "GHCR・S3 など。中身は読めない", 68),
      heroLabel("自分の端末の鍵で開く", "鍵は端末から出ない", 56),
    ],
    { gap: 0, alignItems: "start" },
  ),
];

// ───────────────────────────── 1. Install ─────────────────────────────

const installBase = "https://website.enbu-net.workers.dev";

// One row per OS: name on the left, the command beside it, so long URLs stay on one line.
const osCmd = (os: string, aside: string, line: string) =>
  flexbox(
    [
      box([space(1.4), t(aside ? [strong(os), command(aside, { style: { size: sNote, effects: [fill(muted)], padding: left(2) } })] : [strong(os)])], {
        inlineSize: 36,
      }),
      box([box([t(line, { size: pt(8.5) })], { background: [fill(surface)], borderRadius: 1.8, padding: physical(1.6, 3) })]),
    ],
    { gap: 0, alignItems: "start" },
  );

const install: Block[] = [
  sectionHead("1", "インストール", "管理者もメンバーも"),
  space(2.5),
  flexbox(
    [
      box([
        osCmd("macOS ・ Linux", "", `curl -fsSL ${installBase}/install.sh | sh`),
        space(1.5),
        osCmd("Windows", "PowerShell", `irm ${installBase}/install.ps1 | iex`),
      ]),
      box([image("assets/qr-download.svg", { width: 13, align: "center" }), note("Releases", { align: "center" })], {
        inlineSize: 16,
      }),
    ],
    { gap: 3, alignItems: "start" },
  ),
];

// ───────────────────────────── 2. Steps ─────────────────────────────

// Each row holds one step: its card in the lane of whoever runs it, its number on the
// spine, and in the other lane what that person receives or needs to know.
const lane = (width - 16) / 2;
const spine = 16;
const rowGap = 2;

type Role = "a" | "m";
type Step = { role: Role; title: string; commands: string[]; height: number; other?: Block[] };

const card = (role: Role, title: string, commands: string[], height: number): Box => {
  const [color, soft] = role === "a" ? [admin, adminSoft] : [member, memberSoft];
  return box([t(title, { size: sTitle, font: bold, color, leading: 1.35 }), space(0.8), cmd(commands)], {
    background: [fill(soft)],
    borderRadius: 2.5,
    padding: physical(2.4, 3.5),
    blockSize: height,
    inlineSize: lane,
  });
};

// What crosses to the other lane: an arrow pointing away from the card, then the words.
const handoff = (role: Role, body: Block[], height: number): Box => {
  const arrow = image(role === "a" ? "assets/arrow-right.svg" : "assets/arrow-left.svg", { width: 9 });
  const words = box(body);
  if (role === "m") for (const b of body) if (b.type === "text") b.style = { ...b.style, align: "right" };
  return box(
    [
      space(Math.max(0, height / 2 - 6)),
      flexbox(role === "a" ? [box([arrow], { inlineSize: 10 }), words] : [words, box([arrow], { inlineSize: 10 })], {
        gap: 1.5,
        alignItems: "start",
      }),
    ],
    { inlineSize: lane, blockSize: height },
  );
};

const dot = (role: Role, n: number) =>
  box([space(1.7), t(String(n), { size: sTitle, font: bold, color: white, align: "center", leading: 1.25 })], {
    background: [fill(role === "a" ? admin : member)],
    borderRadius: 4.5,
    inlineSize: 9,
    blockSize: 9,
  });

const segment = (h: number) =>
  box([], { blockSize: h, margin: left(spine / 2 - 0.3), border: left(solid(0.6, hair)) });

const steps = (list: Step[]): Block[] =>
  list.map((s, i) => {
    const last = i === list.length - 1;
    const mine = card(s.role, s.title, s.commands, s.height);
    const theirs = s.other ? handoff(s.role, s.other, s.height) : box([], { inlineSize: lane });
    const middle = box(
      [space(2), box([dot(s.role, i + 1)], { padding: left((spine - 9) / 2) }), ...(last ? [] : [segment(s.height - 11 + rowGap)])],
      { inlineSize: spine },
    );
    return box(
      [flexbox(s.role === "a" ? [mine, middle, theirs] : [theirs, middle, mine], { gap: 0, alignItems: "start" })],
      { margin: physical(0, 0, last ? 0 : rowGap, 0) },
    );
  });

const tip = (body: Lines) => note(body, { color: ink });

const flowSection: Block[] = [
  flexbox(
    [
      box([sectionHead("2", "チームをつくる・参加する")]),
      box([space(0.8), pill("管理者 ・ チームを作る人", admin, { size: sNote, width: 45 })], { inlineSize: 45 }),
      box([space(0.8), pill("メンバー ・ 参加する人", member, { size: sNote, width: 41 })], { inlineSize: 41 }),
    ],
    { gap: 2, alignItems: "start" },
  ),
  space(3),
  ...steps([
    {
      role: "a",
      title: "チームを作る",
      commands: ["enbu auth login", "enbu init"],
      height: 23.5,
      other: [
        tip([strong("保存先は自動"), "（GitHub なら GHCR）"]),
        note(["GHCR は「Inherit access from repository」をオンに。S3 は ", c("--storage"), " で"]),
      ],
    },
    {
      role: "a",
      title: "秘密を入れて共有する",
      commands: ["enbu import .env", "git push"],
      height: 23.5,
      other: [tip([strong("enbu.toml"), " がリポジトリで届く"]), note("中身は暗号化され、保存先にあります")],
    },
    {
      role: "m",
      title: "参加を申請する",
      commands: ["enbu auth login", "enbu init"],
      height: 23.5,
      other: [tip([strong("指紋"), "を管理者に伝える"]), note("clone して init すると表示。チャットや口頭で")],
    },
    {
      role: "a",
      title: "指紋を確かめて承認",
      commands: ["enbu member approve"],
      height: 18.5,
      other: [tip([strong("承認"), "されると秘密が読めるように"]), note("聞いた指紋と一致したときだけ承認")],
    },
    {
      role: "m",
      title: "秘密を受け取る",
      commands: ["enbu pull"],
      height: 18.5,
      other: [tip([strong(".env"), " ができたら準備完了！"]), note("あとは 3 のコマンドで")],
    },
  ]),
];

// ───────────────────────────── 3. Daily ─────────────────────────────

const tile = (code: string, desc: Lines) =>
  box([t(code, { font: bold, leading: 1.3 }), space(0.6), note(desc)], {
    background: [fill(surface)],
    borderRadius: 2,
    padding: physical(2.2, 3),
    inlineSize: 37,
    blockSize: 13.5,
  });

const daily: Block[] = [
  flexbox(
    [
      box([
        sectionHead("3", "ふだんの使い方"),
        space(2.5),
        flexbox(
          [
            tile("enbu pull", ["最新を ", c(".env", white), " に"]),
            tile("enbu add KEY", "秘密を追加する"),
            tile("enbu edit KEY", "値を変更する"),
            tile("enbu run -- CMD", [c(".env", white), " を書かずに実行"]),
          ],
          { gap: 2.5, alignItems: "start" },
        ),
      ]),
      box([space(1), image("assets/qr-repo.svg", { width: 15, align: "center" }), note("くわしい使い方", { align: "center" })], {
        inlineSize: 22,
      }),
    ],
    { gap: 3, alignItems: "start" },
  ),
];

// ───────────────────────────── Footer ─────────────────────────────

const footer = box(
  [
    flexbox([
      box([note("github.com/enbu-net/enbu")]),
      box([t("Dancer graphic: Twemoji (CC-BY 4.0)", { size: pt(6.5), color: muted, align: "right" })]),
    ]),
  ],
  { border: top(solid(0.3, hair)), padding: top(1) },
);

await minitype(
  [
    {
      body: [
        heroBackground,
        ...hero,
        space(gapSection + 2),
        ...install,
        space(gapSection),
        ...flowSection,
        space(gapSection),
        ...daily,
        { type: "flow", position: "nombre", blockOffset: -4, blocks: [footer] },
      ],
    },
  ],
  {
    size: "A4",
    padding: physical(10, margin, 7, margin),
    gaps: [],
    block: { paragraph: { font: regular, size: sBody } },
  },
  { fontDir: "fonts", metadata: { title: "enbu はじめかたガイド", author: "enbu" } },
).save(process.argv[2] ?? "enbu-flyer.pdf");
