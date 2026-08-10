---
name: update-knowledge
description: Maintain the user's durable knowledge vault with concise operational memory. Use when Codex determines a stable preference, repo mapping, workflow rule, harness behavior, recurring decision, or routing hint should be saved for future agents; also use when the user asks to update knowledge, memory, durable notes, or update_knowledge.
---

# Update Knowledge

Treat fresh-agent context window as scarce. Knowledge should be a routing aid, not a second README: save only the smallest durable hint that helps a future agent reach the right source of truth, then let that agent inspect the repo, docs, or data source directly.

## Workflow

1. Identify the durable fact.
   - Save stable preferences, repo/data-source mappings, workflow rules, harness behavior, and recurring decisions.
   - Do not save one-off task details, private Slack transcripts, secrets/tokens, temporary debugging notes, or unverified guesses.

2. Read narrowly.
   - Start at `~/obsidian/README.md`.
   - Follow only the relevant link.
   - Do not load the whole vault.

3. Choose the smallest edit.
   - Prefer updating an existing specific note.
   - Add a new note only when a durable topic needs its own routing target.
   - Keep `README.md` as a concise index/map, not a detail page.

4. Keep content short.
   - Write the minimum hint a fresh agent needs to find the right repo, document, data source, or workflow.
   - Avoid duplicating information already available in repo README, AGENTS, docs, or source.
   - Prefer pointers to source-of-truth locations over summaries.

5. Preserve style and safety.
   - Preserve the existing language of the note.
   - Do not add relative-time wording like "now", "from now on", or "going forward" for current-state docs.
   - Include source-aware phrasing when useful, e.g. "User preference:" or "Repo mapping:".
   - Never write secrets, tokens, or private transcript excerpts.

6. Verify.
   - Re-read the changed note.
   - Confirm links and paths are correct.
   - Tell the user which knowledge note changed.
