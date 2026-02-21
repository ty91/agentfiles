---
allowed-tools: Read, Glob, Grep, Task, Bash(git:*)
description: Review code changes between current branch and main
---

# Review Code Changes

Review all code changes between the current branch and main using 4 specialized review agents in parallel, then synthesize findings into a unified P0/P1/P2 report.

## Context

- Current branch: !`git branch --show-current`

## Branch Validation

**IMPORTANT:** Before proceeding, check if the current branch is `main` or `master`.

If on main/master branch, respond with:
```
You are on the main branch. The /code-review command reviews changes between your feature branch and main.

Please checkout a feature branch first, then run /code-review again.
```
Then stop - do not proceed with the review.

## Git Context

If on a feature branch, gather the following context:

1. **Commits on this branch**: !`git log main..HEAD --oneline 2>/dev/null || git log master..HEAD --oneline 2>/dev/null || echo "No commits found"`
2. **Files changed summary**: !`git diff main...HEAD --stat 2>/dev/null || git diff master...HEAD --stat 2>/dev/null || echo "No changes found"`
3. **Uncommitted changes**: !`git diff HEAD --stat`

## Review Process

### Step 1: Spawn 4 Review Agents in Parallel

Use the Task tool to spawn all 4 agents **in a single message** so they run concurrently. Pass each agent the same git context but with its own review focus.

**Shared context for all agents:**

```
Branch: [current branch name]
Base: main

Commits to review:
[list from git log]

Files changed:
[list from git diff --stat]

Instructions:
1. Run `git diff main...HEAD` (or master...HEAD) to get the full diff
2. If there are uncommitted changes, also run `git diff HEAD`
3. Read modified files as needed for full context
4. Do NOT evaluate against any plan - this is a standalone branch review
5. Produce your standard review report with P0/P1/P2 findings
```

**Agent-specific prompts:**

| # | subagent_type | Review Focus |
|---|---------------|--------------|
| 1 | code-reviewer | Code quality, security vulnerabilities, correctness, error handling |
| 2 | readability-reviewer | Cognitive load, readability (C1-C6 principles) |
| 3 | code-simplicity-reviewer | YAGNI violations, unnecessary complexity, redundancy |
| 4 | architecture-strategist | Architectural patterns, SOLID principles, dependency structure |

### Step 2: Synthesize Results

After all 4 agents complete, synthesize their findings into a single unified report:

1. **Collect** all findings from the 4 reports
2. **Classify** each finding into P0, P1, or P2
3. **Deduplicate** — if multiple reviewers flagged the same issue, merge into one finding and note all sources
4. **Tag** each finding with its reviewer source:
   - `[Quality]` — from code-reviewer
   - `[Readability]` — from readability-reviewer
   - `[Simplicity]` — from code-simplicity-reviewer
   - `[Architecture]` — from architecture-strategist
5. **Determine verdict**:
   - **PASS**: 0 P0, few or no P1
   - **NEEDS WORK**: any P0, or many P1
   - **SIGNIFICANT ISSUES**: multiple P0

## Output Format

```markdown
## Code Review: [branch-name]

### Overview
- Commits reviewed: [count]
- Files changed: [count]
- Reviewers: code-reviewer, readability-reviewer, code-simplicity-reviewer, architecture-strategist

### P0 — Must Fix
1. **[File:Line]** `[Source]` — [Issue description]
   - [Details / fix guidance]

(or "No P0 issues found.")

### P1 — Should Fix
1. **[File:Line]** `[Source]` — [Issue description]
   - [Details / recommendation]

(or "No P1 issues found.")

### P2 — Consider
- **[File:Line]** `[Source]` — [Issue description]

(or "No P2 issues found.")

### Summary

| Severity | Count |
|----------|-------|
| P0       | N     |
| P1       | N     |
| P2       | N     |

**Verdict: [PASS / NEEDS WORK / SIGNIFICANT ISSUES]**
```

## Important Notes

- This is a **read-only** review — no files will be modified
- The review covers 4 perspectives: quality, readability, simplicity, architecture
- Use this command to get comprehensive feedback before creating a PR
