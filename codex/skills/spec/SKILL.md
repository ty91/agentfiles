---
name: spec
description: Use this when the user wants to specify, scope, or clarify an idea, bug fix, behavior change, or refactoring direction before writing a spec.
---

# Spec

Use this skill to make requirements concrete before writing a spec. Do not write spec content until the user's intent, constraints, assumptions, and acceptance criteria are clear.

## Process

- If the user is specifying a product idea, feature, behavior change, or bug fix, use the `interview` skill.
- If the user is specifying a refactoring, architecture cleanup, consolidation, or codebase-improvement effort, use the `improve-codebase` skill.
- If the category is unclear, ask one short clarifying question before choosing.

## Discovery Rules

During discovery:

- Start with a high-level vision of the outcome.
- Ask clarifying questions until the requirements are concrete enough to write a useful spec.

**Surface assumptions immediately.** Before writing any spec content, list what you're assuming:

```
Assumptions I'm making:

1. This is a web application (not native mobile)
2. Authentication uses session-based cookies (not JWT)
3. The database is PostgreSQL (based on existing Prisma schema)
4. We're targeting modern browsers only (no IE11)
→ Correct me now or I'll proceed with these.
```

Don't silently fill in ambiguous requirements. The spec's entire purpose is to surface misunderstandings *before* code gets written — assumptions are the most dangerous form of misunderstanding.

