# Review

Review a specified change through [autoreview](../../autoreview/SKILL.md).

1. Read autoreview. Resolve the target, base, original intent, exclusions, and relevant supplied evidence. Establish whether the request is review-only or also authorizes fixes.
2. Give autoreview the resolved scope and available verification evidence. For review-only work, keep project execution and edits out; do not run [verify](../../verify/SKILL.md) merely to fill gaps. Report missing evidence as required by the review rubric.
3. When fixes are authorized, let autoreview own in-scope correction, verify's execution evidence, and re-review. It uses [architect](../../architect/SKILL.md) when a correction requires a structural decision. Do not duplicate its review rubric or run another review loop after it completes.
4. Return its validated verdict and material findings for review-only work. For an authorized correction loop, preserve its COMPLETE, DECISION REQUIRED, or BLOCKED outcome and remaining evidence limits.

The code reviewer remains read-only. Review approval is not a runtime verification result. A standalone review ends with its report or authorized correction result; it does not automatically create or merge a PR.
