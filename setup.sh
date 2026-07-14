#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[dry-run] No changes will be made."
  echo
fi

# Symlink a single item: link_item <src> <dst>
link_item() {
  local src="$1" dst="$2"
  local name
  name="$(basename "$dst")"

  if [[ ! -e "$src" ]]; then
    echo "  Skipping: $name (source not found: $src)" >&2
    return
  fi

  if [[ -L "$dst" ]]; then
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      echo "  OK: $name (already linked)"
      return
    else
      echo "  Updating: $name (was -> $current)"
      if [[ "$DRY_RUN" == false ]]; then
        rm "$dst"
      fi
    fi
  elif [[ -e "$dst" ]]; then
    echo "  Backing up: $name -> ${name}.old"
    if [[ "$DRY_RUN" == false ]]; then
      mv "$dst" "${dst}.old"
    fi
  fi

  echo "  Linking: $name -> $src"
  if [[ "$DRY_RUN" == false ]]; then
    ln -s "$src" "$dst"
  fi
}

echo "=== Agent Files Setup ==="
echo "Repo: $REPO_DIR"
echo

# --- 1. ./claude/* -> ~/.claude/ ---
echo "--- ~/.claude ---"
CLAUDE_DST="$HOME/.claude"
if [[ ! -d "$CLAUDE_DST" ]]; then
  echo "  Creating directory: $CLAUDE_DST"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$CLAUDE_DST"
  fi
fi

link_item "$REPO_DIR/AGENTS.md" "$CLAUDE_DST/CLAUDE.md"
link_item "$REPO_DIR/claude/statusline-command.sh" "$CLAUDE_DST/statusline-command.sh"
link_item "$REPO_DIR/claude/agents" "$CLAUDE_DST/agents"
echo

# --- 2. ./codex/agents -> ~/.codex/agents ---
echo "--- ~/.codex ---"
CODEX_DST="$HOME/.codex"
if [[ ! -d "$CODEX_DST" ]]; then
  echo "  Creating directory: $CODEX_DST"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$CODEX_DST"
  fi
fi

link_item "$REPO_DIR/codex/agents" "$CODEX_DST/agents"

# --- 3. ./AGENTS.md -> ~/.codex/AGENTS.md ---
link_item "$REPO_DIR/AGENTS.md" "$CODEX_DST/AGENTS.md"
echo

# --- 4. Install skills globally ---
echo "--- Skills ---"
if [[ "$DRY_RUN" == true ]]; then
  echo "  Would run: npx skills add . --global --agent codex claude-code -y"
else
  npx skills add . --global --agent codex claude-code -y
fi
echo

echo "=== Done ==="
