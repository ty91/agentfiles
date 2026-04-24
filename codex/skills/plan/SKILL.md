---
name: plan
description: Create a researched implementation plan as a plan file; use only when the user explicitly mentions this skill
argument-hint: "[feature description, bug report, improvement idea, or design doc path]"
disable-model-invocation: true
---

# Create Implementation Plan

The user indicated that they do not want execution yet. You MUST NOT make any edits except the plan file described below, run non-readonly tools except what is needed to create and commit that plan file, change configuration, or otherwise modify the system.

## Plan File

Create the plan at `docs/plans/active/YYYY-MM-DD-<descriptive-name>.md`. Use today's date as the prefix and a kebab-case descriptive name, for example `docs/plans/active/2026-03-16-add-user-authentication.md`.

Create `docs/plans/active/` if needed. Build the plan incrementally by writing to or editing only this file.

## Workflow

### Phase 1: Initial Understanding

Gain a comprehensive understanding of the user's request by reading the codebase and asking questions when needed.

1. Understand the request and the related code paths.
2. Search for existing functions, utilities, and patterns that can be reused.
3. Avoid proposing new code when suitable implementations already exist.
4. Use explorer subagents only when the active agent instructions allow subagent delegation; otherwise explore locally.

### Phase 2: Design

Design an implementation approach based on the user's intent and the codebase context.

1. Identify the recommended approach and why it fits the existing architecture.
2. Note important constraints, dependencies, and risk areas.
3. Skip elaborate alternatives unless they materially affect the decision.

### Phase 3: Review

Review the planned approach before writing the final plan.

1. Read the critical files identified during exploration.
2. Ensure the approach aligns with the user's original request.
3. Ask the user concise clarification questions if required to avoid a risky assumption.

### Phase 4: Final Plan

Write the final plan to the plan file.

- If `docs/plans/template.md` exists, use it as the template.
- Begin with a **Context** section explaining the problem, what prompted the change, and the intended outcome.
- Include only the recommended approach.
- Keep the plan concise enough to scan quickly, but detailed enough to execute.
- Include paths of critical files to modify.
- Reference existing functions and utilities to reuse, with file paths.
- Include a verification section describing how to test the change end to end.

### Phase 5: Save and Commit the Plan File

After writing the final plan, commit it and stop.

- Stage only the plan file under `docs/plans/active/`. Do not use `git add .`.
- Create one Conventional Commit. Recommended format: `docs(plan): add <descriptive-name> plan`.
- Do not implement the plan.

## Key Rules

- The plan file is the only editable project file.
- Read-only exploration is allowed.
- Do not write implementation code.
- Do not offer to implement after committing the plan.
- Do not use Plan mode commands; this skill itself is the planning workflow.
