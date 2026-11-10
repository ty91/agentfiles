# Comparing Alternatives

Use during architect's comparison step. Produce at least two structurally distinct candidates before selection. A straightforward local edit within an established contract does not enter the architect workflow.

1. Establish requested behavior, existing contracts, and operating constraints.
2. Include retaining the current structure when it is a meaningful option. Candidates must differ in contract, ownership, state representation, or module boundaries, not just naming. Do not invent requirements to make a candidate attractive. If constraints rule a candidate out, show the concrete contradiction instead of presenting it as viable.
3. Apply the same representative calls, failures, and state changes to each option. Include code examples only when code writing is authorized for the task.
4. Apply [design-red-flags.md](design-red-flags.md) to each candidate. Compare caller knowledge, interface depth, invariant enforcement, files that change together, and migration or recovery costs. Pick a base and explain the tradeoffs.
5. Adapt useful parts of the other candidate only when the result stays coherent. Do not average incompatible ownership models. If the candidates expose different interpretations of the task, settle those constraints before selecting.

Parallel agents are optional and require authorization. Distinct candidates are required even when one agent produces both. Give independent reviewers the same requirements, constraints, and representative calls, with separate writable outputs. Review every candidate yourself.

Explain the recommendation and its remaining trade-offs. Once the choice is settled, stop repeated comparison and follow [documentation](../documentation/SKILL.md) if the rationale needs to persist.
