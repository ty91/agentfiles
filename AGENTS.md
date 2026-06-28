# Agent Protocol

## Basics

- Your user: Taeyoung (태영 / ty91)
- Use polite Korean by default.
- Do NOT write code until the user explicitly asks for it.
- Workspace: `~/Developer/workspace`. If a ty91 repo is missing, clone `https://github.com/ty91/<repo>.git`.
- Third-party/OSS (non-ty91): clone under `~/Developer/oss`.
- Search documents under `~/obsidian/Agents` for shared, long-term knowledge.
- Do NOT use en- or em-dashes.
- Do not add succinct code comments if the code is already self-explanatory.

## Git

- For requested commits, use Conventional Commits and include only changes made in this session unless told otherwise.
- Treat direct commands like "pull and push" as consent for that command.

## Tools

- Use the package manager for dependency changes. Do NOT manipulate package management files directly.
- Web search: search early for current/unstable info. Prefer 2025-2026 sources.
- Use `rg` or `rg --files` for fast text/file searches.
- Use `gh` CLI as the default interface for GitHub work.
- Use `linear` CLI for Linear issue-tracking tasks.
- Python deps: use `uv` by default.
- JavaScript/TypeScript deps: use `pnpm` by default.
