# AGENTS.md

This `AGENTS.md` is the equivalent to `CLAUDE.md`.

Use a modern, clean responsive design that has rounded corners on boarderless panels.
Each new panel should use the "Panel Menu Toggle System" from localsite/js/localsite.js to place a cirlce icon in its upper right with options for Expand, Close, etc.
Include .dark mode css. Set responsive layouts based on parent div widths rather than browser width. When possible, reuse common css from localsite/css/base.css

Primary guidance files:
- `/localsite/AGENTS.md`
- `/team/AGENTS.md`
- `/host/net/NET.md`

Submodule overview:
- `codechat/README.md`

Key standards (from linked AGENTS files):
- HTML: use `/localsite/start/template/index.html` for new pages; include `<meta charset="UTF-8">` except in redirects or template fragments.
- DOM waits: never use `setTimeout` for DOM; use `waitForElm(selector)` from `localsite/js/localsite.js` (confirm it is included first).
- Hash state: prefer `getHash`, `goHash`, `updateHash`, and `hashChangeEvent` from `localsite/js/localsite.js`.
- Paths: never hardcode user-specific paths; use relative paths or repo-root discovery. "Users" and the current user's name or computer name are never included.
- Git: only run push/pull via `./git.sh` and only commit/push when the user explicitly asks.
- **OUTSIDE WEBROOT**: Before executing any process that writes or modifies files outside the webroot root folder, state "OUTSIDE WEBROOT" and wait for confirmation.
- **Push scope**: when user says "push [repo]", push ONLY that specific repository. Do not use `git add .` or stage unrelated changes. Examples:
  - "push localsite" → push only localsite submodule changes
  - "push team" → push only team submodule changes
  - "push" or "push all" → push webroot + all submodules via `./git.sh push`

CLI assistant sessions (Claude, Codex, etc):
- Use the session store for the active CLI tool. Do not assume Claude by default.
- Claude session history: `~/.claude/history.jsonl` (JSONL format with sessionId, timestamp, display, project)
- Codex session history: `~/.codex/history.jsonl` (JSONL format with session_id, ts, text)
- For future CLIs, detect and use their native session/history location and restore command.
- Use Python or `jq` to parse efficiently; avoid multiple `awk` attempts on macOS.

Start commands:
- `start server` — starts Python HTTP server and Python backend (not Flask) (`desktop/install/quickstart.sh`)
- `start rust` — Team Repo API (Actix Rust) (from `team` repo, port 8081)
- `start net` — shared .NET host using `host/net/net.sh` and `host/net/NET.md` guidance
- `start flask` — starts both `cloud` and `pipeline`
- `start cloud` — Flask for `cloud/run` (RealityStream), local + deploy to Google Cloud
- `start pipeline` — Flask for `data-pipeline/admin`
- `start art` — Arts Engine Axum Rust API (`cargo run --manifest-path requests/engine/rust-api/Cargo.toml`, port 8082)
- `start chat` — **ask which mode first: webroot or chat repo** (see `chat/AGENTS.md`). Both use port **3700**: webroot mode `node chat/server.mjs` (chat + sibling repos + mounted `sanity/` at `/sanity`, internal Sanity on 3701); chat-repo mode `pnpm --prefix chat dev` (chat app only). First run: `pnpm --prefix chat install` and `bun --cwd sanity install`
- `start html` — bare bones without Python (not needed if you ran `start server`)

.NET / C#:
- `host/net/NET.md` provides guidance for local .NET and C# work in this webroot.
- .NET settings reside in `docker/.env` rather than XML-only local config.

Ports:
- `8887` — Python HTTP server (`desktop/install/quickstart.sh`)
- `8081` — Team Repo API (Actix Rust) (from `team` repo)
- `8010` — shared .NET 10 host (`host/net/`, serves the webroot outside `net/` and `core/`)
- `5001` — Data-Pipeline Flask server
- `8100` — Cloud/run Flask server
