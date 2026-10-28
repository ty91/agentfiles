#!/usr/bin/env bash
set -euo pipefail

AGENT_TOML="${CODEX_HOME:-$HOME/.codex}/agents/code-reviewer.toml"
WORKDIR="${1:-$PWD}"

if [[ ! -f "$AGENT_TOML" ]]; then
  echo "code-reviewer agent not found: $AGENT_TOML" >&2
  exit 1
fi

INSTRUCTIONS="$(python3 -c 'import json, sys, tomllib; print(json.dumps(tomllib.load(open(sys.argv[1], "rb"))["developer_instructions"], ensure_ascii=False))' "$AGENT_TOML")"

RUN_DIR="$(mktemp -d "${TMPDIR:-/tmp}/codex-review.XXXXXX")"
REVIEW="$RUN_DIR/review.md"
LOG="$RUN_DIR/codex.log"

if ! codex exec \
  -C "$WORKDIR" \
  -s read-only \
  -m gpt-5.6-sol \
  -c model_reasoning_effort="high" \
  -c "developer_instructions=$INSTRUCTIONS" \
  -o "$REVIEW" \
  - >"$LOG" 2>&1; then
  echo "codex exec failed (log: $LOG)" >&2
  tail -n 40 "$LOG" >&2
  exit 1
fi

if [[ ! -s "$REVIEW" ]]; then
  echo "codex exec produced no review (log: $LOG)" >&2
  tail -n 40 "$LOG" >&2
  exit 1
fi

cat "$REVIEW"
rm -rf "$RUN_DIR"
