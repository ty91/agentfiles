---
name: code-review
description: Review committed code changes for a resolved git diff target using 3 specialized review agents in parallel
---

# Code Review

Review committed code changes for an explicit git diff range using 3 specialized review agents in parallel, then synthesize findings into a unified P0/P1/P2 report.

## Review Scope

Review only committed changes. Always exclude uncommitted working tree changes, staged-but-uncommitted changes, and untracked files.

Accept only this review target format:

- `A..B` — review the exact diff `A..B`

If no target is provided, stop and ask the user to provide one.
Examples: `main..feature/login`, `release..hotfix`, `HEAD~3..HEAD`

The default branch is always `main`.

If any ref cannot be resolved, stop and report the invalid ref.

## Workflow

### Step 1: Gather Context

Run these commands to understand the review scope:

1. `git branch --show-current` — current branch name
2. Validate the requested target as `LEFT..RIGHT`
3. `git log --oneline LEFT..RIGHT` — commits in scope
4. `git diff --stat LEFT..RIGHT` — files changed summary

Do not use working tree diffs such as `git diff HEAD` for review scope.

### Step 2: Spawn 3 Review Agents in Parallel

Spawn one agent per review point below. Pass each agent:

- current branch
- requested target
- resolved review range
- commit list
- files changed summary

Wait for all agents to complete before proceeding to Step 3.

| # | Agent | Focus |
|---|-------|-------|
| 1 | code-clarity-reviewer | Simplicity, YAGNI, readability, cognitive load |
| 2 | system-design-reviewer | Architecture integrity, boundaries, maintainability |
| 3 | security-reviewer | Injection, XSS, secrets, auth bypass, crypto |

### Step 3: Synthesize Results

After all 3 agents complete:

1. **Collect** all findings from the 3 reports
2. **Classify** each into P0, P1, or P2
3. **Deduplicate** — if multiple reviewers flagged the same file and issue, merge into one finding and note all sources
4. **Tag** each finding with its source:
   - `[Clarity]` — code-clarity-reviewer
   - `[System Design]` — system-design-reviewer
   - `[Security]` — security-reviewer
5. **Determine verdict**:
   - **PASS**: 0 P0, few or no P1
   - **NEEDS WORK**: any P0, or many P1
   - **SIGNIFICANT ISSUES**: multiple P0

## Output Format

```
Code Review: [target]

**Overview**
- Current branch: [branch-name]
- Requested target: [input]
- Resolved review range: [LEFT..RIGHT]
- Commits reviewed: [count]
- Files changed: [count]
- Uncommitted changes: excluded
- Reviewers: 3 (code clarity, system design, security)

**P0 — Must Fix**
**P0** `file:line` `[Source]` — Description
- Details / fix guidance

(or "No P0 issues found.")

**P1 — Should Fix**
**P1** `file:line` `[Source]` — Description
- Recommendation

(or "No P1 issues found.")

**P2 — Consider**
**P2** `file:line` `[Source]` — Description

(or "No P2 issues found.")

**Summary**
P0: N | P1: N | P2: N
Verdict: [PASS / NEEDS WORK / SIGNIFICANT ISSUES]
```

## Important Notes

- This is a read-only review — no files will be modified
- Do not run tests
- Review only committed changes in the resolved range
- The review covers 3 perspectives: code clarity, system design, security
