#!/bin/bash

# Simple passthrough script to team/git.sh
# Usage: ./git.sh [any arguments]
#
# Expected behavior when running "./git.sh push" from webroot:
# - Commit all submodules of the webroot repo (including the team submodule)
# - Commit extra repos that are not submodules  
# - Commit the webroot repo itself
# - Push all repositories with changes

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