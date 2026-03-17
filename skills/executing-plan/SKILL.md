---
name: executing-plan
description: Execute work plans efficiently while maintaining quality and finishing features; use only when the user explicitly mentions this skill
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
   - Date (e.g. `2026-02-21`): match `docs/plans/active/<date>-*.md`.
   - Keyword (e.g. `authentication`, `checkout`): match `docs/plans/active/*-*<keyword>*.md`.
   - File path: use directly.
   - If multiple files match, list them and ask the user to choose one.
   - If no file matches, ask for a valid date, keyword, or path.

2. **If no argument is provided:**
   - Try session handoff first:
     - Find the latest assistant message matching `Plan written to docs/plans/active/<filename>.md`.
     - If exactly one candidate exists and the file is present, ask:
       "I found `docs/plans/active/<filename>.md` from this session. Execute this plan? (yes/no)"
     - `yes` → use that file.
     - `no`, missing/invalid candidate, or multiple candidates → ask for date, keyword, or file path (list candidates if multiple).

Do not proceed until a valid plan file is identified and explicitly confirmed by the user.

## Execution Workflow

### Phase 1: Quick Start

**Do NOT pause to summarize your approach or ask for confirmation. Start executing immediately after Resolve Plan File confirmation (the only allowed pre-execution confirmation).**

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

2. **Final Validation**
   - All plan checkboxes checked off
   - All tests pass
   - Linting passes
   - Code follows existing patterns
   - No console errors or warnings

### Phase 4: Wrap Up

1. **Create Final Commit** (if uncommitted changes remain)

   Stage only relevant files (not `git add .`) and commit with Conventional Commits format.

### Phase 5: Completion

1. **Update Plan Status**

   If the input document has YAML frontmatter with a `status` field, update it to `completed`:
   ```
   status: active  →  status: completed
   ```

   If the plan file is under `docs/plans/active/`, move it to `docs/plans/completed/` while keeping the same filename:
   ```
   docs/plans/active/<filename>.md  →  docs/plans/completed/<filename>.md
   ```

   Add a final entry to the Progress Log:
   ```
   - YYYY-MM-DD: Implementation completed
   ```

2. **Summarize to User**
   - List what was completed (steps, features, key commits)
   - Note any follow-up work identified during implementation
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
- [ ] Plan status updated and Progress Log entries added

## Common Pitfalls to Avoid

- **Analysis paralysis** - Don't overthink, read the plan and execute
- **Ignoring plan references** - The plan has links for a reason
- **Testing at the end** - Test continuously or suffer later
- **Forgetting to check off plan items** - Track progress or lose track of what's done
- **80% done syndrome** - Finish the feature, don't move on early
