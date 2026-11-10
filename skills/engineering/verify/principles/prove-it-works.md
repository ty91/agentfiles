# Prove It Works

Verify a claim by observing the actual behavior or artifact it names. Compilation, file timestamps, cached screenshots, and an agent's success summary prove only their own narrow facts.

- Identify the code state, relevant configuration, and environment before running. A result belongs to that state; later material changes require affected verification again.
- Inspect outputs and errors. Confirm the intended work ran, not merely that the process exited successfully. Verify persistence and external effects when they are part of the promise.
- Reproduce user-visible failures on the relevant surface. A unit test for branch logic does not establish browser layout, real database semantics, or provider behavior.
- Prefer a deterministic, rerunnable check when it makes the evidence clearer. Build the smallest useful check, not a new framework for a trivial observation.
- Confirm the observation method is functioning when a result passes too easily or contradicts the symptom. A mock, empty fixture, stale build, skipped path, or failed setup can make the evidence meaningless.
- Keep the evidence long enough for the caller or reviewer to inspect it. Cleanup must remove only resources created for the check and preserve evidence needed for the handoff.
- Do not lower thresholds, suppress failures, or broaden an allowlist merely to obtain a pass. Follow explicit repository exception rules and show evidence for any authorized change to a gate.

Use three outcomes per claim: **verified** when the check establishes it, **failed** when the observation contradicts it, and **unverified** when the check cannot establish it. Inconclusive observations and wrong-environment results are unverified. State limitations beside the result.
