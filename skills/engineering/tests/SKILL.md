---
name: tests
description: Choose and maintain verification for a change. Use when writing tests, selecting test scope or dependencies, reviewing coverage, or deciding whether an existing test should stay.
---

# Tests

Verify the failures that would result from an incorrect change. Follow the project's verification procedures and tools, choosing sufficient evidence at a manageable execution, maintenance, and diagnosis cost.

## Workflow

1. Identify requested behavior and conditions that must remain true after failure.
2. Read existing tests and verification commands. Check whether assertions detect the relevant failure, not merely whether the code executes.
3. If evidence is missing, choose a scope where the failure can be observed directly. Functions, components, repositories, HTTP, and complete flows are all valid choices.
4. Decide which dependencies must be real and which need control. Where substitution leaves an important connection unverified, cover it separately.
5. Run relevant verification and required project checks. Do not repeat checks without new changes, failures, or unresolved concerns.

## Writing criteria

- Names and expectations express conditions and results. Derive expected values from requirements, worked examples, or another independent source rather than recomputing them with the implementation.
- Assert results, persisted state, user interactions, and external effects. Assert counts or ordering when they are part of the contract, such as preventing duplicate charges.
- Use real collaborators when they are cheap and deterministic. Substitute dependencies to control failures, time, or environment without removing the behavior the test needs to verify.
- Choose relevant boundary values and failure transitions. Branch counts and file existence do not determine how many tests to write.
- Give tests independent setup and cleanup. Control timing and response order; wait for observable completion rather than arbitrary delays.
- Small copy or styling changes may need only existing checks and visual inspection. Do not add ceremonial tests when the change needs no new automated coverage.

## References

- Scope, substitution, and existing-test decisions: [principles.md](principles.md)
- Databases, files, HTTP, and job recovery: [backend.md](backend.md)
- Input, rendering, and asynchronous UI: [frontend.md](frontend.md)
- Explicitly requested test-first work: [tdd.md](tdd.md)

## Done

Finish when evidence covers the changed behavior and important regression risks, and required checks are complete. Report what ran, its results, and remaining limitations. Do not claim unexecuted checks or external integrations passed.
