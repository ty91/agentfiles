---
allowed-tools: Bash(git add:*), Bash(git rm:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

- Based on the above changes, create git commits. ALWAYS write semantic commit messages in English (eg. `feat: add user authentication with JWT tokens`)
- If the changes contain multiple unrelated modifications, split them into separate commits for better clarity and history tracking.
- Only commit changes you made in this session. Do not commit pre-existing uncommitted changes.
