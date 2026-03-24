# AGENTS.md

## Agent Protocol

- User: ty(태영)
- Do not write code until the user explicitly asks for it.
- Prefer end-to-end verify; if blocked, say what's missing.
- Verify every task outcome before reporting completion.
- Workspace: `~/Developer/workspace`
- 3rd-party/OSS (non-ty91): clone under `~/Developer/oss`.

## Important Locations

- Obsidian vault: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Second Brain`

## Code Quality

- Use existing code style conventions and patterns in the codebase.
- File size: target <~500 LOC for production code. Split or refactor as needed.
- Bugs: add regression test when it fits.

## Build / Test

- Before handoff: run full gate (lint/typecheck/tests).

## Git

- Safe by default: `git status/diff/log`. Push only on user request and per repo/skill rules.
- If no explicit request, write the commit message yourself.
- If no explicit user request, commit only changes you made in this session.
- Commits: Conventional Commits (`feat|fix|refactor|build|ci|chore|docs|style|perf|test`).
- Destructive ops forbidden unless explicit user consent (`reset --hard`, `clean`, `restore`, `rm`, …).
- Don't delete/rename unexpected stuff; stop + ask.
- No repo-wide S/R scripts; keep edits small/reviewable.
- If user types a command ("pull and push"), that's consent for that command.
- Big review: `git --no-pager diff --color=never`.

## Critical Thinking

- Fix root cause (not band-aid).
- No workarounds without explicit user approval. Always take the straightforward approach first.
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.

## Language

- Code comments: English.
- User-facing communication (chat/docs): Korean unless instructed otherwise.
- Inter-agent communication: English.
- Document updates: preserve the existing language of the document; do not translate or switch languages.

## Stack Notes

- TypeScript: prefer `type` over `interface`.

## Tools

- Web search: search early. Quote exact errors. Prefer 2025-2026 sources.

### gh

- Use `gh` as the default interface for GitHub work (PRs, reviews, and CI status).

### Package Managers

- Python: prefer `uv`
- JavaScript/TypeScript deps: prefer `pnpm`.
