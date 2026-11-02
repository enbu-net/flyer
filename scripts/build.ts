// Build the flyer PDF and the Pages index into a directory (default: _site).
import { execFileSync } from "node:child_process";
import { copyFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";

const out = process.argv[2] ?? "_site";
mkdirSync(out, { recursive: true });

// minitype loads its default font even when every text names another one, and only
// looks in fontDir. It is not embedded in the PDF.
copyFileSync("node_modules/@minitype/minitype/fonts/SourceHanSerifJP-Regular.otf", "fonts/SourceHanSerifJP-Regular.otf");

execFileSync(process.execPath, ["flyer.ts", join(out, "flyer.pdf")], { stdio: "inherit" });
copyFileSync("site/index.html", join(out, "index.html"));
