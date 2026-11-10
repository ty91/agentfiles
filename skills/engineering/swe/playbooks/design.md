# Design

Deliver a design through [architect](../../architect/SKILL.md). Implementation is outside a design-only request.

1. Read architect and establish the problem, existing constraints, and requested design scope from callers, code, and relevant decisions.
2. Follow its usage-first modeling, distinct-candidate comparison, and red-flag screening. Respect code-writing permission when expressing signatures or call examples.
3. Use [verify](../../verify/SKILL.md) to specify how the proposed contract and important failure cases will be checked. Mark proposed checks as unexecuted. Execute an experiment only within the request's authorization.
4. Return the chosen contract, ownership and state model, rejected alternative, accepted tradeoffs, and verification plan or evidence. Use [documentation](../../documentation/SKILL.md) if the task calls for a durable design record.

Stop at the requested design deliverable. Do not invoke implement, create a branch, commit, or publish a PR merely because a design was selected. If implementation is already part of the request, use the appropriate implementation playbook with this design as its input instead of treating the design as task completion.
