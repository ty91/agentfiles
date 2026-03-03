---
name: planning
description: Transform feature descriptions into well-structured project plans following conventions
argument-hint: "[feature description, bug report, or improvement idea]"
---

# Create a Plan for a New Feature or Bug Fix

## Overview

Turn a feature description, bug report, or improvement idea into one executable markdown plan.

**Note: The current year is 2026.** Use real dates when naming files and validating recent references.

## Feature Description

<feature_description> #$ARGUMENTS </feature_description>

If the feature description is empty, ask:
"What would you like to plan? Please describe the feature, bug fix, or improvement you have in mind."

Do not proceed without a clear feature description.

<HARD-GATE>
Do NOT write the final plan file until all unknowns are resolved and the clarity gate passes.
Do NOT take implementation actions (no coding, no scaffolding, no implementation skills).
</HARD-GATE>

## Checklist

You MUST create a task for each item and complete them in order:

1. **Explore project context** - codebase, git history, docs, and existing patterns
2. **Ask clarifying questions** - one at a time, focused on unresolved intent/tradeoffs
3. **Iterate Explore/Clarify** - loop until no unknowns remain
4. **Pass clarity gate** - lock scope, approach, and success criteria
5. **Write and validate plan** - fill template and pass quality gate
6. **Write and commit plan file** - save to `docs/plans/YYYY-MM-DD-<descriptive-name>.md` and commit

## Key Principles

- **Explore before ask** - investigate discoverable facts first
- **Two kinds of unknowns** - `discoverable fact` (explore) vs `preference/tradeoff` (ask)
- **One question at a time** - ask one high-impact question per message
- **Option-first clarification** - when asking, provide 2-4 options with a recommended default
- **No open unknowns before writing** - pass clarity gate before drafting final plan
- **Planning only** - no implementation actions during this skill

## Process Flow

```dot
digraph planning {
    "Resolve feature description" [shape=box];
    "Explore context" [shape=box];
    "Clarify unknowns" [shape=box];
    "Unknowns remaining?" [shape=diamond];
    "Clarity gate" [shape=diamond];
    "Write plan" [shape=box];
    "Quality gate" [shape=diamond];
    "Write file + commit" [shape=box];
    "Complete" [shape=doublecircle];

    "Resolve feature description" -> "Explore context";
    "Explore context" -> "Clarify unknowns";
    "Clarify unknowns" -> "Unknowns remaining?";
    "Unknowns remaining?" -> "Explore context" [label="yes"];
    "Unknowns remaining?" -> "Clarity gate" [label="no"];
    "Clarity gate" -> "Explore context" [label="fail"];
    "Clarity gate" -> "Write plan" [label="pass"];
    "Write plan" -> "Quality gate";
    "Quality gate" -> "Write plan" [label="fail"];
    "Quality gate" -> "Write file + commit" [label="pass"];
    "Write file + commit" -> "Complete";
}
```

## The Process

**Explore first:**
- Map entrypoints, data flow, module boundaries, and reusable patterns
- Identify concrete files likely to be created/modified and affected tests
- Review relevant recent commits/reversions for prior decisions and pitfalls
- Do external research only when risk is high or information is unstable; prefer primary sources

**Clarify unknowns:**
- Classify each unknown as either `discoverable fact` or `preference/tradeoff`
- Discoverable facts: explore the environment instead of asking
- Preferences/tradeoffs: ask the user with 2-4 options and a recommended default
- Ask one question per message; avoid questions answerable by exploration

**Subagent operating rules (keep concise, use aggressively when helpful):**
- Use `explorer` for codebase and git-history fact-finding
- Use `default` to synthesize findings and resolve ambiguities
- Use `awaiter` when waiting on long-running checks or monitoring
- Avoid `worker` during planning unless a non-editing execution task truly requires it
- Split investigations by concern (architecture, maintainability, security/compliance, testing, UI/UX)
- Run independent investigations in parallel; if findings conflict, choose the safer default and document tradeoffs

## Clarity Gate

Do not write the plan until every item passes:

- [ ] Goal and success criteria are explicit
- [ ] Scope is clear (in/out)
- [ ] Approach is chosen with rationale
- [ ] Key tradeoffs are resolved
- [ ] Affected files and code flow are identified
- [ ] High-risk areas are researched
- [ ] No open unknowns remain
- [ ] Implementer will not need to make design decisions

## Plan Template

```markdown
---
title: [Issue Title]
type: [feat|fix|refactor]
status: active
date: YYYY-MM-DD
---

# [Issue Title]

## Overview

[What and why]

## Proposed Solution

[Chosen approach and rationale]

## Implementation Steps

### Step 1. [Step Title]

[Desired end state and constraints]

**Verification:**

- [ ] [Completion condition]

---

### Step N. Final Verification

[Full integration check]

**Deliverables:**

- [ ] [Concrete output]

**Acceptance Criteria:**

- [ ] [User-facing behavior]
- [ ] [Non-functional requirements]
- [ ] All tests pass, typecheck, lint

## Context

### Files to Change

| Action | File | Step |
|--------|------|------|
| Create | `path/to/file` | Step N |
| Modify | `path/to/file` | Step N |

### Key References

- `path/to/file:line` - description

### Notes

- [Implementation caveats]

## Progress Log

- YYYY-MM-DD: Plan created
```

## Quality Gate

Verify before writing to disk:

- [ ] Title is clear and searchable
- [ ] No placeholders or TODO text remain
- [ ] Every step has verification criteria
- [ ] Files-to-change table is complete
- [ ] No contradictions across sections
- [ ] Paths/patterns were verified during exploration
- [ ] All checkboxes remain unchecked (`- [ ]`)

## Write and Commit

**Filename:** `docs/plans/YYYY-MM-DD-<descriptive-name>.md` (kebab-case, descriptive)

Examples:
- `docs/plans/2026-02-21-add-user-authentication.md`
- `docs/plans/2026-02-21-fix-checkout-race-condition.md`

After writing the file:
- Stage only the plan file under `docs/plans/` (do not use `git add .`)
- Create one Conventional Commit (recommended: `docs(plan): add <descriptive-name> plan`)

Your task is complete when the plan file is written and committed. Stop there.
