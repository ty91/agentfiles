# Verification Scope and Existing Tests

Choose scope around the contract being checked. A UI-only test and a test that includes the server can legitimately treat the same dependency differently.

## Choosing scope

| Risk | Possible verification scope |
|---|---|
| Boundary values in calculations, normalization, or transitions | Direct inputs to a function or state model |
| Input, keyboard behavior, or parent interaction | Render the necessary components and real connections |
| SQL, storage constraints, or job claims | Repository or job-management API with a real database |
| Serialization, routing, or authentication wiring | HTTP against the assembled app |
| A critical user flow across several boundaries | Browser or system-level flow |

A small test can be sufficient without repeating the whole flow. Add representative integration coverage when an important connection would otherwise be missed. Coverage at one layer does not automatically establish another layer's contract.

## Real dependencies and substitutes

SQL behavior needs a real engine. UI error recovery benefits from controlled API responses. Choose based on what the test establishes rather than who owns the dependency.

Use existing boundaries when controlling time, randomness, response delays, or expensive dependencies. Avoid adding product configuration layers solely for test convenience. Check relevant contracts against real connections or shared contract tests where substitutes leave a gap.

Assert external request counts or ordering when they are contractual. Before asserting an internal call, distinguish required behavior from an implementation detail that may change during refactoring.

## Suite review checklist

1. Does the test detect the failure it names, rather than merely execute code or repeat the implementation in its expected value?
2. Does a substitute hide the risk or assume behavior that differs from the real service?
3. Even where coverage overlaps, does this test add boundary cases, faster diagnosis, or explicit protection for an important invariant?
4. Can assertions coupled to internal structure be replaced with assertions about contractual results?
5. Before deleting or consolidating a test, have you identified what coverage would be lost and verified that necessary behavior remains covered?

Preserve useful existing tests during refactoring. Decide whether to delete, move, or consolidate by comparing verification value with maintenance cost. Structural change alone does not justify removing lower-level tests.
