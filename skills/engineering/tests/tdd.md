# Test-First Work

Use when the user requests TDD or test-first development. A request for integration tests alone does not change the development sequence. [Tests](SKILL.md) owns scope and dependency selection.

## Red → Green → Refactor

1. Choose one behavior in the current task and express its input and expected result using an independent example.
2. Write and run a test that fails because the behavior is absent or incorrect. Fix setup or fixture problems if those are the actual cause.
3. Implement enough to satisfy the behavior and pass the same test.
4. While green, improve names, responsibilities, or duplication as needed, then rerun relevant verification.
5. Continue with the next behavior or important failure condition.

For a bug fix, reproduce the failure before changing implementation when possible. Use an existing failing test if it already expresses the intended behavior. For behavior-preserving refactoring, rely on useful existing tests rather than manufacturing a red.

An outer acceptance test and an inner loop can help implement a flow across multiple boundaries, but they are not mandatory layers. Write tests at the contract selected for the task.

If the red could not be executed, do not claim the test-first sequence was verified. At completion, use the [Suite review checklist](principles.md#suite-review-checklist) to assess tests worth retaining, then report relevant check results and limitations.
