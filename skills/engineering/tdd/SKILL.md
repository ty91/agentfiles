---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
---

# Test-Driven Development

TDD is the red → green loop. What a good test IS — the default test surface, layering, mocking rules, and what deserves a test at all — is defined by the `tests` skill: load it before writing the first red and follow it throughout. This skill defines only the loop.

When exploring the codebase, read `CONTEXT.md` (if it exists) so test names and interface vocabulary match the project's domain language, and respect ADRs in the area you're touching.

## The double loop (outside-in)

Work two loops, not one:

1. **Outer loop — one acceptance red at the outermost consumer seam** (real HTTP for a server app, the rendered tree for UI — per the tests skill). Write it first, from the task's acceptance criteria. It stays red while you build inward; turning it green is the definition of done for the slice.
2. **Inner loop — unit reds only for extracted pure functions.** While driving the acceptance test green, when you hit combinatorial logic (validation rules, calculations, sorting, state transitions), extract it as a pure function and red-green its branches exhaustively there. No other inner reds exist.

Never write a red against an internal layer (a service, a route mapping, repository wiring) in order to "have something to implement against." The acceptance red already demands that code — implement until it passes. The only test files below the outer seam are those the tests skill's justification list allows (complex query, pure-function extraction, load-bearing invariant).

## What makes a legitimate red

A red must encode an **observable behavior difference** at its seam: a response, rendered output, persisted state, or outbound request that differs depending on whether the behavior exists.

- If the only way to produce a red is to observe calls on a stub of an internal collaborator, the slice is wrongly chosen. Either the logic belongs in a pure function (extract it, red there), or the observable effect lives at the outer seam (assert there), or the distinction is imaginary (don't test it).
- Expected values come from an independent source of truth — a worked example, the spec, a known-good literal. Never recompute them the way the implementation does: a tautological test passes by construction and can never disagree with the code.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Don't anticipate future tests or add speculative features.
- **Vertical slices.** One acceptance behavior driven to green before the next begins. Never write all tests up front — horizontal slicing verifies *imagined* behavior and commits to test structure before the implementation has taught you anything.
- **Refactoring is not part of the loop.** It belongs to the review stage. Tests created during the loop are provisional until review: run the suite-review checklist in the tests skill (`principles.md`), and delete reds that turn out to be scaffolding rather than durable specification.
