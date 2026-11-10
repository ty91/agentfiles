# Test Behavior, Not Implementation

A test states what a caller, end user, or external system can observe through its interface: results, errors, readable state, and external effects.

Judge every new or retained test against two changes:

1. Break the promised behavior: return a wrong value, omit an effect, or perform it twice. The test must fail.
2. Restructure the internals while preserving every promised result and effect. The test must still pass.

Rewrite or remove a test that fails these criteria, after identifying the coverage it would remove. Exercise the real interface with concrete inputs. Derive expected values from the requirement, not from the implementation under test or data the test constructed without exercising the behavior.

- Private helper calls, intermediate data, and internal collaborator choice are normally implementation details.
- An external request's payload is behavior because the receiving system observes it. If the contract says an empty cart never charges, asserting no payment request is valid; include a positive case that proves the check can observe a charge.
- Assert the error type or message only to the extent the contract promises it. Do not freeze incidental wording.
- A cross-table invariant or a compile-time rejection can be the behavior. The assertion's syntax does not decide whether it is useful.
- Broad snapshots and loose truthiness checks are insufficient when the promise is more specific. Assert exactly the relevant contract, no less and no more.

For high-risk or easily fooled checks, demonstrate sensitivity with a controlled broken variant or the real pre-fix state. Restore the scratch change afterward. Reasoning about a mutation is not an executed mutation check; report the distinction.
