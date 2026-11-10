---
name: swe
description: Explicit software-engineering entry point. Use for /swe or $swe to route a task through Feature, Bug fix, Refactoring, Design, Verification, or Review, applying the existing design, implementation, verification, and review skills.
disable-model-invocation: true
---

# SWE

Own the requested outcome. Choose one playbook, read its instructions, and follow the existing skills it names through completion. Keep rules in their owning skills instead of reconstructing them from memory.

## Start

1. Read the request, relevant repository instructions, and existing task context. State the goal, scope, intended deliverable, and material exclusions briefly. Infer what the repository can answer before asking the user.
2. Select the playbook by the outcome requested, not a keyword alone. Read its full file from the table below. For a mixed task, name the primary outcome and apply the relevant constraints from the other playbook without duplicating execution.
3. Read the linked SKILL.md files in full before using them. All links resolve relative to the file containing them, both in this repository and in the installed skill directories. A disabled automatic invocation policy does not prevent explicitly reading a dependency. If a required file is missing, locate the installed copy; if it is unavailable, report the missing dependency rather than silently substituting a workflow.
4. Track the playbook's work and evidence at a scale appropriate to the task. Keep required steps visible; when a conditional step does not apply, record a brief reason. Reuse completed work and evidence while their assumptions remain valid.
5. Continue until the playbook's deliverable is complete or a concrete unresolved condition prevents it. Report the outcome, evidence, and remaining limits. Do not convert a design, verification, or review request into implementation.

## Playbooks

| Playbook | Select when | Read |
|---|---|---|
| Feature | The user wants new or intentionally changed behavior implemented. | [feature.md](playbooks/feature.md) |
| Bug fix | The user wants a defect reproduced and corrected. | [bug-fix.md](playbooks/bug-fix.md) |
| Refactoring | The user wants structure changed while observable behavior stays the same. | [refactoring.md](playbooks/refactoring.md) |
| Design | The deliverable is a contract, model, architecture, or design recommendation. | [design.md](playbooks/design.md) |
| Verification | The user wants evidence that behavior or a change meets its contract, or wants the checks themselves written. | [verification.md](playbooks/verification.md) |
| Review | The user wants a change inspected for defects, scope, and verification gaps, with fixes only when authorized. | [review.md](playbooks/review.md) |

An explicit TDD request selects verify's test-first path inside the applicable playbook. It is not a seventh playbook. A bug-fix request stays Bug fix even when it requires a structural correction. A behavior change is Feature, not Refactoring.

Do not force an unrelated request into these routes. Read-only explanations, ticket publishing, repository setup, performance experiments, deployment, and merge management have no dedicated swe playbook here. Handle the actual request within its scope or state what is missing; do not invent an implemented route.

## Ownership and authority

- The request and repository instructions determine permission. This router does not independently authorize code edits, subagents, external writes, or merging.
- [implement](../implement/SKILL.md) owns implementation checkpoints, commit policy, final checks, review, and PR finalization for Feature, Bug fix, and Refactoring. Its default is in-place execution. Preserve explicit execution-mode and no-review choices and any narrower user restrictions. Do not run a second implementation or review loop after it finishes.
- If the task has no issue, use the request and derived acceptance criteria as its task context. Do not create a ticket as a prerequisite.
- [architect](../architect/SKILL.md) owns design criteria and candidate comparison. [verify](../verify/SKILL.md) owns test selection, regression and test-first methods, and execution evidence. [autoreview](../autoreview/SKILL.md) owns review orchestration and authorized correction loops.
- Read-only reviewers remain read-only. The parent executes authorized checks and fixes. A design decision alone does not grant permission to change code.
- Preserve pre-existing work, checkout constraints, and the original task boundary. Read context outside the diff as needed without broadening the edit scope.
- Apply [documentation](../documentation/SKILL.md) when the selected work changes durable contracts, terminology, or operating assumptions. It is a supporting skill, not an additional playbook.
- Honor each owning skill's completion conditions. A review approval does not prove execution checks passed, and a verification gap must not disappear in the final report.
