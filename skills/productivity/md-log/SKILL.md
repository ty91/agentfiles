---
name: md-log
description: Log the conversation (user and assistant messages) to a Markdown file with Obsidian-compatible callouts. Invoke explicitly with /md-log <path> to start and /md-log off to stop. Claude Code only.
disable-model-invocation: true
---

# Markdown Conversation Log

Toggles per-session conversation logging. The actual logging is done by a `Stop` hook (`~/.claude/hooks/md-log.ts stop`, registered in `settings.json`) that appends new messages to the log file after every completed turn. This skill only flips the session's state file.

## Start logging

Run with the Bash tool:

```bash
bun ~/.claude/hooks/md-log.ts on "<path>"
```

- `<path>` is the target Markdown file. Use `$ARGUMENTS` if provided; otherwise ask the user for a path.
- Relative paths resolve against the current working directory; `~/` and absolute paths are supported.
- Relay the printed confirmation to the user. Logging starts from the next user message — the turn that enables logging is intentionally not logged.

## Stop logging

```bash
bun ~/.claude/hooks/md-log.ts off
```

## How it works

- State lives at `~/.local/state/md-log/<session-id>.json` (`{enabled, path, cursor}`), keyed by `$CLAUDE_CODE_SESSION_ID`. The Stop hook and the status line read the same file.
- The Stop hook tracks a line cursor into the session transcript JSONL, so turns interrupted with Esc are caught up on the next completed turn.
- Messages are formatted as `> [!quote] You` and `> [!info] Claude` callouts; skill invocations are compacted to `> [!note] [skill] <name>` plus arguments.
- If messages stop appearing in the log, verify the `Stop` hook registration in the active profile's `settings.json` and that the status line still shows `md-log:<path>`.
