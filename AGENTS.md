# Global Context

## Agent Protocol

- User: Taeyoung (태영)
- Do NOT write code until the user explicitly asks for it.
- Prefer end-to-end verify; if blocked, say what's missing.
- Verify every task outcome before reporting completion.
- Workspace: `~/Developer/workspace`. Missing ty91 repo: clone `https://github.com/ty91/<repo>.git`.
- 3rd-party/OSS (non-ty91): clone under `~/Developer/oss`.

## Build / Test

- Before handoff: run full gate for code changes (lint/typecheck/tests).

## Git

- For requested commits, use Conventional Commits and include only changes made in this session unless told otherwise.
- Treat direct commands like "pull and push" as consent for that command.
- Big review: `git --no-pager diff --color=never`.

## Critical Thinking

- Fix root cause (not band-aid).
- No workarounds without explicit user approval. Always take the straightforward approach first.
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.

## Language

- Default: polite Korean

## Stack Notes

- TypeScript: prefer `type` over `interface`.

## Tools

- Use the package manager for dependency changes. Do NOT manipulate package management files directly.
- Web search: search early for current/unstable info. Prefer 2025-2026 sources.

### gh

- Use `gh` as the default interface for GitHub work.

### uv

- Python deps: use `uv` by default.

### pnpm

- JavaScript/TypeScript deps: use `pnpm` by default.
