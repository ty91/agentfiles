---
name: workflows:plan
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

### 0. Idea Refinement

Refine the idea through collaborative dialogue using the **AskUserQuestion tool**:

- Ask questions one at a time to understand the idea fully
- Prefer multiple choice questions when natural options exist
- Focus on understanding: purpose, constraints and success criteria
- Continue until the idea is clear OR user says "proceed"

**Gather signals for research decision.** During refinement, note:

- **User's familiarity**: Do they know the codebase patterns? Are they pointing to examples?
- **User's intent**: Speed vs thoroughness? Exploration vs execution?
- **Topic risk**: Security, payments, external APIs warrant more caution
- **Uncertainty level**: Is the approach clear or open-ended?

**Skip option:** If the feature description is already detailed, offer:
"Your description is clear. Should I proceed with research, or would you like to refine it further?"

## Main Tasks

### 1. Local Research (Always Runs - Parallel)

<thinking>
First, I need to understand the project's conventions, existing patterns, and code structure. This is fast and local - it informs whether external research is needed.
</thinking>

Run these agents **in parallel** to gather local context:

- Task conventions-researcher(feature_description)
- Task code-flow-researcher(feature_description)
- Task git-history-analyzer(feature_description)

**What to look for:**
- **Conventions research:** existing patterns, CLAUDE.md guidance, coding standards, project rules
- **Code flow research:** code structure, module boundaries, execution flow, data flow relevant to the feature
- **Git history research:** recent changes in the affected area, reverted approaches, rationale behind current design decisions, change frequency and stability

These findings inform the next step.

### 1.5. Research Decision

Based on signals from Step 0 and findings from Step 1, decide on external research.

**High-risk topics → always research.** Security, payments, external APIs, data privacy. The cost of missing something is too high. This takes precedence over speed signals.

**Strong local context → skip external research.** Codebase has good patterns, CLAUDE.md has guidance, user knows what they want. External research adds little value.

**Uncertainty or unfamiliar territory → research.** User is exploring, codebase has no examples, new technology. External perspective is valuable.

**Announce the decision and proceed.** Brief explanation, then continue. User can redirect if needed.

Examples:
- "Your codebase has solid patterns for this. Proceeding without external research."
- "This involves payment processing, so I'll research current best practices first."

### 1.5b. External Research (Conditional)

**Only run if Step 1.5 indicates external research is valuable.**

Run this agent:

- Task best-practices-researcher(feature_description)

### 1.6. Consolidate Research

After all research steps complete, consolidate findings:

- Document relevant file paths from code flow research (e.g., `app/services/example_service.rb:42`)
- Note external documentation URLs and best practices (if external research was done)
- List related issues or PRs discovered
- Capture CLAUDE.md conventions and project patterns

**Optional validation:** Briefly summarize findings and ask if anything looks off or missing before proceeding to planning.

### 2. Plan Structure

<thinking>
Think like a product manager - what would make this plan clear and actionable? Consider multiple perspectives.
</thinking>

**Plan Template:**

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

[Describe what needs to be done in prose]

**Verification:**

- [ ] [Condition that confirms this step is complete]

---

### Step N. Final Verification

[Describe the full integration check]

**Verification:**

- [ ] [Tests / typecheck / lint / etc.]

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
- Convert title to filename: 5-digit sequential number prefix, kebab-case
  - Find the highest existing number in `docs/plans/` and increment by 1 (start at `00001` if empty)
  - Example: `Add User Authentication` → `00012-add-user-authentication.md`
  - Keep it descriptive (3-5 words) so plans are findable by context

### 3. Write Content

Fill in the template sections with research findings:

- Use code examples with syntax highlighting and `file:line` references
- All verification checkboxes must be unchecked (`- [ ]`) — they are checked off during implementation
- Populate the Files to Change table with every file that will be created or modified
- Include Key References from the consolidated research (Step 1.6)

### 4. Final Review

**Pre-submission Checklist:**

- [ ] Title is searchable and descriptive
- [ ] All template sections are filled in
- [ ] Verification checkboxes are all unchecked
- [ ] Files to Change table is complete with Action, File, and Step

## Write Plan File

**REQUIRED: Write the plan file to disk before presenting any options.**

```bash
mkdir -p docs/plans/
```

Use the Write tool to save the complete plan to `docs/plans/NNNNN-<descriptive-name>.md`. This step is mandatory and cannot be skipped.

Confirm: "Plan written to docs/plans/[filename]"

## Output Format

**Filename:** Use the sequential number and kebab-case filename from Step 2 Title & Categorization.

```
docs/plans/NNNNN-<descriptive-name>.md
```

Examples:
- ✅ `docs/plans/00012-add-user-authentication.md`
- ✅ `docs/plans/00013-fix-checkout-race-condition.md`
- ✅ `docs/plans/00014-refactor-api-client-extraction.md`
- ❌ `docs/plans/00012-thing.md` (not descriptive - what "thing"?)
- ❌ `docs/plans/00012-new-feature.md` (too vague - what feature?)
- ❌ `docs/plans/add-user-auth.md` (missing number prefix)

NEVER CODE! Just research and write the plan.
