# Feature

Deliver the requested new or changed behavior through [implement](../../implement/SKILL.md).

1. Read implement and follow its checkout preparation once. Establish the requested behavior, acceptance criteria, compatibility, and exclusions from the task and codebase.
2. During its understanding stage, use [architect](../../architect/SKILL.md) when the change creates or changes a contract, state model, ownership, or module responsibility. Settle the caller's usage and target shape before structural implementation.
3. Use [verify](../../verify/SKILL.md) to choose evidence before each implementation checkpoint. If the user requests TDD, follow its [test-first path](../../verify/test-first.md).
4. Continue implement's checkpoints, required verification, and [autoreview](../../autoreview/SKILL.md) closeout. Let implement own the review loop and finalization; do not append a second one. Apply [documentation](../../documentation/SKILL.md) when durable behavior or contracts change.

Finish only when implement's completion requirements and the requested behavior are satisfied. Report the delivered behavior, material design choices, verification results and gaps, and commits or PR only when the execution produced them.
