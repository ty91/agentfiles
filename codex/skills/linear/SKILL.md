---
name: linear
description: 'Use the Linear CLI for issue-tracking work: fetch/query issues, create/update issues, add comments or replies, link URLs, delete issues, and fall back to raw GraphQL when the CLI output is insufficient.'
---

# Linear CLI

Use `linear` for Linear issue-tracking. Read repo guidance first (`AGENTS.md`, `CLAUDE.md`, `docs/agents/issue-tracker.md`) and follow its workspace/team/project conventions. Workspace slug, team key, issue prefix, default project, labels, and workflow state names are repo-specific. Do not hardcode them from another repo.

## Core Commands

```bash
# auth / discovery
linear auth whoami --workspace <workspace>
linear team list --workspace <workspace>
linear project list --workspace <workspace>

# read / query
linear issue view <TEAM-123> --workspace <workspace>
linear issue comment list <TEAM-123> --workspace <workspace>
linear issue query --workspace <workspace> --team <TEAM> --state started --json --no-pager
linear issue query --workspace <workspace> --team <TEAM> --search "검색어" --json --no-pager

# create / update
linear issue create --workspace <workspace> --no-interactive --team <TEAM> \
  --project <project> --title "제목" --description-file /tmp/linear-description.md
linear issue update <TEAM-123> --workspace <workspace> --state started --priority 3 --label <label>

# comments / replies
linear issue comment add <TEAM-123> --workspace <workspace> --body-file /tmp/linear-comment.md
linear issue comment add <TEAM-123> --workspace <workspace> --parent <comment-id> --body "대댓글"
linear issue comment update <comment-id> --workspace <workspace> --body "수정된 댓글"
linear issue comment delete <comment-id> --workspace <workspace>

# links / delete
linear issue link <TEAM-123> https://github.com/org/repo/pull/123 --workspace <workspace> --title "PR"
linear issue delete <TEAM-123> --workspace <workspace> --confirm
```

Use `--description-file` / `--body-file` for Markdown or anything multiline. Use `--no-interactive` for issue creation. Use `--confirm` for deletion only when the user explicitly requested or approved deletion.

## Gotchas From Actual Use

- Always pass the repo's configured `--workspace <workspace>`. Do not rely on the default workspace.
- `linear issue delete` does not make the issue disappear from direct lookup. It moves it to trash/archive. Verify with GraphQL fields `trashed` and `archivedAt`.
- `Issue.deletedAt` is not a GraphQL field. Do not query it.
- `label list` has its own `--workspace` option meaning “workspace-level labels”, so put the global workspace selector before the subcommand:

```bash
linear --workspace <workspace> label list --all
linear --workspace <workspace> label list --team <TEAM>
```

- To delete a threaded comment conversation, delete replies first, then the parent comment.
- State type values work (`started`, `completed`, etc.) and map to the workspace's concrete state names such as `In Progress`.

## GraphQL Fallback

Use `linear api` when CLI output is not enough or deletion/trash state must be checked.

```bash
linear api --workspace <workspace> \
  'query($id: String!) { issue(id: $id) { id identifier title state { name type } comments { nodes { id body parent { id } } } } }' \
  --variable id=<TEAM-123>

linear api --workspace <workspace> \
  'query($id: String!) { issue(id: $id) { id identifier title archivedAt trashed } }' \
  --variable id=<TEAM-123>
```

## Working Pattern

For a ticket task: `issue view`, then `comment list` if discussion matters, then act. After mutation, re-read the issue or comments to confirm the result.
