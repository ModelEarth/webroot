#!/bin/bash

# Simple passthrough script to team/git.sh
# Usage: ./git.sh [any arguments]

# Check if team/git.sh exists
if [ ! -f "team/git.sh" ]; then
    echo "⚠️ ERROR: team/git.sh not found"
    echo "Make sure you're in the webroot directory and the team submodule is initialized"
    exit 1
fi

# Pass through all arguments to team/git.sh
exec ./team/git.sh "$@"