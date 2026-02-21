---
name: code-review
description: Review code changes between current branch and main using 6 specialized review agents in parallel
---

# Code Review

Review all code changes between the current branch and main using 6 specialized review agents in parallel, then synthesize findings into a unified P0/P1/P2 report.

## Branch Validation

Check if the current branch is `main` or `master`. If so, respond:

"You are on the main branch. This command reviews changes between a feature branch and main. Please checkout a feature branch first."

Then stop.

## Workflow

### Step 1: Gather Context

Run these commands to understand the review scope:

1. `git branch --show-current` — current branch name
2. `git log main..HEAD --oneline` — commits on this branch
3. `git diff main...HEAD --stat` — files changed summary
4. `git diff HEAD --stat` — uncommitted changes

### Step 2: Spawn 6 Review Agents in Parallel

Spawn one agent per review point below. Pass each agent the branch context (branch name, commit list, files changed). Wait for all agents to complete before proceeding to Step 3.

| # | Agent | Focus |
|---|-------|-------|
| 1 | code-simplicity-reviewer | YAGNI, unnecessary complexity, redundancy |
| 2 | architecture-strategist | Architectural patterns, SOLID, dependency structure |
| 3 | readability-reviewer | Cognitive load, C1-C6 readability principles |
| 4 | security-reviewer | Injection, XSS, secrets, auth bypass, crypto |
| 5 | maintainability-reviewer | Coupling, cohesion, naming, modularity, testability |
| 6 | test-flakiness-reviewer | Timing deps, shared state, non-determinism, order dependence |

### Step 3: Synthesize Results

After all 6 agents complete:

1. **Collect** all findings from the 6 reports
2. **Classify** each into P0, P1, or P2
3. **Deduplicate** — if multiple reviewers flagged the same file and issue, merge into one finding and note all sources
4. **Tag** each finding with its source:
   - `[Simplicity]` — code-simplicity-reviewer
   - `[Architecture]` — architecture-strategist
   - `[Readability]` — readability-reviewer
   - `[Security]` — security-reviewer
   - `[Maintainability]` — maintainability-reviewer
   - `[Test Flakiness]` — test-flakiness-reviewer
5. **Determine verdict**:
   - **PASS**: 0 P0, few or no P1
   - **NEEDS WORK**: any P0, or many P1
   - **SIGNIFICANT ISSUES**: multiple P0

## Output Format

```
Code Review: [branch-name]

**Overview**
- Commits reviewed: [count]
- Files changed: [count]
- Reviewers: 6 (simplicity, architecture, readability, security, maintainability, test-flakiness)

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
- The review covers 6 perspectives: simplicity, architecture, readability, security, maintainability, test flakiness
