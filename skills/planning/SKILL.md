---
name: planning
description: Transform feature descriptions into well-structured project plans following conventions; use only when the user explicitly mentions this skill
argument-hint: "[feature description, bug report, or improvement idea]"
---

# Planning Features and Fixes Into Implementation Plans

## Overview

**Note: The current year is 2026.** Use this when dating plans and searching for recent documentation.

Transform feature descriptions, bug reports, or improvement ideas into well-structured markdown plan files that follow project conventions and best practices.

Input:

<feature_description> #$ARGUMENTS </feature_description>

If the feature description is empty, ask the user: "What would you like to plan? Please describe the feature, bug fix, or improvement you have in mind."

Output:
- A complete plan written to `docs/plans/active/YYYY-MM-DD-<descriptive-name>.md`
- One Conventional Commit containing only the plan file

## Hard Gates

- Do not proceed without a clear feature description.
- Do not start writing the plan until the spec is decision complete.
- Write the plan file to disk before presenting the final completed plan as the deliverable.
- Your task is complete only when the plan file is written and committed.
- Stop after the plan is written and committed. Do not offer implementation, do not ask to proceed, and do not write code.

## Checklist

You MUST complete these steps in order:

1. **Understand the Request**
2. **Explore the Codebase**
3. **Clarify Tradeoffs**
4. **Confirm Planning Sufficiency**
5. **Populate the Plan Template**
6. **Validate the Plan**
7. **Save and Commit the Plan File**

## The Process

### Step 1. Understand the Request

- Confirm the planning target: feature, bug fix, or improvement.
- Identify the initial goal, success criteria, and obvious scope boundaries.
- If the request is unclear, contradictory, or missing critical context, ask the user before proceeding.
- Do not continue until the request is clear enough to explore productively.

### Step 2. Explore the Codebase

Ground yourself in the actual environment before asking the user anything. Exploration prepares better questions — it does not replace asking.

- As a default, perform at least one targeted exploration pass before asking any clarifying question.
- Exception: ask clarifying questions before exploring ONLY if the feature description contains obvious ambiguities or contradictions that cannot be resolved by exploration.
- This default also applies to preference/tradeoff questions: do a lightweight exploration pass first so you can ask with concrete options grounded in the actual codebase.

Treat unknowns differently based on their nature:

1. **Discoverable Facts** (single correct answer in the codebase) — explore first.
   - Search the codebase: configs, entrypoints, schemas, types, existing patterns.
   - Ask only if multiple plausible candidates exist, nothing was found but you need specific context, or the ambiguity is actually about product intent.
   - When asking, present concrete candidates (paths, patterns) and recommend one.
   - If the codebase shows a single unambiguous answer, use it.

2. **Preferences and Tradeoffs** (not discoverable) — gather context first, then ask.
   - Use the initial exploration pass to gather concrete options, constraints, and examples from the codebase.
   - Ask the user as soon as the meaningful tradeoff is clear.

During exploration:
- Split exploration into independent research tracks when helpful; focus on coordination and synthesis.
- Map entrypoints, data flow, module boundaries, and reusable patterns.
- Identify concrete files likely to be created or modified and the affected tests.
- Review relevant recent commits or reversions for prior decisions and pitfalls.
- When external facts materially affect planning decisions, research them early and keep scope tight; prefer primary sources.
- Track what you discovered and what remains unknown.

### Step 3. Clarify Tradeoffs

Surface the remaining unknowns after exploration.

- For each remaining unknown, classify it: discoverable fact or preference/tradeoff.
- If it is discoverable, go back to Step 2.
- If it is a preference or tradeoff, ask the user.

Question rules:
- Bias toward asking over assuming.
- Ask only when the answer would materially change the plan, confirm or lock an important assumption, or choose between meaningful tradeoffs.
- Do not ask questions that can be answered by non-mutating exploration.
- Ask one question per message.
- Prefer multiple-choice questions with a recommended option when natural choices exist.
- If a preference/tradeoff question is asked and goes unanswered, proceed with the recommended option and record it as an assumption.

Gather signals during clarification:
- **User's Familiarity**: do they know the codebase patterns, or are they pointing to examples?
- **User's Intent**: speed vs thoroughness, exploration vs execution?
- **Topic Risk**: security, payments, external APIs, or other high-risk areas?
- **Uncertainty Level**: is the approach clear or still open-ended?

Loop between Step 2 and Step 3 as many times as needed.

### Step 4. Confirm Planning Sufficiency

Do not proceed to writing until the spec is decision complete.

Check all of the following:
- [ ] Goal and success criteria are clear.
- [ ] Approach is chosen with rationale.
- [ ] Scope is defined, including what is in and out.
- [ ] Key tradeoffs are resolved, or recorded as assumptions with chosen defaults.
- [ ] Affected files and code flow are identified.
- [ ] High-risk areas have been researched.
- [ ] The implementer will not need to make design decisions.

If any item fails, return to Step 2 or Step 3.

When the spec is sufficient, briefly announce your findings and chosen approach before drafting the plan. The user may still redirect at this point.

### Step 5. Populate the Plan Template

Use `./PLAN_TEMPLATE.md` in this skill directory as the source of truth.

Interpret "structure" as the section hierarchy and required headings. You may repeat the `Implementation Steps` step block as many times as needed, but do not rename, remove, or reorder the top-level template sections.

Title and categorization rules:
- Draft a clear, searchable issue title such as `Add user authentication` or `Fix cart total calculation`.
- Determine the issue type: `feat`, `fix`, or `refactor`.
- Convert the title to the filename format `YYYY-MM-DD-<descriptive-name>.md` in kebab-case.
- Use today's date as the prefix.
- Keep the descriptive part specific and searchable, ideally 3-5 words.
- Example: `Add User Authentication` -> `2026-02-21-add-user-authentication.md`

While filling in the template:
- Write plan content in concise, polite Korean, except for section headings.
- Use code examples only when they clarify a contract or ambiguous pattern.
- Use syntax highlighting and `file:line` references for code examples.
- Keep implementation steps focused on intent and constraints, not copy-paste code.
- Keep all checkboxes in Verification, Deliverables, and Acceptance Criteria unchecked (`- [ ]`).
- Populate the Files to Change table with every file that will be created or modified.
- Include Key References from exploration: file paths, related issues or PRs, and documentation URLs if external research was done.

### Step 6. Validate the Plan

Verify the plan before writing it to disk. Every item must pass.

**Completeness:**
- [ ] Title is searchable and descriptive.
- [ ] All template sections are filled in with no placeholder text or TODOs.
- [ ] Files to Change is complete with Action, File, and Step.
- [ ] Every implementation step has a Verification section.

**Decision Completeness:**
- [ ] An implementer can execute this plan without making design decisions.
- [ ] Ambiguous areas are resolved or explicitly called out with chosen defaults.
- [ ] Approach rationale is documented.
- [ ] Steps describe intent and constraints, not copy-paste code. Snippets of 10 lines or fewer are acceptable when necessary.

**Correctness:**
- [ ] File paths reference real files verified during exploration.
- [ ] Referenced patterns match what actually exists in the codebase.
- [ ] No contradictions exist between sections.

**Formatting:**
- [ ] All checkboxes are unchecked.
- [ ] Code examples use correct syntax highlighting.

If any item fails, fix it before proceeding.

### Step 7. Save and Commit the Plan File

Clarifying questions and tradeoff options may be presented earlier during the process. Once the spec is decision complete and the plan passes validation, deliver the finished plan by saving it first.

Write the complete plan to:

`docs/plans/active/YYYY-MM-DD-<descriptive-name>.md`

Before writing, create the destination directory if needed:

```bash
mkdir -p docs/plans/active/
```

After writing the file:
- Stage only the plan file under `docs/plans/active/`.
- Do not use `git add .`.
- Create one Conventional Commit. Recommended format: `docs(plan): add <descriptive-name> plan`.
- Confirm with: `Plan written to docs/plans/active/[filename]`.

## Key Principles

- **Ask Over Assume**: when internal deliberation would materially affect the plan, that usually means you should ask.
- **Explore First, Then Ask**: exploration improves question quality; it does not replace asking.
- **One Question at a Time**: avoid overwhelming the user.
- **Prefer Concrete Options**: ask with grounded choices and a recommended default when possible.
- **Record Chosen Defaults**: if a tradeoff is unanswered, proceed with the recommended option and make the assumption explicit.
- **Keep the Implementer Unblocked**: the plan should remove design decisions from implementation.

## Completion Condition

In the final response, provide the exact plan path:

`docs/plans/active/YYYY-MM-DD-<descriptive-name>.md`

Your task is complete when the plan file is written and committed.
