---
name: planning
description: Transform feature descriptions into well-structured project plans following conventions
argument-hint: "[feature description, bug report, or improvement idea]"
---

# Create a plan for a new feature or bug fix

## Introduction

**Note: The current year is 2026.** Use this when dating plans and searching for recent documentation.

Transform feature descriptions, bug reports, or improvement ideas into well-structured markdown plan files that follow project conventions and best practices.

## Feature Description

<feature_description> #$ARGUMENTS </feature_description>

**If the feature description above is empty, ask the user:** "What would you like to plan? Please describe the feature, bug fix, or improvement you have in mind."

Do not proceed until you have a clear feature description from the user.

## Core Principles

**Default: ask over assume.** When you weigh options internally without asking, that is usually a sign you should have asked. Exploration reduces *bad* questions — it should not eliminate questions.

These principles govern your behavior throughout the entire planning process. They are not steps to follow in order — they are rules to apply at every decision point.

### Explore first, then ask

Ground yourself in the actual environment before asking the user anything. Exploration prepares better questions — it does not replace asking.

Perform at least one targeted exploration pass before asking.

**Exception:** Ask clarifying questions before exploring ONLY if the feature description contains obvious ambiguities or contradictions that cannot be resolved by exploration.

### Two kinds of unknowns

Treat unknowns differently based on their nature:

1. **Discoverable facts** (single correct answer in the codebase) — explore first.
   - Search the codebase: configs, entrypoints, schemas, types, existing patterns.
   - Ask only if: multiple plausible candidates exist, nothing was found but you need specific context, or the ambiguity is actually about product intent.
   - When asking, present concrete candidates (paths, patterns) and recommend one.
   - If the codebase shows a single unambiguous answer, use it. Otherwise, present what you found and ask.

2. **Preferences and tradeoffs** (not discoverable) — ask early.
   - These are intent or implementation choices that cannot be derived from exploration.
   - Provide 2-4 mutually exclusive options with a recommended default.
   - If asked and unanswered, proceed with the recommended option and record it as an assumption.

### Question quality bar

Bias toward asking over assuming. Every question must:
- Materially change the plan, OR
- Confirm or lock an important assumption, OR
- Choose between meaningful tradeoffs

Questions must NOT be answerable by non-mutating exploration.

### One question at a time

Ask one question per message to avoid overwhelming the user. If a topic needs deeper exploration, break it into multiple sequential questions. Prefer multiple-choice with a recommended option when natural choices exist.

## Planning Loop

Cycle through Explore and Clarify until you reach the sufficiency gate. There is no fixed order or fixed number of iterations — use your judgment.

### Explore

Investigate the feature using direct tools and targeted exploration.

- Split exploration into independent research tracks and run them in parallel; focus on coordination and synthesis
- Map entrypoints, data flow, module boundaries, and reusable patterns
- Identify concrete files likely to be created/modified and affected tests
- Review relevant recent commits/reversions for prior decisions and pitfalls
- When external facts materially affect planning decisions, research them early and keep scope tight; prefer primary sources
- Track what you discovered and what remains unknown

### Clarify

Surface remaining unknowns. If you weighed options without asking, that choice likely deserved a question.

- For each remaining unknown, classify it: discoverable fact or preference/tradeoff?
- If discoverable → go back to Explore
- If preference/tradeoff → ask the user

**Gather signals during clarification.** Note:
- **User's familiarity**: Do they know the codebase patterns? Are they pointing to examples?
- **User's intent**: Speed vs thoroughness? Exploration vs execution?
- **Topic risk**: Security, payments, external APIs warrant more caution
- **Uncertainty level**: Is the approach clear or open-ended?

You may loop between Explore and Clarify as many times as needed.

### Sufficiency Gate

**Do not proceed to write the plan until the spec is decision complete.** Check:

- [ ] Goal and success criteria are clear
- [ ] Approach is chosen with rationale
- [ ] Scope is defined (in and out)
- [ ] Key tradeoffs are resolved (or recorded as assumptions with chosen defaults)
- [ ] Affected files and code flow are identified
- [ ] High-risk areas have been researched
- [ ] The implementer will not need to make design decisions

If any item fails, return to Explore or Clarify.

**Announce when ready.** Brief summary of findings and approach, then proceed. The user can redirect if needed.

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

[What and why — describe the goal concisely]

## Proposed Solution

[Chosen approach and rationale]

## Implementation Steps

### Step 1. [Step Title]

[Desired end state and constraints — reference APIs/patterns by name, not implementation code]

**Verification:**

- [ ] [Condition that confirms this step is complete]

---

### Step N. Final Verification

[Describe the full integration check]

**Deliverables:**

- [ ] [Concrete output — endpoint, component, script, etc.]

**Acceptance Criteria:**

- [ ] [User-facing behavior — "when X, then Y"]
- [ ] [Non-functional requirements — performance, security, etc.]
- [ ] All tests pass, typecheck, lint

## Context

### Files to Change

| Action | File | Step |
|--------|------|------|
| Create | `path/to/file` | Step N |
| Modify | `path/to/file` | Step N |

### Key References

- `path/to/file:line` — description

### Notes

- [Caveats or things to watch out for during implementation]

## Progress Log

- YYYY-MM-DD: Plan created
```

**Title & Categorization:**

- Draft clear, searchable issue title (e.g., `Add user authentication`, `Fix cart total calculation`)
- Determine issue type: feat, fix, refactor
- Convert title to filename: `YYYY-MM-DD-<descriptive-name>.md` (kebab-case)
  - Use today's date as the prefix
  - Example: `Add User Authentication` → `2026-02-21-add-user-authentication.md`
  - Keep it descriptive (3-5 words) so plans are findable by context

## Write Plan

Fill in the template using everything gathered during the planning loop:

- Use code examples with syntax highlighting and `file:line` references
- All checkboxes (Verification, Deliverables, Acceptance Criteria) must be unchecked (`- [ ]`) — they are checked off during implementation
- Populate the Files to Change table with every file that will be created or modified
- Include Key References from exploration (file paths, related issues/PRs, and documentation URLs if external research was done)

## Quality Gate

Verify the plan before writing to disk. Every item must pass.

**Completeness:**
- [ ] Title is searchable and descriptive
- [ ] All template sections are filled in (no placeholder text, no TODOs)
- [ ] Files to Change table is complete with Action, File, and Step
- [ ] Every implementation step has a Verification section

**Decision completeness:**
- [ ] An implementer can execute this plan without making design decisions
- [ ] Ambiguous areas are resolved or explicitly called out with chosen defaults
- [ ] Approach rationale is documented (why this approach, not alternatives)
- [ ] Steps describe intent and constraints, not copy-paste code (snippets ≤10 lines OK for contracts or ambiguous patterns)

**Correctness:**
- [ ] File paths reference real files (verified during exploration)
- [ ] Referenced patterns match what actually exists in the codebase
- [ ] No contradictions between sections

**Formatting:**
- [ ] All checkboxes are unchecked
- [ ] Code examples use correct syntax highlighting

If any item fails, fix it before proceeding.

## Write and Commit Plan File

**REQUIRED: Write the plan file to disk before presenting any options.**

```bash
mkdir -p docs/plans/active/
```

Write the complete plan to:

`docs/plans/active/YYYY-MM-DD-<descriptive-name>.md`

After writing the file:
- Stage only the plan file under `docs/plans/active/` (do not use `git add .`)
- Create one Conventional Commit (recommended: `docs(plan): add <descriptive-name> plan`)

Confirm: "Plan written to docs/plans/active/[filename]"

## Output Format

**Filename:** Use today's date and kebab-case descriptive name from Title & Categorization.

```
docs/plans/active/YYYY-MM-DD-<descriptive-name>.md
```

Examples:
- ✅ `docs/plans/active/2026-02-21-add-user-authentication.md`
- ✅ `docs/plans/active/2026-02-21-fix-checkout-race-condition.md`
- ✅ `docs/plans/active/2026-02-21-refactor-api-client-extraction.md`

**Bad examples:**
- ❌ `docs/plans/active/2026-02-21-thing.md` (not descriptive - what "thing"?)
- ❌ `docs/plans/active/2026-02-21-new-feature.md` (too vague - what feature?)
- ❌ `docs/plans/active/add-user-auth.md` (missing date prefix)

Your task is complete when the plan file is written and committed. Stop. Do not offer to implement, do not ask to proceed, do not write code.
