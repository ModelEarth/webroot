#!/bin/bash

# Simple passthrough script to team/git.sh
# Usage: ./git.sh [any arguments]
#
# Expected behavior when running "./git.sh push" from webroot:
# - Commit all submodules of the webroot repo (including the team submodule)
# - Commit extra repos from .siterepos that are not submodules (for example, not data-pipeline)
# - Commit the webroot repo itself
# - Push all repositories with changes
#
# Note: git.sh is optional. You can avoid it by asking an agent like Claude to
# "commit and push" or "pull", which use direct git commands (see
# "Git: Pull, Push and Submodules" in AGENTS.md).
# - "pull" covers webroot, submodules (.gitmodules), site repos (.siterepos) and sveltia-cms
# - "push [name]" pushes only that repo; "push" or "push all" pushes every changed repo
# - Push pulls first; if the remote has newer commits, the agent merges them rather than
#   overwriting, resolving clear conflicts and asking about complex ones, and gives a
#   localhost link to review the merge before pushing
# - Add "nopr" to skip creating a PR when a direct push is not permitted
# - Pushes use the active gh account; if it's componentcore, switch to ModelEarth first
# Full git.sh docs: team/AGENTS-GitSh.md

# Run here (in webroot) regardless of where called from
cd "$(dirname "$0")"

# Check if team/git.sh exists
if [ ! -f "team/git.sh" ]; then
    echo "⚠️ ERROR: team/git.sh not found"
    echo "Make sure you're in the webroot directory and the team submodule is initialized"
    exit 1
fi

# Run team/git.sh from webroot directory with proper context
# Pass webroot path as environment variable so team/git.sh knows the context
export WEBROOT_CONTEXT="$(pwd)"
exec ./team/git.sh "$@"
