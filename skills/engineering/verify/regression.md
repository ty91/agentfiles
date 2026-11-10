# Regression Verification

Use for a reported bug. Make the failure executable before changing production code when the path is practical.

1. Identify intended behavior, current behavior, affected path, and the smallest observable reproduction. Distinguish a product failure from a broken setup.
2. Choose the narrowest useful existing check at the real risk boundary. When a cheap local test target is clear, add a focused regression test before the fix. Encode intended behavior rather than mirroring current internals.
3. Run the check on the broken state and confirm the intended failure. If it passes or fails for another reason, repair the reproduction before treating it as evidence.
4. Trace the mechanism to its first wrong decision. Fix the root cause with the smallest authorized change. Do not accumulate speculative guards or weaken the test to match the implementation.
5. Run the same check on the fixed state, then relevant adjacent checks. Confirm both disappearance of the bad outcome and presence of the intended one.

Do not force a permanent test that requires broad harness construction, fragile mocks, expensive unrelated infrastructure, or production-only state for a small fix. Use the closest useful script, manual command, real-app automation, or focused integration check. State why a new test was not appropriate and what remains unverified. Keep a valuable regression check; do not add a bad test solely to satisfy a sequence.

For flaky failures, control the trigger where possible and state which signal is captured. Do not treat one lucky pass as proof that nondeterminism is fixed.

When the broken baseline cannot be executed, say so. Do not claim failing-before evidence, or change the implementation back destructively just to manufacture it. Use an isolated baseline when practical and authorized.
