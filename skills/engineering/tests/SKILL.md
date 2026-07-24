---
name: tests
description: Test design and writing standards. Use when writing tests, deciding what to test, choosing where a test belongs, or judging whether an existing test should exist.
---

# Tests

Integration-first testing. This body holds the non-negotiable defaults; load only the detail doc that matches what you are testing, so unrelated context stays out.

## Defaults (always apply)

1. **The default test surface is the outermost consumer seam.** For a server app: real HTTP against the assembled app. For a UI: the rendered component tree driven like a user. Creating a test file below that seam requires a stated justification (see the layer docs for the only accepted ones). "This module exists" is not a justification — modules are not test units; behaviors are.
2. **Replace nothing you own.** Substitute only at true external boundaries: third-party APIs, and nondeterminism sources (time, randomness). Your own DB is not external — use a real engine cheaply (in-process engine or container + migrations). Never stub or mock an internal collaborator, and never assert on calls, call counts, or call order against one.
3. **Marginal confidence decides whether a test exists.** Before writing a test ask: *if this behavior broke, would a required test already turn red?* If yes, do not write a dedicated one. Exceptions: a load-bearing invariant (money, permissions — pin it explicitly), or a behavior whose failure would be hard to diagnose from the outer test alone.
4. **Combinatorial or nondeterministic logic is extracted into pure functions and unit-tested exhaustively.** The outer seam keeps one representative case proving the wiring. If a behavior's test would need to observe calls on a stub to detect it, the design is wrong: extract a pure function or assert at the outer seam instead.

The repo's own testing standards (e.g. `docs/conventions/`) override tooling details here; these docs define the defaults when the repo is silent.

## Routing

- Judging a test's right to exist, reviewing a suite, or resolving a seam dispute → read [principles.md](principles.md)
- Testing server-side code (HTTP APIs, DB, migrations, repositories) → read [backend.md](backend.md)
- Testing frontend code (components, hooks, stores, API consumption) → read [frontend.md](frontend.md)
