---
name: implement-plan
description: Execute work plans efficiently while maintaining quality and finishing features
argument-hint: "[plan number (e.g. 1, 00001) or file path]"
disable-model-invocation: true
---

# Work Plan Execution Command

Execute a work plan efficiently while maintaining quality and finishing features.

## Introduction

This command takes a work document (plan, specification, or todo file) and executes it systematically. The focus is on **shipping complete features** by understanding requirements quickly, following existing patterns, and maintaining quality throughout.

## Resolve Plan File

**Argument:** `#$ARGUMENTS`

1. **If argument is provided:**
   - If it looks like a number (e.g. `1`, `12`, `00001`), zero-pad it to 5 digits and find the matching file in `docs/plans/` whose filename starts with that number prefix (e.g. `1` → `00001-*.md`). Use the Glob tool to search for `docs/plans/<padded>-*.md`.
   - If it looks like a file path, use it directly.
   - If no matching file is found, tell the user and ask for a valid plan number or path.

2. **If no argument is provided:**
   - Ask the user: "Which plan should I execute? Please provide a plan number (e.g. `1`, `00012`) or a file path."
   - Do not proceed until a valid plan file is identified.

## Execution Workflow

### Phase 1: Quick Start

1. **Read Plan**

   - Read the work document completely
   - Review any references or links provided in the plan
   - The plan is already reviewed and approved — proceed without asking clarifying questions

2. **Confirm Environment**

   - Work on the current branch as-is (the user has already set the correct branch)
   - Run `git branch --show-current` to note the branch name for reference

3. **Review Task List**
   - The plan's `## Implementation Steps` checkboxes are the single source of truth for progress
   - Read through all steps and their verification checkboxes
   - Identify dependencies and execution order

### Phase 2: Execute

1. **Step Execution Loop**

   Execute each implementation step in order. **A step must be fully completed before moving to the next.**

   ```
   for each step in plan:
     1. Read referenced files and look for similar patterns
     2. Implement following existing conventions
     3. Write tests for new functionality
     4. Run tests — all must pass
     5. Check off ALL verification items for this step ([ ] → [x])
     6. Commit this step (mandatory — see below)
     7. Proceed to next step
   ```

   **Gate rule**: Do NOT start the next step until the current step's verification items are all checked off and committed. If a verification item fails, fix it before proceeding.

   **Step commits are mandatory.** Each completed step gets its own commit. Use Conventional Commits format and stage only files related to the step (not `git add .`).

   **Agent Delegation**: For implementation tasks, delegate to the appropriate engineer agent via the Task tool:

   | Agent | Expertise |
   |-------|-----------|
   | **frontend-engineer** | React, TypeScript, CSS/Tailwind, state management, component design |
   | **backend-engineer** | Python (FastAPI, Django), Node.js (Express, NestJS), APIs, databases |
   | **general-engineer** | Configuration, scripts, CI/CD, documentation, cross-cutting concerns |

   When delegating, provide the plan file path and the specific step to implement. The agent will read all necessary context from the plan.

2. **Follow Existing Patterns**

   - The plan should reference similar code - read those files first
   - Match naming conventions exactly
   - Reuse existing components where possible
   - Follow project coding standards (see CLAUDE.md)
   - When in doubt, grep for similar implementations

3. **Test Continuously**

   - Run relevant tests after each significant change
   - Don't wait until the end to test
   - Fix failures immediately
   - Add new tests for new functionality

4. **Track Progress**
   - Check off plan checkboxes as you complete verification items
   - Update the plan's `## Progress Log` section with dated entries for major milestones (e.g. `- 2026-02-21: Completed Step 1 — database migration`)
   - Note any blockers or unexpected discoveries in the Progress Log
   - Keep user informed of major milestones

### Phase 3: Quality Check

1. **Run Core Quality Checks**

   Always run before submitting:

   ```bash
   # Run full test suite (use project's test command)
   # Examples: bin/rails test, npm test, pytest, go test, etc.

   # Run linting / type checking (per CLAUDE.md)
   ```

2. **Code Review** (Optional - for complex/risky changes)

   Use the `code-reviewer` agent for changes that warrant review:
   - Large refactor affecting many files (10+)
   - Security-sensitive changes (authentication, permissions, data access)
   - Performance-critical code paths
   - Complex algorithms or business logic
   - User explicitly requests thorough review

   Spawn the code-reviewer agent via the Task tool with the branch diff context. If critical issues are found, fix them. Pass simplification opportunities to the `code-simplifier` agent.

   **For most features: tests + linting + following patterns is sufficient.**

3. **Final Validation**
   - All plan checkboxes checked off
   - All tests pass
   - Linting passes
   - Code follows existing patterns
   - No console errors or warnings

### Phase 4: Wrap Up

1. **Create Final Commit** (if uncommitted changes remain)

   Stage only relevant files (not `git add .`) and commit with Conventional Commits format.

### Phase 5: Code Review Loop

Run 2 rounds of automated code review to catch issues before completion. Each round invokes the `/code-review` skill which spawns 6 specialized review agents in parallel.

1. **Round 1: Initial Review**

   Invoke `/code-review` to run the full 6-agent parallel review against `main`. Wait for the synthesized P0/P1/P2 report.

   Update the Progress Log:
   ```
   - YYYY-MM-DD: Code review round 1 — P0: N, P1: N, P2: N — Verdict: [verdict]
   ```

2. **Triage Round 1 Findings**

   Process the merged review report by category:

   | Category | Action |
   |----------|--------|
   | **P0 (Must Fix)** | Fix immediately. Commit each fix individually. |
   | **P1 (Should Fix)** — actionable and straightforward | Fix and commit. |
   | **P1 (Should Fix)** — deferrable (non-merge-blocker) | Record in `docs/tech-debt-tracker.md`. |
   | **P2 (Consider)** | Record in `docs/tech-debt-tracker.md` if worth tracking; otherwise skip. |

   **Tech Debt Tracker format** — create `docs/tech-debt-tracker.md` if it does not exist:

   ```markdown
   # Tech Debt Tracker

   | Date | File | Severity | Finding | Source | Reason Deferred |
   |------|------|----------|---------|--------|-----------------|
   | YYYY-MM-DD | `path/to/file:line` | P1 | Description | [Reviewer tag] | Reason |
   ```

   Append new rows to the bottom of the table. Do not remove existing entries.

   After fixing, update the Progress Log:
   ```
   - YYYY-MM-DD: Round 1 fixes applied — N issues fixed, N deferred to tech-debt-tracker
   ```

3. **Round 2: Verification Review**

   Invoke `/code-review` again. This round catches regressions from Round 1 fixes and issues missed initially.

   Update the Progress Log:
   ```
   - YYYY-MM-DD: Code review round 2 — P0: N, P1: N, P2: N — Verdict: [verdict]
   ```

   If Round 2 finds new P0 issues, fix them immediately and commit. Record any new deferrable P1/P2 in `docs/tech-debt-tracker.md`.

4. **Decision Gate**

   - **0 P0 findings** → Proceed to Phase 6.
   - **P0 findings remain after fixes** → Stop. Report remaining blockers to the user. Do **not** proceed to Phase 6.

   **P1 findings do not block the gate.** Only P0 (Must Fix) findings are merge blockers.

   Update the Progress Log:
   ```
   - YYYY-MM-DD: Review gate — PASSED (0 P0 remaining)
   ```
   or:
   ```
   - YYYY-MM-DD: Review gate — BLOCKED (N P0 remaining) — reported to user
   ```

### Phase 6: Completion

1. **Update Plan Status**

   If the input document has YAML frontmatter with a `status` field, update it to `completed`:
   ```
   status: active  →  status: completed
   ```

   Add a final entry to the Progress Log:
   ```
   - YYYY-MM-DD: Implementation completed
   ```

2. **Summarize to User**
   - List what was completed (steps, features, key commits)
   - Note any items recorded in `docs/tech-debt-tracker.md` as follow-up work
   - Note any other follow-up work identified during implementation
   - Do **not** push or create a PR automatically — wait for the user to request it

---

## Key Principles

### Start Fast, Execute Faster

- The plan is pre-reviewed — jump straight into execution
- Don't wait for perfect understanding - read the plan and move
- The goal is to **finish the feature**, not create perfect process

### The Plan is Your Guide

- Work documents should reference similar code and patterns
- Load those references and follow them
- Don't reinvent - match what exists

### Test As You Go

- Run tests after each change, not at the end
- Fix failures immediately
- Continuous testing prevents big surprises

### Quality is Built In

- Follow existing patterns
- Write tests for new code
- Run linting before pushing
- Use reviewer agents for complex/risky changes only

### Ship Complete Features

- Mark all tasks completed before moving on
- Don't leave features 80% done
- A finished feature that ships beats a perfect feature that doesn't

## Quality Checklist

Before wrapping up, verify:

- [ ] All plan checkboxes checked off
- [ ] Tests pass (run project's test command)
- [ ] Linting passes
- [ ] Code follows existing patterns
- [ ] Commit messages follow conventional format
- [ ] Code review loop completed (2 rounds, 0 P0 remaining)
- [ ] Tech debt tracker updated (if any findings were deferred)
- [ ] Plan status updated and Progress Log entries added

## Common Pitfalls to Avoid

- **Analysis paralysis** - Don't overthink, read the plan and execute
- **Ignoring plan references** - The plan has links for a reason
- **Testing at the end** - Test continuously or suffer later
- **Forgetting to check off plan items** - Track progress or lose track of what's done
- **80% done syndrome** - Finish the feature, don't move on early
- **Over-reviewing simple changes** - Save reviewer agents for complex work
- **Infinite review loops** - The review loop is strictly 2 rounds. If P0 blockers remain after Round 2, report to the user instead of running more rounds
