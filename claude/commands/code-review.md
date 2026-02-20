---
allowed-tools: Read, Glob, Grep, Task, Bash(git:*)
description: Review code changes between current branch and main
---

# Review Code Changes

You review all code changes between the current branch and main using the `code-reviewer` subagent.

## Context

- Current branch: !`git branch --show-current`

## Branch Validation

**IMPORTANT:** Before proceeding, check if the current branch is `main` or `master`.

If on main/master branch, respond with:
```
You are on the main branch. The /review command reviews changes between your feature branch and main.

Please checkout a feature branch first, then run /review again.
```
Then stop - do not proceed with the review.

## Git Context

If on a feature branch, gather the following context:

1. **Commits on this branch**: !`git log main..HEAD --oneline 2>/dev/null || git log master..HEAD --oneline 2>/dev/null || echo "No commits found"`
2. **Files changed summary**: !`git diff main...HEAD --stat 2>/dev/null || git diff master...HEAD --stat 2>/dev/null || echo "No changes found"`
3. **Uncommitted changes**: !`git diff HEAD --stat`

## Review Process

### Step 1: Spawn code-reviewer Agent

Use the Task tool to spawn a `code-reviewer` agent with the following context:

```
Review Mode: Branch diff review (no plan alignment required)

Branch: [current branch name]
Base: main

Commits to review:
[list from git log]

Files changed:
[list from git diff --stat]

Instructions:
1. Run `git diff main...HEAD` (or master...HEAD) to get the full diff
2. If there are uncommitted changes, also run `git diff HEAD`
3. Read modified files as needed for context
4. Focus on: code quality, security vulnerabilities, adherence to project patterns
5. Do NOT evaluate against any plan - this is a standalone branch review
6. Produce a code review report using your standard format (Critical Issues, Warnings, Suggestions)
```

### Step 2: Report Results

After the code-reviewer agent completes:

1. Display the full code review report to the user
2. Summarize key findings:
   - Number of critical issues found
   - Number of warnings
   - Number of suggestions

## Output Format

The final output should include:

```markdown
## Branch Code Review: [branch-name]

### Summary
- Commits reviewed: [count]
- Files changed: [count]
- Critical issues: [count]
- Warnings: [count]
- Suggestions: [count]

### Full Review Report
[code-reviewer output]
```

## Important Notes

- This is a **read-only** review - no files will be modified
- The review focuses on code quality, not plan alignment
- Use this command to get feedback before creating a PR
