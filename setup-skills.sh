#!/usr/bin/env bash
set -euo pipefail

# Resolve the repo root (where this script lives)
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[dry-run] No changes will be made."
  echo
fi

# target:destination pairs
TARGETS="claude:$HOME/.claude/skills codex:$HOME/.codex/skills"

echo "=== Skills Setup ==="
echo "Repo: $REPO_DIR"
echo

for pair in $TARGETS; do
  target="${pair%%:*}"
  dst_dir="${pair#*:}"
  src_dir="$REPO_DIR/$target/skills"

  echo "--- Target: $target ---"
  echo "  Source: $src_dir"
  echo "  Destination: $dst_dir"

  if [[ ! -d "$src_dir" ]]; then
    echo "  Skipping: source directory not found"
    echo
    continue
  fi

  # Create destination directory if needed
  if [[ ! -d "$dst_dir" ]]; then
    echo "  Creating directory: $dst_dir"
    if [[ "$DRY_RUN" == false ]]; then
      mkdir -p "$dst_dir"
    fi
  fi

  # Remove stale symlinks (only those pointing into this repo)
  for entry in "$dst_dir"/*; do
    [[ -L "$entry" ]] || continue
    link_target="$(readlink "$entry")"
    if [[ "$link_target" == "$REPO_DIR/"* ]]; then
      entry_name="$(basename "$entry")"
      # Remove if the corresponding source no longer exists
      if [[ ! -d "$src_dir/$entry_name" ]]; then
        echo "  Removing stale symlink: $entry_name"
        if [[ "$DRY_RUN" == false ]]; then
          rm "$entry"
        fi
      fi
    fi
  done

  # Create/update symlinks for each skill in source
  for skill_path in "$src_dir"/*/; do
    [[ -d "$skill_path" ]] || continue
    skill="$(basename "$skill_path")"
    skill_src="$src_dir/$skill"
    skill_dst="$dst_dir/$skill"

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
      echo "  Skipping: $skill (non-symlink already exists)" >&2
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
