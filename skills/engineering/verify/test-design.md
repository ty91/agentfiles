# Choose and Maintain Tests

Every test must name a failure it owns at the layer where that failure is most directly observable. Review this when keeping a test as well as when adding one.

- Add no duplicate test for a rule already guaranteed by types, schemas, or appropriate existing checks. Another layer may still own a distinct integration risk; do not delete boundary coverage merely because the domain rule has a unit test.
- Give each rule an owning layer. Other layers exercise representative wiring unless they introduce their own failure modes. Move domain decisions out of framework handlers when direct testing would otherwise require unrelated setup; route structural choices through [architect](../architect/SKILL.md).
- Slower tests must justify their setup and observation cost. Start at the state the conclusion requires instead of replaying a long unrelated flow, unless that flow is itself the contract.
- Name a test after the rule it protects. Several independent rules in one name suggest splitting it or testing lower in the stack.
- Use real dependencies where the risk lives. Use substitution to control failure, time, randomness, or ordering, and separately verify what the substitute hides. A mock of SQL or a browser API does not verify the real engine or browser.
- Derive expected values independently. Keep fixtures small and relevant; do not rebuild the implementation inside the expectation.
- Control shared state and execution order. A passing run dependent on another test's residue is not reliable evidence.
- Remove or merge tests that the change made redundant. A new outer test does not by itself supersede focused coverage; identify the old failure and where it is now observed before removal.

Apply [Test Behavior, Not Implementation](principles/test-behavior-not-implementation.md) to the assertions. Report retained coverage limits and any test removals that affect what can be observed.
