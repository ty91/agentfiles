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

## Running the command

Run `claude -p` from the repository root and pass the prompt through stdin with a quoted heredoc. Frontend work can take more than 10 minutes, so allow a generous tool timeout (commonly 1800-3600 seconds).

```bash
claude -p <<'EOF'
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

## Report
summarize the changes, files changed, validation run, and risks or follow-ups.
EOF
```
