# AGENTS.md

On initial agent usage, invoke a sandbox using steps in support/python/PYTHON.md

Do not execute code external to this CloudRepos webroot.
Do not modify files external to this CloudRepos webroot.
Request permission when accessing externally residing config files.
Avoid revealing secrets in the terminal: never print values of keys, tokens or passwords (show only names, or masked values).
Avoid revealing the name or location of the .env file in the terminal. `automation/paths.yaml` sets its location via `env_file`; read it in code without echoing the path.

This `AGENTS.md` is the equivalent to `CLAUDE.md`.

Use a modern, clean responsive design that has rounded corners on boarderless panels.
Each new panel should use the "Panel Menu Toggle System" from localsite/js/localsite.js to place a cirlce icon in its upper right with options for Expand, Close, etc.
Include .dark mode css. Set responsive layouts based on parent div widths rather than browser width. When possible, reuse common css from localsite/css/base.css

Additional guidance files (wait to invoke for specific needs):
- `/localsite/AGENTS.md` - css and static site navigation, maps
- `/team/AGENTS.md` - Rust and Industry database API endpoints (when the `team` submodule is present)

Submodule overview:
- `codechat/README.md`

Key standards (from linked AGENTS files):
- HTML: use `/localsite/start/template/index.html` for new pages; include `<meta charset="UTF-8">` except in redirects or template fragments.
- DOM waits: never use `setTimeout` for DOM; use `waitForElm(selector)` from `localsite/js/localsite.js` (confirm it is included first).
- Hash state: prefer `getHash`, `goHash`, `updateHash`, and `hashChangeEvent` from `localsite/js/localsite.js`.
- Paths: never hardcode user-specific paths; use relative paths or repo-root discovery. "Users" and the current user's name or computer name are never included.
- `sveltia-cms/`: a git-ignored clone of `sveltia/sveltia-cms` (not a submodule), kept as a read-only reference for agents. Pull to update it, but never commit, push, fork, or send PRs from it. Pages load Sveltia CMS from its npm release, or a local build of this clone when present; customize the editor from localsite (config, `launchCMS()`, theme CSS) rather than changing CMS source.
- Git: see "Git: Pull, Push and Submodules" below.

CLI assistant sessions (Claude, Codex, etc):
- Use the session store for the active CLI tool. Do not assume Claude by default.
- Claude session history: `~/.claude/history.jsonl` (JSONL format with sessionId, timestamp, display, project)
- Codex session history: `~/.codex/history.jsonl` (JSONL format with session_id, ts, text)
- For future CLIs, detect and use their native session/history location and restore command.
- Use Python or `jq` to parse efficiently; avoid multiple `awk` attempts on macOS.

Start commands:
- `start server` — starts Python HTTP server and Python backend (not Flask) (`desktop/install/quickstart.sh`)
- `start rust` — Team Repo API (Actix Rust) (from `team` repo, port 8081; requires the `team` submodule, see `team/AGENTS.md` for details)
- `start net` — shared .NET host using `host/net/net.sh` and `host/net/NET.md` guidance
- `start flask` — starts both `cloud` and `pipeline`
- `start cloud` — Flask for `cloud/run` (RealityStream), local + deploy to Google Cloud
- `start pipeline` — Flask for `data-pipeline/admin`
- `start art` — Arts Engine Axum Rust API (`cargo run --manifest-path requests/engine/rust-api/Cargo.toml`, port 8082)
- `start chat` — **check for an adjacent `CloudRoot` repo first**: if `../CloudRoot` exists next to this webroot repo, use it for port **3700** instead: `PORT=3700 node chat/server.mjs` run from `../CloudRoot` (see `../CloudRoot/AGENTS.md`; OUTSIDE WEBROOT — state that and wait for confirmation before starting it). If `../CloudRoot` does not exist, fall back to the within-webroot chat: **ask which mode first: webroot or chat repo** (see `chat/AGENTS.md`). Both use port **3700**: webroot mode `node chat/server.mjs` (chat + sibling repos); chat-repo mode `pnpm --prefix chat dev` (chat app only). First run: `pnpm --prefix chat install`
- `start html` — bare bones without Python (not needed if you ran `start server`)

.NET / C#:
- `host/net/NET.md` provides guidance for local .NET and C# work in this webroot.
- .NET settings reside in the `.env` file set by `env_file` in `automation/paths.yaml` (outside webroot) rather than XML-only local config. The `docker` repo is discontinued.

Ports:
- `8887` — Python HTTP server (`desktop/install/quickstart.sh`)
- `8081` — Team Repo API (Actix Rust) (from `team` repo, when present)
- `8010` — shared .NET 10 host (`host/net/`, serves the webroot outside `net/` and `core/`)
- `5001` — Data-Pipeline Flask server
- `8100` — Cloud/run Flask server

When adding a new page, use the following index.html starter:
https://raw.githubusercontent.com/ModelEarth/localsite/refs/heads/main/start/template/index.html

## Git: Pull, Push and Submodules

Use direct `git` commands. `./git.sh` is no longer used unless "git.sh" is directly requested (see `team/AGENTS-GitSh.md` if the `team` submodule is present).

The CLI session already starts in the webroot root folder, so run git commands from there. Don't prefix commands with `cd $(git rev-parse --show-toplevel)`, since the `$()` triggers approval prompts. `git remote -v` should show `ModelEarth/webroot`.

The default shell is zsh, which does not split an unquoted variable such as `g="git -C engine"; $g fetch` into words. Run multi-repo loops with `bash -c '...'`, as in the pull script below.

### Repositories

- **Root**: webroot.
- **Submodules**: defined in `.gitmodules`. Read that file rather than relying on a list. Skip submodules that aren't initialized locally unless asked.
- **Site repos**: defined in `.siterepos` (same format as `.gitmodules`). They are cloned into the root folder but are NOT submodules. `data-pipeline` is a submodule and should not be in `.siterepos`.
- **`sveltia-cms/`**: git-ignored read-only reference clone. Pull it, but never commit, push, fork, or send PRs from it.
- **Upstream policy**: the highest upstream for any repo is `modelearth`/`ModelEarth`: `user-fork` → `modelearth` (stop there).

### Pull

- **"pull"** or **"pull all"**: pull webroot, every initialized submodule, every site repo present locally, and `sveltia-cms`.
- **"pull [name]"**: pull only that repo (root, submodule, or site repo).

`git pull` in webroot updates the submodule commits webroot records, but not the files checked out in each submodule. Update the submodules separately, each on its `main` branch:

```bash
git pull --ff-only
bash -c '
for p in $(git config -f .gitmodules --get-regexp "^submodule\..*\.path$" | awk "{print \$2}"); do
  [ -e "$p/.git" ] || { echo "$p: not initialized"; continue; }
  [ -z "$(git -C "$p" status --porcelain)" ] || { echo "$p: uncommitted changes, skipped"; continue; }
  start=$(git -C "$p" rev-parse --short HEAD)
  git -C "$p" fetch -q origin || { echo "$p: fetch failed"; continue; }
  branch=$(git -C "$p" symbolic-ref --short -q HEAD)
  if [ -z "$branch" ]; then
    git -C "$p" merge-base --is-ancestor HEAD origin/main || { echo "$p: detached HEAD has commits not on origin/main, skipped"; continue; }
    git -C "$p" checkout -q main
  elif [ "$branch" != main ]; then
    echo "$p: on branch $branch, skipped"; continue
  fi
  git -C "$p" merge --ff-only -q origin/main || { echo "$p: cannot fast-forward, see Version Conflicts"; continue; }
  end=$(git -C "$p" rev-parse --short HEAD)
  [ "$start" != "$end" ] && echo "$p: $start -> $end ($(git -C "$p" rev-list --count $start..$end) commits)"
done
for p in $(git config -f .siterepos --get-regexp "\.path$" | awk "{print \$2}") sveltia-cms; do
  [ -d "$p/.git" ] && { git -C "$p" pull --ff-only -q && echo "$p: pulled" || echo "$p: pull failed, see Version Conflicts"; }
done'
git status --short
```

- Report submodule changes by comparing the commit checked out **before** the pull with the one after, as the script does. Don't compare the local `main` branch before and after: `main` is often older than the detached commit that was checked out, so that comparison reports commits that were already there.
- Report anything the script skipped, and ask before resolving it.
- Afterwards, `git status` shows ` M <submodule>` for any submodule that is now newer than the commit webroot records. Don't commit those pointer updates unless asked; they go out with the next "push".
- **Repository not found** on a pull or fetch: run `gh auth status` to see the other logged-in accounts. If `ModelEarth` is among them, switch with `gh auth switch --user ModelEarth` and retry. Don't log in a new account or prompt for credentials unless `ModelEarth` isn't already authenticated.

### Submodule Detached HEAD

`git submodule update` checks out the commit webroot records, which leaves the submodule on a detached HEAD instead of a branch. Before staging or committing work in a submodule, get back onto `main` without moving the code backward:

```bash
git -C <submodule> fetch origin
git -C <submodule> merge-base --is-ancestor HEAD origin/main && echo "safe to switch"
git -C <submodule> checkout main
git -C <submodule> merge --ff-only origin/main
```

Never stop after `checkout main` alone. Local `main` is often older than the detached commit, so checking it out rolls the files back. If the `merge-base` check fails, the detached HEAD has commits that aren't on origin/main. Note the hash (`git -C <submodule> rev-parse HEAD`), check out `main`, then `git -C <submodule> merge <hash>`, and resolve as in Version Conflicts below.

### Version Conflicts

These steps apply to every repo: webroot, submodules and site repos. Follow them when a pull or push finds that the local branch is older than the remote (origin/main) or has diverged from it, for example when a fast-forward fails. **Do not silently overwrite local work**:

1. **Identify the divergence**: compare the local commit with origin/main to see what changed on each side.
2. **Merge, don't replace**: merge the remote changes into the local `main` branch (omit `-C <repo>` for webroot):
   ```bash
   git -C <repo> checkout main
   git -C <repo> merge origin/main
   ```
3. **Resolve conflicts intelligently**: analyze the diff and keep both the remote improvements and the local changes where possible. Resolve automatically only when the solution is clear and unambiguous; for complex conflicts, present resolution options for the user to choose from.
4. **Commit the merge**. For a submodule, also update webroot's pointer to the merged commit.
5. **Never let an older local commit overwrite what is already on GitHub** — that pushes a regression. Preserving local work means merging it forward, not pushing it backward over the remote.
6. **Before pushing, if a merge or overwrite occurred**, give the user a localhost review link, e.g. `http://localhost:8887/<repo>/<changed-path>/` (or `http://localhost:8887/<changed-path>` for webroot; run `start server` first if port 8887 isn't serving), and wait for confirmation before pushing. If nothing was merged or overwritten, push without waiting.

**Goal**: a commit newer than both the local and remote versions, containing both sets of changes, pushed to the repo's origin/main.

### Push

- Only commit or push when the user explicitly asks.
- **CRITICAL**: always pull the repo being pushed before pushing, to get the latest changes and avoid conflicts. If the pull can't fast-forward, follow Version Conflicts above.
- **Account**: pushes go out as whichever account is active in `gh` (`gh api user`). Before pushing, check `gh auth status`; if the active account is `componentcore`, switch to `ModelEarth` first with `gh auth switch --user ModelEarth`, since `componentcore/webroot` does not exist. After the commit/push completes, switch back with `gh auth switch --user componentcore` so it remains the default active account between requests. For any other active account, check push access first (see Contributors Without Push Access below); if it lacks access and a logged-in account has it, switch to that account, then switch back to the previously active account after the push.
- **Push scope**: "push [repo]" pushes ONLY that repository. Don't use `git add .` or stage unrelated changes.
  - "push localsite" → push only localsite submodule changes
  - "push engine" → push only engine submodule changes
  - "push" or "push all" → commit and push each changed submodule (on its `main` branch, not a detached HEAD), then commit and push webroot with the updated submodule pointers, plus changed site repo forks

Quick commands:
- **"push [name] [nopr]"**: push one repo: submodule, site repo, or root.
- **"push submodules [nopr]"**: push all changed submodules.
- **"push forks [nopr]"**: push all changed site repo forks and create PRs to their parent repos.
- **"push [nopr]"** or **"push all [nopr]"**: push root, all submodules, and all forks.
- **"PR [submodule name]"**: create a pull request.

**PR fallback**: when the account lacks push access, push to a fork and open a pull request instead, as described below. Add 'nopr' or 'No PR' (case insensitive) at the end of a push command to skip PR creation.

### Contributors Without Push Access

1. **Check access** before pushing each repo, using its upstream owner/name from `git remote -v`:
   ```bash
   gh api repos/<owner>/<repo> -q .permissions.push
   ```
   If this returns `false`, run `gh auth status` and switch to another logged-in account that has push access, if there is one. Never prompt for a new login or log out an account.
2. **Ask before creating forks**: if no logged-in account has access, list each repo that needs a fork and the account that will own it, and ask the user to approve with Y/N, e.g. `Create forks under <account> for team, cloud, webroot? (Y/N)`. If the answer is N, stop and leave the commits local. If a fork already exists (`gh repo view <account>/<repo>`), reuse it and don't ask.
3. **Fork and push a branch**:
   ```bash
   gh repo fork <owner>/<repo> --remote=false
   git -C <repo> remote add fork https://github.com/<account>/<repo>.git   # if not already added
   git -C <repo> push fork main:<branch>
   ```
   Keep `origin` pointing at the upstream repo so pulls still come from it.
4. **Ask before opening each PR**, unless `nopr` was given. Show the repo, branch and title, then run `gh pr create --repo <owner>/<repo> --head <account>:<branch>`.
5. **Submodules first**: open the submodule PRs before the webroot PR. Webroot's recorded submodule commits exist only in the forks until those PRs merge, so list the submodule PR links in the webroot PR description and note that they must merge first.
6. **Report** the forks created, branches pushed, and PR links.

### Commit Messages and Push Reports

- **No Agent (Claude) attribution**: never include Claude Code credits or co-authored-by lines for any agent.
- **Repository-specific**: each commit message describes only that repository's changes, with no references to other repos' changes.
- **Concise and factual**: focus on what was changed, not implementation details.
- In push reports, include the commit info and report only what was pushed in the current operation. Don't describe earlier commits or implementations.
