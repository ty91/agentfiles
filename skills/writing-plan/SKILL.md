---
name: writing-plan
description: Transform feature descriptions into well-structured implementation plans. Use when you need to plan a feature, bug fix, or refactor before coding.
---


# Create Plan

## Introduction

**Note: The current year is 2026.** Use this when dating plans and searching for recent documentation.

Transform feature descriptions, bug reports, or improvement ideas into well-structured markdown plan files that follow project conventions and best practices.

## Feature Description

Input can come from a direct user message or skill arguments.

- If arguments are provided (`#$ARGUMENTS`), treat them as the initial feature description (explicit override).
- If arguments are missing or empty, resolve input in this order:
  1. Locate the most recent brainstorming output at `docs/plans/*-design.md` and use it as the primary input.
  2. If multiple design docs are plausible candidates, show the candidates and ask the user to pick one.
  3. If no design doc is found, ask the user: "What would you like to plan? Please describe the feature, bug fix, or improvement you have in mind."

Do not proceed until you have a clear feature description from user input, a validated design doc, or both.

### Design Doc Metadata Check (When Using Brainstorming Output)

When the input source is a design doc from brainstorming, inspect frontmatter metadata first:

- `status: approved`
- `approved_at: <date-time>`
- `source: brainstorming`

If metadata is missing or incomplete:
- Prefer proceeding if the design content is still decision-useful.
- Ask only the minimum clarification needed.
- Record missing metadata and any fallback assumptions in the final plan notes.

## Core Principles

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
   - Never ask questions you can answer from the environment.

2. **Preferences and tradeoffs** (not discoverable) — ask early.
   - These are intent or implementation choices that cannot be derived from exploration.
   - Provide 2-4 mutually exclusive options with a recommended default.
   - If asked and unanswered, proceed with the recommended option and record it as an assumption.

### Question quality bar

Bias toward asking over assuming. Every question must:
- Materially change the plan, OR
- Confirm or lock an important assumption, OR
- Choose between meaningful tradeoffs

Questions must NOT be answerable by non-mutating exploration. Prefer multiple-choice with a recommended option when natural choices exist.

## Research Strategy (Codex Subagents)

Use Codex subagents aggressively during research. For non-trivial planning, spawn multiple focused subagents in parallel instead of doing all exploration in a single thread.

When assigning subagents, split research by concern so each subagent owns one clear area:
- architecture and boundaries
- maintainability and simplicity
- security/privacy and compliance risk
- test strategy and reliability
- UI/UX constraints (frontend tasks only)

### Research Priorities

When researching, cover these areas explicitly:

1. **Codebase research**
   - Map entrypoints, data flow, and module boundaries.
   - Find existing patterns to reuse and constraints to respect.
   - Identify concrete files likely to be created/modified and affected tests.

2. **Git history research**
   - Review recent relevant commits, reversions, and related changes.
   - Capture rationale behind previous decisions and known pitfalls.
   - Prefer stable patterns that survived prior iterations.

3. **External research (when needed)**
   - Use for unstable or high-risk domains (security, compliance, external APIs, recent standards).
   - Prefer primary sources (official docs/specs) over secondary summaries.
   - Record source links and publication/update dates in plan notes when they materially influence decisions.

### Subagent Operating Rules

- Prefer `explorer` for codebase and git-history fact-finding.
- Use `default` to synthesize findings, resolve ambiguities, and produce planning decisions.
- Use `awaiter` whenever you must wait on long-running checks or monitoring.
- Avoid `worker` during planning research unless a non-editing execution task cannot be handled by `explorer`/`default`.
- Spawn focused subagents with narrow scopes (one risk/domain per subagent).
- Run independent investigations in parallel, then synthesize into one decision-ready plan.
- If findings conflict, call it out, choose a safer default, and document the tradeoff.
- Do not ask the user questions that can be resolved by codebase or git-history exploration.

## Planning Loop

Cycle through Explore and Clarify until you reach the sufficiency gate. There is no fixed order or fixed number of iterations — use your judgment.

### Explore

Investigate the feature using direct tools and Codex subagents.

- Read relevant code, configs, and documentation directly
- Spawn focused subagents based on what you actually need to learn (prefer `explorer` and `default`)
- Track what you discovered and what remains unknown

Use the subagent concern areas above when deciding which subagents to spawn and when.

### Clarify

Surface remaining unknowns. If you weighed options without asking, that choice likely deserved a question.

- For each remaining unknown, classify it: discoverable fact or preference/tradeoff?
- If discoverable → go back to Explore
- If preference/tradeoff → ask the user
- If an approved brainstorming design doc is selected, use **delta clarification only**:
  - Do not restart full requirements interviews.
  - Ask only for unresolved design questions, conflicts with newer user instructions, or required missing details for implementation planning.

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

### Decision Trace

- [Decision] — Source: `docs/plans/<design-doc>.md:line`

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

### Source Design Doc

- Path: `docs/plans/<topic>-design.md` (or `none`)
- Metadata: `status=<value>, approved_at=<value>, source=<value>`

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
- Include Source Design Doc details and map major decisions with traceable references

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
- [ ] Source design doc is recorded in Context (or explicitly marked as none)
- [ ] Plan decisions are consistent with the source design doc (or deviations are explicitly justified)
- [ ] Open questions from the source design doc are resolved or carried forward as explicit assumptions
- [ ] If no source design doc is used, the reason and fallback validation path are documented in Notes

**Formatting:**
- [ ] All checkboxes are unchecked
- [ ] Code examples use correct syntax highlighting

If any item fails, fix it before proceeding.

## Write Plan File

**REQUIRED: Write the plan file to disk before presenting any options.**

```bash
mkdir -p docs/plans/
```

Use the Write tool to save the complete plan to `docs/plans/YYYY-MM-DD-<descriptive-name>.md`. This step is mandatory and cannot be skipped.

Confirm: "Plan written to docs/plans/[filename]"

## Design Specification (Conditional)

**If the plan involves frontend UI** (pages, components, layouts, visual interfaces):

Spawn the frontend-designer agent with the plan file path. The agent will read the plan, analyze the codebase's existing design patterns, and insert a `## Design Specification` section into the plan file (between `## Proposed Solution` and `## Implementation Steps`).

- Task frontend-designer(plan_file_path)

Wait for the agent to complete, then confirm: "Design specification added to docs/plans/[filename]"

**Skip this step** if the plan is purely backend, infrastructure, or has no visual component.

## Output Format

**Filename:** Use today's date and kebab-case descriptive name from Title & Categorization.

```
docs/plans/YYYY-MM-DD-<descriptive-name>.md
```

Examples:
- ✅ `docs/plans/2026-02-21-add-user-authentication.md`
- ✅ `docs/plans/2026-02-21-fix-checkout-race-condition.md`
- ✅ `docs/plans/2026-02-21-refactor-api-client-extraction.md`

**Bad examples:**
- ❌ `docs/plans/2026-02-21-thing.md` (not descriptive - what "thing"?)
- ❌ `docs/plans/2026-02-21-new-feature.md` (too vague - what feature?)
- ❌ `docs/plans/add-user-auth.md` (missing date prefix)

Your task is complete when the plan file is written to disk. Stop. Do not offer to implement, do not ask to proceed, do not write code.
