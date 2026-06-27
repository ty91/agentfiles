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

link_gemini_skill() {
  local src="$1" dst="$2" target="$3"
  local name current
  name="$(basename "$dst")"

  if [[ ! -d "$src" ]]; then
    echo "  Skipping: $name (source not found: $src)" >&2
    return
  fi

  if [[ -L "$dst" ]]; then
    current="$(readlink "$dst")"
    if [[ "$current" == "$target" ]]; then
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

  echo "  Linking: $name -> $target"
  if [[ "$DRY_RUN" == false ]]; then
    ln -s "$target" "$dst"
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

# --- 4. ./AGENTS.md -> ~/.gemini/GEMINI.md ---
echo "--- ~/.gemini ---"
GEMINI_DST="$HOME/.gemini"
if [[ ! -d "$GEMINI_DST" ]]; then
  echo "  Creating directory: $GEMINI_DST"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$GEMINI_DST"
  fi
fi

link_item "$REPO_DIR/AGENTS.md" "$GEMINI_DST/GEMINI.md"
echo

# --- 5. Install skills globally ---
echo "--- Skills ---"
if [[ "$DRY_RUN" == true ]]; then
  echo "  Would run: npx skills add . --global --agent codex claude-code -y"
else
  npx skills add . --global --agent codex claude-code -y
fi
echo

# --- 6. ~/.agents/skills/* -> ~/.gemini/skills/* ---
echo "--- ~/.gemini/skills ---"
AGENTS_SKILLS_DST="$HOME/.agents/skills"
GEMINI_SKILLS_DST="$HOME/.gemini/skills"
if [[ ! -d "$GEMINI_SKILLS_DST" ]]; then
  echo "  Creating directory: $GEMINI_SKILLS_DST"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$GEMINI_SKILLS_DST"
  fi
fi

for skill in "$AGENTS_SKILLS_DST"/*; do
  [[ -d "$skill" ]] || continue
  name="$(basename "$skill")"
  link_gemini_skill "$skill" "$GEMINI_SKILLS_DST/$name" "../../.agents/skills/$name"
done
echo

echo "=== Done ==="
