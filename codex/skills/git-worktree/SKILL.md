---
name: git-worktree
description: "Use this skill for Git worktree-specific tasks only: creating, listing, pruning, removing, repairing, or moving git worktrees. Do not use this skill for ordinary Git work that does not involve git worktree."
---

# Git Worktree

## Overview

Use this skill whenever the task involves `git worktree`. Keep ordinary Git operations outside this skill unless they are directly needed for the worktree task.

## Trigger Rule

- MUST use this skill for Git worktree tasks.
- MUST NOT use this skill for generic Git tasks such as normal commits, pushes, pulls, branches, merges, rebases, checkouts, or PR work unless the task explicitly involves `git worktree`.
- If a request mixes worktree and non-worktree Git work, apply this skill only to the worktree portion.

## Required Worktree Location

All Git worktrees MUST be created under:

```text
~/.reco/worktrees/<local-repo-path>/<branch-name>
```

- `<local-repo-path>` is the absolute local repository path with every `/` replaced by `-`.
- `<branch-name>` is the Git branch name with every `/` replaced by `-`.
- Preserve all other characters unless they are invalid for the filesystem.
- Never create Git worktrees in ad-hoc directories, inside the source repo, or directly under `/tmp`.

Example:

```text
repo path:    /Users/taeyoung/Developer/workspace/example
branch name:  feature/add-login
worktree:     ~/.reco/worktrees/-Users-taeyoung-Developer-workspace-example/feature-add-login
```

## Workflow

1. Confirm the task is worktree-related. If not, do not use this skill.
2. Resolve the repository root with `git rev-parse --show-toplevel`.
3. Resolve the target branch name from the user request or current task context.
4. Compute the required worktree path by replacing `/` with `-` in the repo path and branch name.
5. Check existing worktrees with `git worktree list` before creating, moving, removing, or pruning.
6. Create parent directories under `~/.reco/worktrees/` as needed.
7. Run the requested `git worktree` operation using the required path.
8. Verify the result with `git worktree list` and, when relevant, `git status` inside the worktree.

## Creation Command Pattern

For an existing branch:

```sh
git worktree add "$HOME/.reco/worktrees/<local-repo-path>/<branch-name>" "<branch-name>"
```

For a new branch:

```sh
git worktree add -b "<branch-name>" "$HOME/.reco/worktrees/<local-repo-path>/<branch-name>"
```

Use the equivalent safe form for other `git worktree` subcommands while preserving the required path convention.
