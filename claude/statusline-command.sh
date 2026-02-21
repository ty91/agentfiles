#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
todo_count=$(echo "$input" | jq -r '.tasks.pending_count // 0')

# Get current directory basename
dir_name=$(basename "$cwd")

# Get username
username=$(whoami)

# Colors
CYAN='\033[36m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
MAGENTA='\033[35m'
GRAY='\033[90m'
RESET='\033[0m'

# Get git info if in a git repo
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check for changes (dirty indicator)
        if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null || \
           ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
            git_info="${YELLOW}${branch}*${RESET}"
        else
            git_info="${GREEN}${branch}${RESET}"
        fi
    fi
fi

# Context: show remaining percentage
used_int=${used_pct%.*}
remaining=$((100 - used_int))
if [ "$remaining" -le 20 ] 2>/dev/null; then
    ctx_color=$RED
elif [ "$remaining" -le 50 ] 2>/dev/null; then
    ctx_color=$YELLOW
else
    ctx_color=$GREEN
fi

# Build output
output="${CYAN}${username}${RESET}:${BLUE}${dir_name}${RESET}"

if [ -n "$git_info" ]; then
    output="${output} ${git_info}"
fi

output="${output} ctx:${ctx_color}${remaining}% left${RESET}"
output="${output} ${MAGENTA}${model}${RESET}"

if [ "$todo_count" -gt 0 ] 2>/dev/null; then
    output="${output} ${CYAN}todo:${todo_count}${RESET}"
fi

printf "%b" "$output"
