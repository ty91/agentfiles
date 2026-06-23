---
name: frontend-claude
description: Delegate frontend UI changes to Claude via the CLI. Use when building or modifying any user-facing interface (components, layouts, styling, interaction). Do not use for refactoring internal logic.
---

When doing any frontend UI work, you **MUST** delegate it to Claude by running `claude -p <prompt>`. Do not edit the UI yourself.

## Writing the prompt

The agent can reach the codebase, the issue tracker, and other project resources on its own. So:

- Keep out of the prompt anything the agent can discover by itself. Do not paste file contents or facts it can look up; instead give it a map: which files, directories, components, or issues to look at.
- Spend the prompt on what the agent cannot infer: the precise goal of this task, and an explicit out-of-scope list so it does not drift.
- Give enough context for the agent to succeed in one pass, but no more.
