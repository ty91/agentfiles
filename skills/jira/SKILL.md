---
name: jira
description: Interact with Jira using the local CLI. Use when the user asks about Jira issues, tasks, or tickets.
allowed-tools: Bash(jira:*)
---

# Jira CLI

Before running any command, verify the CLI is available with `jira version`. If the command is not found, inform the user that `jira` CLI is not installed and ask how they'd like to proceed.

## Commands

```bash
# List issues
jira issue list --plain

# List issues filtered by status
jira issue list --plain -s"To Do"

# View an issue
jira issue view {ISSUE-KEY} --plain

# View an issue with N recent comments
jira issue view {ISSUE-KEY} --plain --comments {N}

# Add a comment
echo "comment body" | jira issue comment add {ISSUE-KEY}
```

## Comments

When adding a comment, always append `_Written by Claude_` at the end of the body.

For other operations, run `jira --help`.
