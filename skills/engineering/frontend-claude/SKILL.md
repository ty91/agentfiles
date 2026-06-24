---
name: frontend-claude
description: Delegate frontend UI changes to Claude via the CLI. MUST use when building or modifying any user-facing interface (components, layouts, styling, interaction). Do not use for refactoring internal logic.
---

When doing any frontend UI work, you **MUST** delegate it to Claude. Do not edit the UI yourself.

## Writing the prompt

The agent can reach the codebase, the issue tracker, and other project resources on its own. So:

- Keep out of the prompt anything the agent can discover by itself. Do not paste file contents or facts it can look up; instead give it a map: which files, directories, components, or issues to look at.
- Spend the prompt on what the agent cannot infer: the precise goal of this task, and an explicit out-of-scope list so it does not drift.
- Give enough context for the agent to succeed in one pass, but no more.

## Running via tmux

Run the delegated Claude inside a detached `tmux` session from the repository root. Frontend work can take more than 10 minutes; the long runtime is expected, not a hang.

The agent reports completion by writing a file under `.tmux/`, so you do **not** need to keep reading the tmux pane to track progress. Watch for the report file instead.

```bash
mkdir -p .tmux
SESSION="frontend-claude-$(date +%s)"

# 1. Write the prompt (including the reporting + cleanup protocol) to a file.
cat > ".tmux/$SESSION.prompt" <<'EOF'
You are implementing only the frontend UI slice of a larger task.

## Context
<map of relevant files, directories, components, or issues>

## Task
<the precise frontend goal>

## Out of scope
<what to leave untouched so you do not drift>

## Constraints
- Preserve existing uncommitted changes
- Do not run destructive Git commands
- Do not commit or push.

## Reporting
- Do the work to completion first.
- Only when the work is fully finished, write a completion report to
  `.tmux/$(tmux display-message -p '#S').report.md` summarizing the changes,
  files changed, validation run, and any risks or follow-ups. Writing this file
  is the signal that you are done, so write it only when the work is truly
  complete.
EOF

# 2. Launch interactive Claude inside a detached tmux session.
#    Keep the pane on exit so a crash stays inspectable.
tmux new-session -d -s "$SESSION" "claude --permission-mode bypassPermissions \"\$(cat '.tmux/$SESSION.prompt')\""
tmux set-option -t "$SESSION" remain-on-exit on

# 3. Record which session and pid are in use, under .tmux/.
printf 'session=%s\npid=%s\n' "$SESSION" "$(tmux list-panes -t "$SESSION" -F '#{pane_pid}')" > ".tmux/$SESSION.info"
```

## Waiting for completion

Wait for the report file rather than inspecting the pane. Because the run can exceed a single command timeout, run the wait in the background (or re-check periodically) instead of blocking on one long call.

## Cleanup

Once you are done with the session (after reading the report, or after inspecting a failure), clean it up yourself:

```bash
tmux kill-session -t "$SESSION"
```
