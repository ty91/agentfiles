# Test-First Development

Use when the user explicitly requests TDD, test-first, or red-green-refactor. This covers new behavior as well as bug fixes. A request for integration tests alone does not select this path.

1. Choose one observable behavior and its appropriate test layer using [test-design.md](test-design.md).
2. Write the smallest test for that behavior. Run it before implementation and confirm that it fails for the intended missing or incorrect behavior, not a setup error.
3. Make the smallest production change that satisfies the contract. Run the test and relevant nearby checks.
4. Refactor while the established behavior stays green. Remove duplication or misleading structure without broadening the feature.
5. Repeat for the next behavior. Honor the caller's coherent commit checkpoints; a red-green cycle is not by itself a commit policy.

For bugs, also follow [regression.md](regression.md). For behavior-preserving cleanup, use established coverage rather than inventing a red for each internal move.

Do not claim test-first when the pre-implementation red did not run. If the requested sequence cannot be executed, state the reason and follow the caller's permitted fallback. Never silently substitute a passing test written after implementation for the requested evidence.
