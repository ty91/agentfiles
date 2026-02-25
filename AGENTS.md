# AGENTS.md

## Agent Protocol

- Do not write code until the user explicitly asks for it.
- Prefer end-to-end verify; if blocked, say what's missing.
- Verify every task outcome before reporting completion.

## Code Quality

- Use existing code style conventions and patterns in the codebase.
- File size: target <~500 LOC for production code. Split or refactor as needed.
- Bugs: add regression test when it fits.

## Build / Test

- Before handoff: run full gate (lint/typecheck/tests).
- Test files: target <~500 LOC as a readability guardrail, not a hard limit.
- Prefer split when a test file becomes hard to navigate/review/debug (typically >500-700 LOC).
- Split by behavior/feature/suite boundaries; avoid arbitrary line-count splits.
- Exceptions allowed (table-driven matrices, integration/e2e flows, snapshot-heavy specs). Add short rationale in PR when exceeding guideline.

## Git

- Safe by default: `git status/diff/log`. Push only on user request and per repo/skill rules.
- If no explicit request, write the commit message yourself.
- If no explicit user request, commit only changes you made in this session.
- Commits: Conventional Commits (`feat|fix|refactor|build|ci|chore|docs|style|perf|test`).
- `git checkout` ok for PR review / explicit request.
- Branch changes require user consent.
- Destructive ops forbidden unless explicit (`reset --hard`, `clean`, `restore`, `rm`, …).
- Don't delete/rename unexpected stuff; stop + ask.
- No repo-wide S/R scripts; keep edits small/reviewable.
- If user types a command ("pull and push"), that's consent for that command.
- Do not run `git add`, `git commit`, and `git push` in parallel; run them sequentially.
- Big review: `git --no-pager diff --color=never`.
- Multi-agent: check `git status/diff` before edits; ship small commits.

## Critical Thinking

- Fix root cause (not band-aid).
- No workarounds without explicit user approval. Always take the straightforward approach first.
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.

## Language

- Code comments: English.
- User-facing communication (conversations, docs): English unless instructed otherwise.
- Inter-agent communication: English.
- Document updates: preserve the existing language of the document. Do not translate or switch languages.

## Stack Notes

- TypeScript: prefer `type` over `interface`. Keep files small; follow existing patterns.

## Tools

- Use the package manager for dependency changes. Do NOT manipulate package management files directly.
- Web search: search early. Quote exact errors. Prefer 2025-2026 sources.

### gh

- Use `gh` as the default interface for GitHub work (PRs, reviews, and CI status).

### uv

- Python deps: use `uv` only.

### pnpm

- JavaScript/TypeScript deps: use `pnpm` only.

### browser

- Web automation: see `~/.agents/docs/tools/browser.md` for agent reference.

## msg

- After long tasks (e.g., planning/plan execution), send a brief `msg noti <message>` and continue unless user input is needed.
- If you are a spawned subagent, do not use `msg noti`.
