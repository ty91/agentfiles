---
name: frontend-delegation
description: Delegate frontend UI changes to Claude via the CLI. MUST use when building or modifying how a user-facing interface looks (components, layouts, styling, visual states). Not for behavior or logic (business logic, domain modeling, tests, refactoring).
---

Claude lays out and styles front-facing UI far better than you — that is the only reason to delegate. So delegate only **how the UI looks** (markup, layout, styling, visual states), never **how it works** (business logic, domain modeling, state and data flow, tests, refactoring).

When UI work has a visual slice, you **MUST** delegate that slice to Claude. Do not build the UI yourself.

## Writing the prompt

The agent can reach the codebase, the issue tracker, and other project resources on its own. So:

- Keep out of the prompt anything the agent can discover by itself. Do not paste file contents or facts it can look up; instead give it a map: which files, directories, components, or issues to look at.
- Spend the prompt on what the agent cannot infer: the precise visual goal, and which specific areas to leave untouched so it does not drift.
- Give enough context for the agent to succeed in one pass, but no more.

## Running via tmux

Run the delegated Claude inside a detached `tmux` session from the repository root. Frontend work can take more than 10 minutes; the long runtime is expected, not a hang.

The agent reports completion by writing a file under `.tmux/`, so you do **not** need to keep reading the tmux pane to track progress. Watch for the report file instead.

```bash
mkdir -p .tmux
SESSION="frontend-delegation-$(date +%s)"

# 1. Write the prompt (including the reporting + cleanup protocol) to a file.
cat > ".tmux/$SESSION.prompt" <<'EOF'
You are implementing only the visual slice of a larger task — how it looks, not how it works.

## Context
<map of relevant files, directories, components, or issues>

## Task
<the precise visual goal>

## In scope
- Markup structure, layout, styling, and visual states (hover, disabled, loading appearance)

## Out of scope — never touch
- Business logic, domain modeling, state and data flow, tests, logic refactoring

## Out of scope — for this task
<specific components or files to leave untouched so you do not drift>

## Minimal wiring
- If the look needs data or a handler that does not exist yet, add only the
  minimal prop/stub/dummy data to render it. Leave the real logic unimplemented,
  marked with `// TODO(logic): <what is needed>`.

## Constraints
- Preserve existing uncommitted changes
- Do not run destructive Git commands
- Do not commit or push.

## Reporting
- Do the work to completion first.
- Only when the work is fully finished, write a completion report to
  `.tmux/$(tmux display-message -p '#S').report.md`. It MUST list every wiring
  seam you left for the main agent: `file:line`, the `// TODO(logic)` marker, and
  what it expects (which prop, data, or handler). Also summarize the changes,
  files changed, and validation run. Writing this file is the signal that you are
  done, so write it only when the work is truly complete.
EOF

# 2. Launch interactive Claude inside a detached tmux session.
#    Keep the pane on exit so a crash stays inspectable.
tmux new-session -d -s "$SESSION" "claude --permission-mode bypassPermissions \"\$(cat '.tmux/$SESSION.prompt')\""
tmux set-option -t "$SESSION" remain-on-exit on

# 3. Record which session and pid are in use, under .tmux/.
printf 'session=%s\npid=%s\n' "$SESSION" "$(tmux list-panes -t "$SESSION" -F '#{pane_pid}')" > ".tmux/$SESSION.info"
```

## Waiting for completion

Run a background poll loop that checks for the report file every ~15s instead of inspecting the pane; don't give up before 10 minutes, and exit only when the file appears or the tmux session dies.

## Picking up the handoff

The subagent only wired the minimal scaffolding to make the UI render. Once it reports done, you implement the real logic behind each seam it left: read the seam list in the report, or recover every seam directly with `rg "TODO\(logic\)"`, then replace each marker with the actual implementation.

## Cleanup

Once you are done with the session (after reading the report, or after inspecting a failure), clean it up yourself:

```bash
tmux kill-session -t "$SESSION"
```
