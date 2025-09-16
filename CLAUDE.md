# CLAUDE.md

## Start server or Restart server

### Start Server
When you type "start server", first check if server is already running, then start only if needed:

```bash
# Check if HTTP server is already running on port 8887
if lsof -ti:8887 > /dev/null 2>&1; then
  echo "HTTP server already running on port 8887"
else
  nohup python -m http.server 8887 > /dev/null 2>&1 &
  echo "Started HTTP server on port 8887"
fi
```

Note: Uses nohup to run server in background and redirect output to avoid timeout.


### Start Rust API Server
When you type "start rust", first check if server is already running, then start only if needed:

```bash
# Check if Rust API server is already running on port 8081
if lsof -ti:8081 > /dev/null 2>&1; then
  echo "Rust API server already running on port 8081"
else
  cd team
  # Ensure Rust is installed and cargo is in PATH
  source ~/.cargo/env 2>/dev/null || echo "Install Rust first: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
  # Copy .env.example to .env only if .env doesn't exist
  [ ! -f .env ] && cp .env.example .env
  # Start the server with correct binary name
  nohup cargo run --bin partner_tools -- serve > server.log 2>&1 &
  echo "Started Rust API server on port 8081"
fi
```

Note: The team repository is a submodule located in the repository root directory. The Rust API server runs on port 8081. Requires Rust/Cargo to be installed on the system. The .env file is created from .env.example only if it doesn't already exist.

### Pull submodules:
When you type "pull submodules", run
```bash
# Navigate to webroot first
cd $(git rev-parse --show-toplevel)
git submodule update --remote --recursive
```

### Push submodules:
When you type "push submodules", run
```bash
./git.sh push submodules [nopr]
```
**Note**: This pushes all submodules with changes AND updates the webroot parent repository with new submodule references. Includes automatic PR creation on push failures.

### PR [submodule name]:
Create a pull request for a submodule when you lack collaborator privileges:
```bash
cd [submodule name]
git add . && git commit -m "Description of changes"
git push origin feature-branch-name
gh pr create --title "Update [submodule name]" --body "Description of changes"
cd ..
```

## IMPORTANT: Git Commit Policy

**NEVER commit changes without an explicit user request starting with push or sync.** 

- Only run git commands (add, commit, push) when the user specifically says "push" or directly requests it
- After making code changes, STOP and wait for user instruction
- Build and test changes as needed, but do not commit automatically
- The user controls when changes are committed to the repository

## HTML File Standards

**UTF-8 Character Encoding**: Always include `<meta charset="UTF-8">` in the `<head>` section of new HTML pages to ensure proper character rendering and prevent display issues with special characters.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <!-- other meta tags and content -->
</head>
```

**Exceptions**: Do not add charset declarations to redirect pages or template fragments that are included in other pages, as they inherit encoding from their parent documents.

## Comprehensive Pull Command

### Pull / Pull All
When you type "pull" or "pull all", run this comprehensive pull workflow that pulls from all parent repos, submodules and industry repos:

```bash
./git.sh pull
```

**Legacy Support**: If the user types "update", inform them to use "pull" or "pull all" instead:

*"Please use 'pull' or 'pull all' instead of 'update'. Examples:*
- *pull - Pull all changes from webroot, submodules, and industry repos*
- *pull localsite - Pull changes for localsite submodule only*
- *pull webroot - Pull changes for webroot only"*

All complex git operations are now handled by the git.sh script to avoid shell parsing issues.

### GitHub Account Management
The git.sh script automatically detects the current GitHub CLI user and adapts accordingly:

```bash
gh auth logout                    # Log out of current GitHub account
gh auth login                     # Log into different GitHub account
./git.sh auth                     # Refresh git credentials and update all remotes
```

When you switch GitHub accounts, the script will:
- **Automatically detect** the new user during pull/push operations
- **Clear cached git credentials** from previous account
- **Refresh authentication** to use new GitHub CLI credentials  
- **Change remote URLs** to point to the new user's forks
- **Create PRs** from the new user's account
- **Fork repositories** to the new user's account when needed

**Automatic Credential Management:**
- Detects when GitHub user has changed since last run
- Clears cached credentials from credential manager and macOS keychain
- Runs `gh auth setup-git` to sync git with GitHub CLI
- Prevents permission denied errors from stale credentials

**Pull Command Features:**
- **Pull from Parents**: Pulls webroot, submodules, and industry repos from their respective ModelEarth parent repositories
- **Fork-Aware**: Automatically adds upstream remotes for parent repos when working with forks
- **Partnertools Exclusion**: Completely skips any repositories associated with partnertools GitHub account
- **Merge Strategy**: Uses automatic merge with no-edit to incorporate upstream changes
- **Conflict Handling**: Reports merge conflicts for manual resolution when they occur  
- **Status Reporting**: Provides clear feedback on what was pulled and any issues encountered
- **Push Guidance**: Prompts user with specific commands for pushing changes back to forks and parent repos
- **Comprehensive Workflow**: Handles webroot, all submodules, and all industry repositories in one command

**Post-Pull Recommendations:**
After running "./git.sh pull", review changes and use these commands as needed:
- `./git.sh push` - Push all changes (webroot + submodules + forks) with PR creation
- `./git.sh push submodules` - Push only submodule changes  
- `./git.sh push [specific-name]` - Push changes for a specific repository

**Git.sh Usage:**
```bash
./git.sh pull                      # Full pull workflow  
./git.sh push                      # Complete push: webroot, all submodules, and industry repos
./git.sh push [name]               # Push specific submodule
./git.sh push submodules           # Push all submodules only
./git.sh push [name] nopr          # Skip PR creation on push failures
```

**Individual Repository Commands:**
```bash
./git.sh pull [repo_name]          # Pull specific repository (webroot, submodule, or industry repo)
./git.sh push [repo_name]          # Push specific repository (webroot, submodule, or industry repo)
```

**Supported Repository Names:**
- **Webroot**: webroot
- **Submodules**: cloud, comparison, feed, home, localsite, products, projects, realitystream, swiper, team, trade
- **Industry Repos**: exiobase, profile, io


## Submodule Management

This repository contains the following git submodules configured in `.gitmodules`:
- **localsite** - https://github.com/ModelEarth/localsite
- **feed** - https://github.com/modelearth/feed  
- **swiper** - https://github.com/modelearth/swiper
- **home** - https://github.com/ModelEarth/home
- **products** - https://github.com/modelearth/products
- **comparison** - https://github.com/modelearth/comparison
- **team** - https://github.com/modelearth/team
- **projects** - https://github.com/modelearth/projects
- **realitystream** - https://github.com/modelearth/realitystream
- **cloud** - https://github.com/modelearth/cloud
- **trade** - https://github.com/modelearth/trade
- **codechat** - https://github.com/modelearth/codechat
- **exiobase** - https://github.com/modelearth/exiobase
- **io** - https://github.com/modelearth/io
- **profile** - https://github.com/modelearth/profile
- **reports** - https://github.com/modelearth/reports
- **community-forecasting** - https://github.com/modelearth/community-forecasting

**IMPORTANT**: All directories listed above are git submodules, not regular directories. They appear as regular directories when browsing but are actually git submodule references. Always treat them as submodules in git operations.

### Upstream Repository Policy

**CRITICAL**: The maximum upstream level for all repositories is `modelearth`

- **Webroot and Submodules**: Upstream should point to `modelearth` or `ModelEarth` repositories only
- **Industry Repositories**: Upstream should point to `modelearth` repositories only  
- **Repository Hierarchy**: `user-fork` → `modelearth` (STOP - do not go higher)

**Example Correct Upstream Configuration:**
```bash
# Correct upstream configuration
git remote add upstream https://github.com/modelearth/trade.git
git remote add upstream https://github.com/ModelEarth/webroot.git
```

**Pull Workflow Impact:**
- The `./git.sh pull` command respects this policy and only pulls from modelearth-level repositories
- If any upstream is incorrectly configured to point above modelearth level, it must be corrected
- This prevents conflicts from pulling changes from repositories outside the modelearth ecosystem

**GitHub Pages Integration:**
- When creating webroot PRs, the system automatically checks for GitHub Pages on the user's fork
- If GitHub Pages is not enabled, it attempts to enable it automatically using the GitHub CLI
- PRs include live preview links to `[username].github.io/webroot` for easy review
- If automatic setup fails, users receive manual setup instructions and interactive options:
  - **Y** - Continue with PR creation (recommended)
  - **N** - Skip PR creation and continue with commit only
  - **Q** - Quit without creating PR or committing

### Repository Root Navigation
**CRITICAL**: Always ensure you're in the webroot repository before executing any commands. The CLI session is pointed to the webroot directory, and all operations must start from there:

```bash
# ALWAYS navigate to webroot repository root first (required for all operations)
cd $(git rev-parse --show-toplevel)

# Verify you're in the correct webroot repository
git remote -v
# Should show: origin https://github.com/ModelEarth/webroot.git

# If git rev-parse returns the wrong repository (submodule/trade repo), manually navigate to webroot
# Use your system's webroot path, never hardcode paths in documentation
```

**IMPORTANT FILE PATH POLICY**: 
- **NEVER hardcode specific file paths** from any user's computer in code or documentation
- **NEVER include paths like `/Users/username/` or `C:\Users\`** in any commands or examples
- Always use relative paths, environment variables, or git commands to determine paths dynamically
- Use `$(git rev-parse --show-toplevel)` when already in the correct repository context
- If `git rev-parse --show-toplevel` returns incorrect paths (submodule/trade repo instead of webroot), navigate up to webroot directory. Some users may give their webroot a different folder name than "webroot"

**IMPORTANT**: The `git rev-parse --show-toplevel` command returns the top-level directory of whatever git repository you're currently in. If you're inside a submodule or trade repo, it will return that repository's root instead of the webroot. In such cases, you must manually navigate to your actual webroot directory location on your system.

**Common Issue**: If submodule commands fail or you get "pathspec did not match" errors, you're likely in a submodule directory instead of the webroot. Navigate back to your webroot directory using your system's actual webroot path before running any commands.

### IMPORTANT: "push [name]" Command Requirements
When a user says "push [name]", use the git.sh script:

```bash
./git.sh push [name] [nopr]
```

**Legacy Support**: If the user says "commit [name]", inform them to use "push [name]" instead:

*"Please use 'push [name]' instead of 'commit [name]'. Examples:*
- *push localsite - Push changes for localsite submodule*
- *push webroot - Push changes for webroot only*
- *push all - Push all repositories with changes"*

The git.sh script handles all the complex logic including:
- Submodule detection and pushing
- Automatic PR creation on push failures  
- Webroot submodule reference updates
- Support for 'nopr' flag to skip PR creation

**Direct Commit Method (if foreach strategy fails):**

Used when the `git submodule foreach` strategy fails, such as:
- **Detached HEAD state**: Submodule is not on a proper branch
- **Corrupted submodule**: `.git` folder or configuration is damaged
- **Branch conflicts**: Submodule is on a different branch than expected
- **Nested submodules**: Complex submodule hierarchies that confuse foreach
- **Permission issues**: File system permissions prevent git operations within submodules

**⚠️ IMPORTANT**: Do not initialize new submodules unless explicitly requested by the user. If a directory exists but is not properly initialized as a submodule, treat it as a standalone repository or ignore it rather than converting it to a submodule.

```bash
# Step 0: ALWAYS start from webroot
cd $(git rev-parse --show-toplevel)

# Direct submodule commit (when foreach method doesn't work)
cd [submodule name]
git checkout main  # Ensure on main branch (fixes detached HEAD)
git add . && git commit -m "Description of changes"
if git push origin main; then
  echo "✅ Successfully pushed [submodule name] submodule"
elif [ "$SKIP_PR" != "true" ]; then
  git push origin HEAD:feature-[submodule name]-direct && gh pr create --title "Update [submodule name] submodule" --body "Direct update of [submodule name] submodule" --base main --head feature-[submodule name]-direct || echo "PR creation failed"
  echo "🔄 Created PR for [submodule name] submodule due to permission restrictions"
fi

# Return to webroot and update submodule reference
cd $(git rev-parse --show-toplevel)
git submodule update --remote [submodule name]
git add [submodule name]
git commit -m "Update [submodule name] submodule" 
if git push; then
  echo "✅ Successfully updated [submodule name] submodule reference"
elif [ "$SKIP_PR" != "true" ]; then
  git push origin HEAD:feature-webroot-[submodule name]-ref && gh pr create --title "Update [submodule name] submodule reference" --body "Update submodule reference for [submodule name]" --base main --head feature-webroot-[submodule name]-ref || echo "Webroot PR creation failed"
  echo "🔄 Created PR for webroot [submodule name] submodule reference"
fi
```

**⚠️ CRITICAL**: 
- **NEW**: Automatic PR creation when push permissions are denied
- **NEW**: 'nopr' or 'No PR' (case insensitive) flag to skip PR creation
- **NEW**: All commit commands include PR fallback for permission failures
- **NEW**: Intelligent fallback strategy handles unrecognized names gracefully
- **NEW**: Three-tier approach: submodule → standalone repo → webroot fallback
- **NEW**: Always checks for actual changes before committing
- **NEW**: Provides clear success/failure feedback with ✅ and 🔄 indicators
- **NEVER initialize new submodules unless explicitly requested by user**
- **NEVER convert existing directories to submodules automatically**
- Method 1 handles detached HEAD states automatically
- Both methods require updating the parent repository
- If git submodule foreach fails, the submodule may not exist or be corrupted
- Always check status first to see which submodules actually have changes
- Use conditional `if [ "$name" = "submodule" ]` to target specific submodule and avoid "nothing to commit" errors from clean submodules
- The `--recursive` flag ensures nested submodules are handled properly
- Requires GitHub CLI (gh) for PR creation functionality

### Quick Commands for Repositories
- **"push [name] [nopr]"**: Intelligent push with PR fallback - tries submodule → standalone repo → webroot fallback
- **"pull [name]"**: Pull changes for specific repository (webroot, submodule, or extra repo)
- **"PR [submodule name]"**: Create pull request workflow
- **"push submodules [nopr]"**: Push all submodules with PR fallback when push fails
- **"push forks [nopr]"**: Push all extra repo forks and create PRs to parent repos
- **"push [nopr]"** or **"push all [nopr]"**: Complete push workflow with PR fallback - pushes webroot, all submodules, and all forks

**PR Fallback Behavior**: All push commands automatically create pull requests when direct push fails due to permission restrictions. Add 'nopr' or 'No PR' (case insensitive) at the end of any push command to skip PR creation.

**Legacy Command Support**: If users type "commit" or "update", inform them of the new commands:
- "commit" → "push" 
- "update" → "pull" or "pull all"

When displaying "Issue Resolved" use the same checkbox icon as "Successfully Updated"

### Additional Notes
- Allow up to 12 minutes to pull repos (large repositories)
- Always verify both submodule AND parent repository are updated

## Git Commit Guidelines
- **NEVER add Claude Code attribution or co-authored-by lines to commits**
- **NEVER add "🤖 Generated with [Claude Code]" or similar footers**
- Keep commit messages clean and focused on the actual changes
- Include a brief summary of changes in the commit text

## DOM Element Waiting
- **NEVER use setTimeout() for waiting for DOM elements**
- **ALWAYS use waitForElm(selector)** from localsite/js/localsite.js instead
- Check if localsite/js/localsite.js is included in the page before using waitForElm
- If not included, ask user if localsite/js/localsite.js should be added to the page
- Example: `waitForElm('#element-id').then(() => { /* code */ });`
- waitForElm does not use timeouts and waits indefinitely until element appears

## Navigation Guidelines
- **Directory Restrictions**: If the user requests `cd ../`, first check if you are already in the webroot. If so, ignore the request so errors do not appear.
- **Webroot Detection**: Use `git rev-parse --show-toplevel` or check current working directory against `/Users/helix/Library/Data/webroot` pattern
- **Security Boundaries**: Claude Code sessions are restricted to working within the webroot and its subdirectories

## Git Command Guidelines
- **Always Use git.sh**: When receiving "push" and "pull" requests, always use `./git.sh push` and `./git.sh pull` to avoid approval prompts
- **Avoid Direct Git Commands**: Do not use individual git commands like `git add`, `git commit`, `git push` for these operations
- **Automatic Workflow**: The git.sh script handles the complete workflow including submodules, remotes, and error handling automatically

## Quick Commands

When you type "restart", run this single command to restart the server in seconds:
```bash
cd $(git rev-parse --show-toplevel) && pkill -f "node.*index.js"; (cd server && NODE_ENV=production nohup node index.js > /dev/null 2>&1 &)
```

When you type "quick", add the following permissions block to setting.local.json under allow. "
When you type "confirm" or "less quick", remove it:
```json
[
  "Bash(yarn setup)",
  "Bash(npx update-browserslist-db:*)",
  "Bash(mkdir:*)",
  "Bash(yarn build)",
  "Bash(cp:*)",
  "Bash(npx prisma generate:*)",
  "Bash(npx prisma migrate:*)",
  "Bash(pkill:*)",
  "Bash(curl:*)",
  "Bash(git submodule add:*)",
  "Bash(rm:*)",
  "Bash(find:*)",
  "Bash(ls:*)",
  "Bash(git add:*)",
  "Bash(git commit:*)",
  "Bash(git push:*)"
]
```

## Extra Repositories

### Extra Repo List
The following extra repositories are used for specialized functionality and are cloned to the webroot root directory (not submodules):
- **community** - https://github.com/modelearth/community
- **nisar** - https://github.com/modelearth/nisar
- **data-pipeline** - https://github.com/modelearth/data-pipeline

**IMPORTANT**: These extra repos are cloned to the webroot root directory and are NOT submodules. They provide specialized functionality that is not needed for typical site deployments.

### Fork Extra Repos

```bash
fork extra repos to [your github account]
```

The above runs these commands:
```bash
# Fork repositories using GitHub CLI (requires 'gh' to be installed and authenticated)
gh repo fork modelearth/community --clone=false
gh repo fork modelearth/nisar --clone=false
gh repo fork modelearth/data-pipeline --clone=false
```

### Clone Extra Repos

```bash
clone extra repos from [your github account]
```

The above runs these commands:
```bash
# Navigate to webroot repository root first
cd $(git rev-parse --show-toplevel)

# Clone extra repos to webroot root
git clone https://github.com/[your github account]/community community
git clone https://github.com/[your github account]/nisar nisar
git clone https://github.com/[your github account]/data-pipeline data-pipeline
```