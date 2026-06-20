---
name: to-tasks
description: Convert an issue with an approved [pi:plan] comment into ordered native sub-issues. Use after to-plan when the user asks to split a planned issue into implementation tasks, task breakdown, child issues, sub-issues, or agent-sized work items.
---

# To Tasks

## Overview

Split a planned issue into small, verifiable implementation tasks by creating native sub-issues under the planned parent issue. If the work splits into three tasks, create three sub-issues under the issue that contains the `[pi:plan]` comment.

Do not write a task-breakdown comment on the parent issue. The sub-issues are the task breakdown.

## Target

Start from the planned parent issue the user provides.

If the target is missing or ambiguous, ask which planned issue to split. Do not choose one yourself.

Read the parent issue body, its comments, and the `[pi:plan]` comment. If no `[pi:plan]` comment exists, stop and ask whether to run `to-plan` first. If the plan looks stale, incomplete, or contradicted by the codebase, stop and ask whether to revise the plan before creating sub-issues.

If the repo has `docs/agents/issue-tracker.md`, follow it for fetching and creating issues. Otherwise, use the repo's configured issue-tracker workflow. If the workflow is unclear or does not support native parent/sub-issue relationships, stop and ask how to create sub-issues for this repo.

## Output

Create one native sub-issue per implementation task under the planned parent issue.

Each sub-issue title should be short and action-oriented:

```text
Task [N]: [Short descriptive title]
```

Each sub-issue body should start with:

```markdown
[pi:task]

Parent: <parent issue URL>
Plan: <link to [pi:plan] comment when available>
Order: N of M
```

Use the tracker's native parent/sub-issue relationship, not a checklist, not a parent issue comment, and not a local file. If a sub-issue already exists for the same task, update it instead of creating a duplicate when the tracker supports updates; otherwise stop and ask before duplicating work.

## GitHub Notes

Prefer `gh` when the repo uses GitHub Issues.

For GitHub CLI v2.94.0 or newer, create sub-issues directly with the parent flag:

```bash
gh issue create --repo OWNER/REPO --parent <parent-issue-number-or-url> --title "Task 1: ..." --body-file /tmp/task-1.md
```

If the installed `gh issue create --help` does not show `--parent`, create the child issue first, then link it with GitHub GraphQL `addSubIssue`:

```bash
child_url=$(gh issue create --repo OWNER/REPO --title "Task 1: ..." --body-file /tmp/task-1.md)
parent_id=$(gh issue view <parent-issue-number-or-url> --repo OWNER/REPO --json id --jq .id)
child_id=$(gh issue view "$child_url" --repo OWNER/REPO --json id --jq .id)
gh api graphql \
  -f query='mutation($parent:ID!,$child:ID!){ addSubIssue(input:{issueId:$parent,subIssueId:$child,replaceParent:false}){ issue { number url } subIssue { number url } } }' \
  -F parent="$parent_id" \
  -F child="$child_id"
```

If neither `--parent` nor GraphQL linking is available, ask the user to upgrade `gh` or provide the repo's sub-issue workflow. Do not silently fall back to a plain issue without a parent relationship.

## Task Writing Process

### 1. Read And Reconcile

- Read the parent issue, `[pi:plan]` comment, and relevant code.
- Identify dependency order and natural vertical slices.
- Keep tasks aligned with the approved plan. Do not expand scope beyond the parent issue.

### 2. Slice Vertically

Prefer vertical, user-verifiable slices over horizontal layers.

**Bad:**

```text
Task 1: Build entire database schema
Task 2: Build all API endpoints
Task 3: Build all UI components
```

**Good:**

```text
Task 1: User can create an account
Task 2: User can log in
Task 3: User can create a task
```

Each sub-issue should leave the system in a working state when possible.

### 3. Keep Tasks Agent-Sized

Use this sizing guide:

| Size | Files | Scope |
|------|-------|-------|
| XS | 1 | Single function or config change |
| S | 1-2 | One component or endpoint |
| M | 3-5 | One feature slice |
| L | 5-8 | Break down if possible |
| XL | 8+ | Too large; split before publishing |

Break a task down further when:

- It would take more than one focused session.
- Acceptance criteria cannot fit in three bullets.
- It touches two or more independent subsystems.
- The title needs "and" to describe the work.

### 4. Write Each Sub-Issue

Write sub-issues primarily in Korean. Established technical terms may remain in English when they are clearer or conventional.

Use this body structure:

```markdown
[pi:task]

Parent: <parent issue URL>
Plan: <plan comment URL>
Order: N of M

## Description
[One paragraph explaining what this task accomplishes.]

## Acceptance Criteria
- [ ] [Specific, testable condition]
- [ ] [Specific, testable condition]

## Verification
- [ ] Tests pass: `[command]`
- [ ] Build/typecheck succeeds: `[command]`
- [ ] Manual check: [description of what to verify]

## Dependencies
- [Task numbers or sub-issue URLs this depends on, or "None"]

## Files Likely Touched
- `src/path/to/file.ts`
- `tests/path/to/test.ts`

## Estimated Scope
[XS/S/M/L with a short reason]
```

### 5. Verify Relationships

After creating or updating sub-issues:

- Re-read the parent issue and confirm every task is attached as a sub-issue.
- Re-read each sub-issue and confirm the parent relationship is present.
- Confirm task order and dependencies are clear.
- Report the parent issue URL and the created/updated sub-issue URLs.

## Verification

Before finishing, confirm:

- [ ] The target parent issue has a `[pi:plan]` comment.
- [ ] No parent `[pi:task-breakdown]` comment was created.
- [ ] Every implementation task is represented as a native sub-issue.
- [ ] Every sub-issue has `[pi:task]`, acceptance criteria, verification, dependencies, and estimated scope.
- [ ] No task is XL-sized.
- [ ] The parent/sub-issue relationships were verified after creation.
