---
name: spec
description: Route early specification work to the right requirements-discovery skill before writing a spec. Use this when the user wants to specify, scope, clarify, or turn an idea, bug fix, behavior change, or refactoring direction into concrete requirements; route ideas and bug fixes to interview, route refactoring to improve-codebase, then use to-spec once requirements are concrete.
---

# Spec Router

Use this skill as a router for specification work. Do not write the spec yourself unless the routed workflow has made the requirements concrete.

## Route

1. If the user is specifying a product idea, feature, behavior change, or bug fix, use the `interview` skill.
2. If the user is specifying a refactoring, architecture cleanup, consolidation, or codebase-improvement effort, use the `improve-codebase` skill.
3. If the category is unclear, ask one short routing question before choosing.
4. Once requirements are concrete, use the `to-spec` skill to write the spec document.

## Discovery Rules

When running the routed discovery step:

- Start with a high-level vision of the outcome.
- Ask clarifying questions until the requirements are concrete enough to write a useful spec.
- Surface assumptions immediately, before writing any spec content.
- Do not silently fill in ambiguous requirements. The purpose of the spec process is to expose misunderstandings before code gets written.

Use this assumption format:

```text
ASSUMPTIONS I'M MAKING:
1. This is a web application (not native mobile)
2. Authentication uses session-based cookies (not JWT)
3. The database is PostgreSQL (based on existing Prisma schema)
4. We're targeting modern browsers only (no IE11)
-> Correct me now or I'll proceed with these.
```

## Concrete Enough

Requirements are concrete when the agent understands:

- the intended user or system outcome
- the current problem or opportunity
- the important constraints and non-goals
- the expected behavior or acceptance criteria
- the relevant codebase or product context, if any

At that point, stop discovery and invoke `to-spec`.
