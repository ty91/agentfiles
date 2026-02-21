#!/usr/bin/env bash
set -euo pipefail

# Resolve the repo root (where this script lives)
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$REPO_DIR/skills.json"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[dry-run] No changes will be made."
  echo
fi

# Check dependencies
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install with: brew install jq" >&2
  exit 1
fi

if [[ ! -f "$CONFIG" ]]; then
  echo "Error: $CONFIG not found" >&2
  exit 1
fi

echo "=== Skills Setup ==="
echo "Repo: $REPO_DIR"
echo "Config: $CONFIG"
echo

# Helper: expand ~ to $HOME
expand_path() {
  echo "${1/#\~/$HOME}"
}

# Helper: check if a skill is assigned to a target
skill_assigned_to() {
  local skill="$1" target="$2"
  jq -e --arg s "$skill" --arg t "$target" \
    '.skills[$s] // [] | index($t) != null' "$CONFIG" >/dev/null 2>&1
}

# Get list of target names
targets=$(jq -r '.targets | keys[]' "$CONFIG")

for target in $targets; do
  target_dir=$(expand_path "$(jq -r --arg t "$target" '.targets[$t]' "$CONFIG")")
  echo "--- Target: $target ($target_dir) ---"

  # If the target path is a symlink to a directory, remove it
  if [[ -L "$target_dir" ]]; then
    echo "  Removing directory-level symlink: $target_dir -> $(readlink "$target_dir")"
    if [[ "$DRY_RUN" == false ]]; then
      rm "$target_dir"
    fi
  fi

  # Create the target directory if it doesn't exist
  if [[ ! -d "$target_dir" ]]; then
    echo "  Creating directory: $target_dir"
    if [[ "$DRY_RUN" == false ]]; then
      mkdir -p "$target_dir"
    fi
  fi

  # Clean up stale symlinks (only those pointing into this repo's skills/)
  if [[ -d "$target_dir" ]]; then
    for entry in "$target_dir"/*; do
      [[ -e "$entry" || -L "$entry" ]] || continue
      entry_name="$(basename "$entry")"

      if [[ -L "$entry" ]]; then
        link_target="$(readlink "$entry")"
        # Only touch symlinks that point into this repo's skills directory
        if [[ "$link_target" == "$REPO_DIR/skills/"* ]]; then
          if ! skill_assigned_to "$entry_name" "$target"; then
            echo "  Removing stale symlink: $entry_name"
            if [[ "$DRY_RUN" == false ]]; then
              rm "$entry"
            fi
          fi
        fi
      fi
    done
  fi

  # Create symlinks for assigned skills
  skills_for_target=$(jq -r --arg t "$target" \
    '.skills | to_entries[] | select(.value | index($t)) | .key' "$CONFIG")

  for skill in $skills_for_target; do
    skill_src="$REPO_DIR/skills/$skill"
    skill_dst="$target_dir/$skill"

    if [[ ! -d "$skill_src" ]]; then
      echo "  Warning: skill directory not found: $skill_src" >&2
      continue
    fi

    if [[ -L "$skill_dst" ]]; then
      current_target="$(readlink "$skill_dst")"
      if [[ "$current_target" == "$skill_src" ]]; then
        echo "  OK: $skill (already linked)"
        continue
      else
        echo "  Updating: $skill (was -> $current_target)"
        if [[ "$DRY_RUN" == false ]]; then
          rm "$skill_dst"
        fi
      fi
    elif [[ -e "$skill_dst" ]]; then
      echo "  Skipping: $skill (non-symlink already exists at $skill_dst)" >&2
      continue
    fi

    echo "  Linking: $skill -> $skill_src"
    if [[ "$DRY_RUN" == false ]]; then
      ln -s "$skill_src" "$skill_dst"
    fi
  done

  echo
done

echo "=== Done ==="
