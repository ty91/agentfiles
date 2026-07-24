# Principles

Why the defaults are what they are, and how to rule on edge cases the defaults don't settle.

## The two axes every rule serves

1. **Signal trustworthiness** — green means it works; red means a bug. Verifying behavior (not implementation) prevents false reds. Using the real thing at junctions (not mocks) prevents false greens.
2. **Feedback economy** — how cheaply, quickly, and diagnosably the signal arrives. Speed, determinism, and non-duplication of responsibility between layers all live here.

A test's worth is always a trade between these. When two rules conflict, decide by asking which axis is actually at risk in this case.

## Cost comes from the external world, not call depth

A test crossing ten in-memory objects is still microseconds and fully deterministic. What makes a test expensive is I/O, network, shared state, nondeterminism — process-boundary contact. Therefore:

- Traversing many internal layers does NOT make a test "an integration test" in the costly sense. Sociable tests over real collaborators keep unit-test economics.
- Mocking an internal collaborator buys nothing (the real one was free) and costs plenty: the test welds itself to internal structure, breaks on refactor without a behavior change, and encodes beliefs about the collaborator that drift from reality (false green inside your own codebase).

## Seam hierarchy

The license to substitute at a seam is proportional to that interface's **stability**:

- **Outermost consumer seam** (HTTP, rendered UI): maximally stable — the default test surface.
- **True external boundaries** (third-party APIs, time, randomness): substitution is mandatory — you don't control them.
- **Internal interfaces**: the thing you most want freedom to refactor. Substituting here freezes them. Don't.

If wiring real collaborators for a test is painful, the pain is design feedback (too many dependencies, tangled I/O) — the fix is extraction or restructuring (functional core / imperative shell), never a mock to hide the pain.

## Marginal confidence

The value of a test is the confidence it *adds*, not the confidence it *contains*. A dedicated test for a behavior already covered adds ~zero confidence but full maintenance cost and signal dilution (people learn to reflexively "fix" reds).

Three safety pins when applying it:

- **The criterion is failure, not execution.** "Covered" means: if the behavior broke, a required test *necessarily turns red*. Code merely executed under a test without an assert on its effect is not covered. Coverage tools measure execution, not verification.
- **Free coverage is an implicit contract.** It silently disappears if the covering test is refactored away from that path. Load-bearing invariants (money, permissions) get explicit tests regardless.
- **Localization has value.** A transitively-covered failure shows up in an outer test, pointing at a slice, not a line. For behavior that would be genuinely hard to diagnose from there, a dedicated test's value is *diagnosis*, and that justifies it.

## Rulings for common disputes

- **"Which layer does this test belong to?"** — the cheapest layer that can catch the risk. Logic branches → unit (extracted pure function). Junction correctness (SQL, wiring, serialization) → the outer integration seam. "Does the deployed product work" → the thin E2E layer.
- **"Is this test verifying behavior or implementation?"** — would it survive a refactor that preserves observable behavior? Asserts on internal calls, call order, internal state, or generated-artifact text (SQL text, DOM snapshots) do not survive; asserts on responses, persisted state, rendered output, and outbound requests do.
- **"There's no way to make this test fail except by observing a stub's calls"** — then the test target is wrongly chosen. Either the logic should be a pure function (extract it), or the observable effect lives at the outer seam (assert there), or the behavior distinction is imaginary (don't test it).
- **"Static content with no branches"** — no test. Its existence is verified for free as a precondition of the flow tests that use it. If no flow test uses it, question the feature, not the test coverage.
- **Change-detection is legitimate only where no executable oracle exists** (visual appearance → screenshot diff + human approval). Where an assert is possible, change-detection (snapshots) is a lazy substitute that produces false reds.

## Suite review checklist

When reviewing tests (yours or existing):

1. For each test file below the outermost seam: what stated justification does it carry? (Accepted: complex-query exception, pure-function extraction, load-bearing invariant, diagnostic value.) None → delete or merge upward.
2. For each test: if the behavior it names broke, would an outer required test already turn red? Yes and no exception applies → delete.
3. Any assert on calls / call order / internal state / generated text → rewrite against observable behavior or delete.
4. Any stub of an internal collaborator → rewrite sociable (real collaborator) or move the scenario to the outer seam.
