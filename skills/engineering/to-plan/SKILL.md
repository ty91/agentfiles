---
name: to-plan
description: Create a researched plan for a spec issue before implementation. Use to clarify context, scope, codebase findings, and implementation/testing decisions.
disable-model-invocation: true
---

# To Plan

Turn a spec issue into a researched, decision-oriented plan. The plan records why the work matters, what was learned from the codebase and relevant documentation, what the work should and should not accomplish, and which implementation and testing decisions have been agreed.

Do not implement code during this skill. Do not decompose the work into detailed checklists, local planning files, or sub-issues.

## Source Spec

Start from the spec issue the user provides. The source spec must be an issue in the repo's configured issue tracker.

If the target is missing or ambiguous, ask which spec issue to plan from, or whether to create a new issue for the plan. Do not choose one yourself.

If the user provides a local spec document instead of an issue, stop and ask which issue tracker issue should contain the plan, or ask whether to create/import the spec into an issue first. Do not create local planning files.

If the repo has `docs/agents/issue-tracker.md`, follow it for fetching and updating issue details and comments. Otherwise, use the repo's configured issue-tracker workflow. If the workflow is unclear, ask the user how to read and comment on the issue before continuing.

## Output Location

For an existing spec issue, create or update exactly one planning comment on the spec issue. The comment must start with a visible marker line:

```markdown
[pi:plan]
```

Use a visible marker line, not a hidden HTML comment, because issue tracker editors may sanitize or transform hidden comments.

If an existing `[pi:plan]` comment is found, update it instead of creating a duplicate. If the issue tracker workflow does not support comment updates, create a new comment with the same marker and state that it supersedes the previous one.

For a newly created issue, put the `[pi:plan]` content in the issue body instead of a comment.

## Workflow

### 1. Research

Before writing the plan, operate in read-only mode:

- Read the source spec issue.
- Read relevant codebase sections, existing implementation patterns, and nearby tests.
- Read project documentation that defines architecture, testing, release, or contribution conventions.
- Use web research only when the work depends on current or external information, and prefer official or primary sources.

Using subagents to delegate the research is strongly recommended. Use `general-purpose` or `default` subagent whenever possible.

### 2. Summarize Research

Capture only findings that matter to planning. Separate facts from recommendations.

Include enough references for a future implementer to inspect the evidence:

- Use file paths with line numbers for important local code or documentation findings when practical.
- Use hyperlinks for web documents and external references.
- Do not pad the plan with broad codebase summaries that do not affect the work.

### 3. Elicit Decisions

Identify decisions that materially affect scope, architecture, data flow, migration, API shape, UI behavior, rollout, or testing strategy.

Prefer to use `grilling` skill when there are meaningful plan-affecting decisions to resolve. Skip grilling only when the spec and codebase already make the decisions clear, the plan is trivial, or the user explicitly asks to skip it.

### 4. Publish And Ask

Publish the plan, then ask the user to review it.

## Plan Template

Write the plan primarily in Korean including the title of the plan. Established technical terms or section titles may remain in English when they are clearer or conventional.

```markdown
[pi:plan]

# Plan: <plan title>

## Background

[Explain why the work should happen. Base this on the spec issue and user-provided context, not speculation.]

## Research Findings

[Summarize codebase, documentation, and web research findings that affect planning. Keep recommendations out of this section.]

## Goal

[State the desired outcome at a planning level. Avoid detailed checklists or acceptance criteria.]

## Out of Scope

[Record boundaries that prevent scope creep.]

## Implementation Decisions

[List agreed implementation decisions and short rationale. Include only decisions resolved by the spec, codebase research, or user discussion.]

## Testing Decisions

[List agreed testing strategy decisions and short rationale, including meaningful exclusions.]

## Further Notes

[Record unresolved questions, deferred decisions, rollout notes, dependencies, or context that does not fit the other sections.]
```

## Verification

Before finishing, confirm:

- [ ] The source spec was read from the user-provided issue tracker issue.
- [ ] Relevant code, existing patterns, and nearby tests were considered.
- [ ] Required project documentation was considered.
- [ ] Web research was performed when current or external information was needed.
- [ ] Research findings include useful file line references or document links where practical.
- [ ] Grilling was performed when meaningful plan-affecting decisions were not already clear, unless the user asked to skip it.
