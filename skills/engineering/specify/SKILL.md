---
name: specify
description: Convert a natural-language feature request into a user-value-centered, implementation-agnostic feature spec and publish it to the repository's issue tracker.
disable-model-invocation: true
---

## Role

You are running a `specify` session.

Your responsibility is to convert the user's natural-language feature request into a **user-value-centered, implementation-agnostic, verifiable feature specification**.

The goal is to clarify:

1. **What** should be built
2. **Why** it is needed
3. **What success looks like**

One `specify` session MUST produce exactly one feature specification. The feature specification MUST cover one feature or one coherent product slice.

## Strict Boundaries

Do NOT decide, design, or document implementation details in this session.

Specifically, do NOT include:

- Technology stack decisions
- Database or API design
- Concrete data model design
- File or module structure
- Implementation task lists
- Code implementation
- Test code implementation

If the user asks about these topics, politely defer them to a later planning process, and return to clarifying user value and externally observable behavior.

## Input

Feature request:

Use the user's request that led to this skill.

If the request is empty, ask the user what feature or product slice they want to specify.

## Process

1. Use the `grilling` skill to interview the user for one coherent product slice.
   Frame the grilling session as product specification: user value, externally observable behavior, scope, success criteria, acceptance scenarios, and edge cases.
   Do not ask implementation-design questions; rephrase them as product-behavior questions or defer them to planning.
   If there are multiple possible feature slices, ask the user to choose one.
2. Read [`writing_feature_specs.md`](writing_feature_specs.md).
3. If the writing guide reveals gaps, continue `grilling` only for those gaps.
4. Draft and review the feature spec using the writing guide.
5. Ask the user for confirmation before publishing.
6. After confirmation, publish the spec to the current repository's issue tracker.

## Issue Tracker Publishing

Publish the completed feature spec to the repository's issue tracker.

If the user's specify request targets an existing issue, do NOT create a new issue. Publish the completed feature spec as a comment on that issue instead.

If the user's specify request does not target an existing issue, create a new issue in the repository's issue tracker.

If no issue tracker is specified, stop and ask the user which issue tracker to use.

When creating a new issue, use the feature name as the issue title:

```text
Feature Spec: [Feature Name]
```

Use the completed feature spec as the issue body or issue comment body.

Use the appropriate tool or documented workflow for the repository's issue tracker. If publishing is not possible, explain why and provide the exact issue title and body or issue comment body for manual publishing.
