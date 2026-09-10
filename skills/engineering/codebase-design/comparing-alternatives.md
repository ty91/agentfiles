# Comparing Alternatives

Use when several designs satisfy the current need but differ in change cost or operating constraints. A straightforward local edit does not need a separate alternatives document.

1. Establish requested behavior, existing contracts, and operating constraints.
2. Include an option that retains the current structure, then consider alternatives with materially different trade-offs. Do not invent flexibility requirements to populate the comparison.
3. Apply the same representative calls, failures, and state changes to each option. Include code examples only when code writing is authorized for the task.
4. Compare caller knowledge, files that change together, and migration or recovery costs. Recommend an option.

Parallel agents are optional. Use them only when delegation is authorized and independent analysis would help. Give each reviewer the same requirements and constraints.

Explain the recommendation and its remaining trade-offs. Once the choice is settled, stop repeated comparison and follow [documentation](../documentation/SKILL.md) if the rationale needs to persist.
