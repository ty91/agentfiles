---
name: obsidian
description: "Obsidian vault: search/read/write notes, backlinks, Bases, Canvas."
---

# Obsidian

Use this for local Obsidian vault work. An Obsidian vault is a normal folder of Markdown files plus `.obsidian/` config.

## Sources

- App config (vault registry): `~/Library/Application Support/obsidian/obsidian.json`
- Official CLI: `obsidian`
- List vaults with `obsidian vaults`; resolve a vault's path with `obsidian vault=<vault> vault info=path`.
- Target a vault with the global `vault=<name>` option (works from any cwd). Without it, the CLI resolves the vault from cwd only when inside a vault; otherwise it silently falls back to the app's currently active vault — never rely on that fallback.

## First Checks

```bash
command -v obsidian
obsidian version
obsidian vaults
obsidian vault=<vault> vault
obsidian help
```

Always use `obsidian help` (or `obsidian help <command>`) for CLI discovery.
`obsidian commands` is not for discovery; it lists the app's command-palette
commands, only for use with `obsidian command id=<command-id>`.

If `obsidian` says CLI is disabled:

1. Prefer asking the user to enable Settings -> General -> Advanced -> Command line interface.
2. If you already confirmed the app config shape, `~/Library/Application Support/obsidian/obsidian.json` uses `"cli": true`.
3. Restart Obsidian after changing app-level CLI config.

## Read Workflow

Prefer official CLI for Obsidian-aware lookups:

```bash
obsidian vault=<vault> search query="handoff" format=json
obsidian vault=<vault> search:context query="handoff" limit=20 format=json
obsidian vault=<vault> read path="Folder/Note.md"
obsidian vault=<vault> file path="Folder/Note.md"
obsidian vault=<vault> outline path="Folder/Note.md" format=json
obsidian vault=<vault> backlinks path="Folder/Note.md" format=json
obsidian vault=<vault> links path="Folder/Note.md"
obsidian vault=<vault> properties path="Folder/Note.md" format=json
```

Use direct filesystem reads when you already know the path and need exact bytes:

```bash
sed -n '1,220p' "/path/to/vault/Folder/Note.md"
rg -n "term" "/path/to/vault"
```

Report which source you used when freshness or vault choice matters.

## Write Workflow

Choose the narrowest write path:

- New note: `obsidian vault=<vault> create path="Folder/Note.md" content="..."`.
- Append/prepend daily notes: `obsidian vault=<vault> daily:append content="..."`.
- Simple note edits: edit the Markdown file directly with the file-editing tool.
- Rename/move notes: prefer `obsidian move`/`obsidian rename` so links can update.
- Frontmatter: prefer `property:read`/`property:set`/`property:remove` over hand-editing YAML.
- Opening UI after a write: add `open` only when useful or requested.

Common commands:

```bash
obsidian vault=<vault> create path="Notes/New.md" content="# New\n\nBody"
obsidian vault=<vault> append path="Notes/New.md" content="More text"
obsidian vault=<vault> move path="Notes/New.md" to="Archive"
obsidian vault=<vault> property:set name="status" value="active" path="Notes/New.md"
obsidian vault=<vault> daily:path
obsidian vault=<vault> daily:read
obsidian vault=<vault> daily:append content="- Follow-up item"
```

For multi-line content, prefer editing the `.md` file directly once the path is known. Avoid fragile shell quoting for long prose.

## Bases, Canvas, Plugins

Use CLI discovery first:

```bash
obsidian vault=<vault> bases
obsidian vault=<vault> base:views path="Projects.base"
obsidian vault=<vault> base:query path="Projects.base" view="Active" format=json
obsidian vault=<vault> plugins format=json
obsidian vault=<vault> plugins:enabled format=json
```

For `.canvas`, `.base`, and `.json` files, read/edit as structured data when possible. Keep formatting stable and validate JSON after edits.

## Safety

- Multiple vaults exist; never guess which one. Always pass `vault=<name>` unless cwd is inside the target vault — outside a vault the CLI silently targets the app's active vault, so an unqualified write can land in the wrong vault.
- Do not bulk rewrite a vault. Use targeted paths and review diffs.
- Do not edit `.obsidian/` unless the user asks or the task is explicitly settings/plugin work.
- Do not delete notes unless explicitly asked; `obsidian delete` moves to trash by default — never pass `permanent` without an explicit request.
- Do not create hidden dot-folder notes through the Obsidian URI/CLI path.
- Preserve frontmatter and wikilinks unless the task is to refactor them.
