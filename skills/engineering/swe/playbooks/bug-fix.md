# Bug Fix

Reproduce and correct the defect through [implement](../../implement/SKILL.md), using [verify's regression path](../../verify/regression.md).

1. Read implement and [verify](../../verify/SKILL.md), then prepare the selected checkout once before executing checks or editing. Define intended behavior, observed behavior, and the smallest discriminating reproduction.
2. During implement's understanding stage, follow the regression path to establish failing-before evidence. Use a cheap local regression test when practical; otherwise choose the closest executable check at the real risk boundary. Record a missing or unavailable baseline honestly.
3. Trace the failure to its mechanism before choosing a fix. Separate broken setup from a product defect. Remove changes motivated by a disproven hypothesis rather than leaving speculative guards behind.
4. When the correction changes a contract, state model, ownership, or module boundary, use [architect](../../architect/SKILL.md) before that implementation. Keep the original intended behavior and task scope as constraints.
5. Carry the reproduction and root-cause evidence into implement's checkpoints. Run the same reproduction after the fix, confirm the intended outcome, and check relevant adjacent risks through verify. An explicit TDD request also selects [test-first](../../verify/test-first.md).
6. Complete implement's required checks, review, and finalization. Update durable explanations through [documentation](../../documentation/SKILL.md) when affected.

Report the defect, root cause, smallest justified correction, and before-and-after evidence. A plausible diff or an unrelated passing check is not a demonstrated fix. If the task cannot be completed under its verification requirements, report the precise gap instead of claiming success.
