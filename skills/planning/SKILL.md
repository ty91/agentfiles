---
name: planning
description: Transform feature descriptions into well-structured project plans following conventions; use only when the user explicitly mentions this skill
argument-hint: "[feature description, bug report, or improvement idea]"
---

# Create a Plan for a New Feature or Bug Fix

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

### Explore First, Then Ask

Ground yourself in the actual environment before asking the user anything. Exploration prepares better questions — it does not replace asking.

As a default, perform at least one targeted exploration pass before asking any clarifying question.

**Exception:** Ask clarifying questions before exploring ONLY if the feature description contains obvious ambiguities or contradictions that cannot be resolved by exploration.

This default also applies to preference/tradeoff questions: do a lightweight exploration pass first so you can ask with concrete options grounded in the actual codebase.

### Two Kinds of Unknowns

Treat unknowns differently based on their nature:

1. **Discoverable facts** (single correct answer in the codebase) — explore first.
   - Search the codebase: configs, entrypoints, schemas, types, existing patterns.
   - Ask only if: multiple plausible candidates exist, nothing was found but you need specific context, or the ambiguity is actually about product intent.
   - When asking, present concrete candidates (paths, patterns) and recommend one.
   - If the codebase shows a single unambiguous answer, use it. Otherwise, present what you found and ask.

2. **Preferences and tradeoffs** (not discoverable) — ask early, but usually after one lightweight exploration pass.
   - These are intent or implementation choices that cannot be derived from exploration.
   - Use the initial exploration pass to gather concrete options, constraints, and examples from the codebase.
   - Then ask the user as soon as the meaningful tradeoff is clear.
   - Provide 2-4 mutually exclusive options with a recommended default.
   - If asked and unanswered, proceed with the recommended option and record it as an assumption.

### Question Quality Bar

Bias toward asking over assuming. Every question must:
- Materially change the plan, OR
- Confirm or lock an important assumption, OR
- Choose between meaningful tradeoffs

Questions must NOT be answerable by non-mutating exploration.

### One Question at a Time

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

Use `./PLAN_TEMPLATE.md` in this skill directory as the source of truth for the plan template. Keep the generated plan structure identical to that file.

Interpret "structure" as the section hierarchy and required headings. You may repeat the `Implementation Steps` step block as many times as needed, but do not rename, remove, or reorder the top-level template sections.

**Title & Categorization:**

- Draft clear, searchable issue title (e.g., `Add user authentication`, `Fix cart total calculation`)
- Determine issue type: feat, fix, refactor
- Convert title to filename: `YYYY-MM-DD-<descriptive-name>.md` (kebab-case)
  - Use today's date as the prefix
  - Example: `Add User Authentication` → `2026-02-21-add-user-authentication.md`
  - Keep it descriptive (3-5 words) so plans are findable by context

## Write Plan

Fill in the template using everything gathered during the planning loop:

- Write plan content in concise, polite Korean, except for section headings
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

**Decision Completeness:**
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

**REQUIRED: Write the plan file to disk before presenting the final completed plan as the deliverable.**

Clarifying questions and tradeoff options may be presented earlier during the planning loop. This requirement applies only once the spec is decision complete and you are ready to deliver the finished plan.

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

In the final response, provide the exact plan path using the filename derived in **Title & Categorization**:

`docs/plans/active/YYYY-MM-DD-<descriptive-name>.md`

Do not offer implementation, do not ask to proceed, and do not write code. Your task is complete when the plan file is written and committed.
