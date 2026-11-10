# Verification

Establish evidence through [verify](../../verify/SKILL.md).

1. Resolve the target code state, behavior or contract, and what the user wants: a verification plan, execution of checks, or new checks written. A plan-only request does not become an execution task.
2. Follow verify to identify claims, risk boundaries, existing evidence, and the narrowest useful observations. Use its regression path for before-and-after evidence and its test-first path only for an explicit test-first request.
3. Perform the authorized checks or author the requested verification artifacts. Do not repair product code under a request merely to check it. Preserve the target behavior and required gates while inspecting failures.
4. Report verified, failed, and unverified claims with commands, observed outcomes, covered code state, and limits. Distinguish a product defect from a broken check or unavailable environment.

Stop with the requested evidence or verification artifacts. A product fix requires an implementation or fix request. If fixes are already authorized, route them through the appropriate implementation playbook and reuse evidence that still applies. Do not automatically commit or open a PR for a standalone verification request.
