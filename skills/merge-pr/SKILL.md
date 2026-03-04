---
name: merge-pr
description: Merge a GitHub pull request and clean up branch/worktree state.
argument-hint: "[PR number|PR URL|branch name]"
allowed-tools: Bash(git:*), Bash(gh:*), AskUserQuestion
---

## Context

- Current directory: !`pwd`
- Current branch: !`git branch --show-current 2>/dev/null || echo "Not a git repository"`
- Candidate from argument: `#$ARGUMENTS`
- Candidate from current branch: !`gh pr view --json number,url --jq '"#\(.number) \(.url)"' 2>/dev/null || echo "No PR inferred from current branch"`

## Your task

Merge the target PR and fully clean up branch/worktree state.

### 1) Identify the PR

- First priority: use `#$ARGUMENTS` if provided.
- If no argument is provided, infer from recent conversation context (the user usually runs this right after the `pr` skill).
- If still unclear, try `gh pr view` from the current branch.
- If still ambiguous, ask the user for PR number or URL and stop until clarified.

### 2) Verify PR exists

- Run `gh pr view <PR> --json number,url,state,headRefName,baseRefName,isCrossRepository`.
- If lookup fails, report it clearly and stop.
- If PR is already merged/closed, report current state and ask user whether to continue with cleanup-only.

### 3) Merge via `gh`

- Choose a non-interactive merge method:
  - Prefer `--squash` if enabled for the repo.
  - Otherwise use `--merge`, then `--rebase`.
- Run `gh pr merge <PR> --<method> --delete-branch`.
- Verify merge with `gh pr view <PR> --json state,mergedAt,mergeCommit,url`.

### 4) If current directory is a worktree, return to the original repo directory

- Detect worktree by comparing `git rev-parse --absolute-git-dir` and `git rev-parse --git-common-dir`.
- If they differ:
  - Save current worktree path.
  - Resolve original repo root from `<git-common-dir>/..`.
  - `cd` to that original repo root before cleanup.

### 5) Sync `main`

- If current branch is not `main`, checkout `main`.
- Pull latest `main` with fast-forward only.
- Fetch with prune to refresh remote-tracking branches.

### 6) Ensure remote branch is removed

- Use `headRefName` from PR metadata.
- If `origin/<headRefName>` still exists after prune, delete it with git (for same-repo PRs).
- Fetch with prune again and verify `origin/<headRefName>` is gone.
- If it is a cross-repo PR, explain that the source branch may not be deletable from this remote.

### 7) Remove local branch and worktree

- Delete local source branch if it still exists (and is not `main`).
- If this run started in a worktree, remove that worktree from the original repo.
- Verify cleanup:
  - `git branch --list <headRefName>` is empty.
  - `git worktree list` does not include the removed path.

### 8) Report result

- Return:
  - PR URL/number
  - Merge status and merge commit SHA
  - Whether remote branch was removed
  - Whether local branch/worktree cleanup succeeded
