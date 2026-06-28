---
name: implement-all
description: Orchestrate implementation of all open sub-issues.
disable-model-invocation: true
---

Implement only the open sub-issues of the given issue **sequentially**, taking issue numbers and dependencies into account. Do not include completed, canceled, or otherwise closed sub-issues. For each open sub-issue, follow these instructions exactly.

For each individual sub-issue:

1. Open a new tmux session and start Codex.
2. Send `$implement <issue-id>` to Codex, for example `$implement ENG-372`.
3. Wait until Codex finishes the implementation, checking progress or results from time to time. You may also confirm whether a PR has been linked to the Linear issue. Codex implementation can take 30 minutes, and sometimes more than an hour, so **never cancel or terminate it midway**.
4. When Codex reports that the implementation and PR are complete, send `$merge-pr` to instruct it to merge the PR.
5. After the PR has been merged, close the tmux session.

Important:

- Never implement the work directly. The main agent only orchestrates.
- When sending input to Codex in a tmux pane, run `tmux send-keys` once to type the command, then run `tmux send-keys` again to send Enter.

Once all open sub-issues are implemented, mark the original issue provided by the user as complete and report the result.
