---
name: implement
description: Implement one assigned task issue end-to-end in the current codebase.
disable-model-invocation: true
---

Implement the work described by the user in the PRD or an issue. Read the passed issue's full body and comments to understand the goal. Also read the parent issue's full body and comments for further understanding, if exists.

You MUST first create a new git worktree and install dependencies before implementing.

Use `tdd` skill where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, commit regularly, and the full test suite once at the end.

Once done, use `review` skill to review the work and fix every merge blockers before submitting.

Finally, create a pull request of your work using `pr` skill.
