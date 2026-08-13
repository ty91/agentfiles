---
name: one-password
description: "REQUIRED before ANY `op` command or whenever a task needs an API key, token, password, credential, or secret. Prompt-free 1Password service-account reads; wrong invocations spam macOS dialogs."
---

# 1Password CLI

## Install (stable path only — never brew)

`op` lives at `~/.local/bin/op` (universal binary, currently 2.38.1). Do NOT install or upgrade via the Homebrew cask: its versioned Caskroom path gives `op` a new macOS TCC identity on every upgrade, which re-fires the App Data Protection dialog. The Homebrew install was removed on 2026-08-13 for exactly this reason.

To update: download the official signed pkg from https://app-updates.agilebits.com/product_history/CLI2, verify with `pkgutil --check-signature` (Developer ID Installer: AgileBits Inc. `2BUA8C4S2C`, Apple-notarized), then `pkgutil --expand-full <pkg> <dir>` and `install -m 755 <dir>/op.pkg/Payload/op ~/.local/bin/op`. Never double-click the installer — its default target is `/usr/local/bin`, not the stable path. After any update, repeat the prompt-free `whoami` check below.

## References

- Official docs: https://developer.1password.com/docs/cli/get-started/
- App-integration toggle: https://developer.1password.com/docs/cli/app-integration/
- Known repeated-dialog bug: https://github.com/1Password/shell-plugins/issues/586
- Upstream skill this one is adapted from: https://github.com/steipete/agent-scripts (`skills/one-password`)
- `references/cli-examples.md` (op read/run/inject examples, account routing, safe create/edit patterns)

## Access paths (strict order)

**1. Service account — default, zero prompts.** `OP_SERVICE_ACCOUNT_TOKEN` is exported from `~/.zshrc`, scoped to the `agents` vault (read+write). Every service-account command must set both `OP_LOAD_DESKTOP_APP_SETTINGS=false` and `OP_BIOMETRIC_UNLOCK_ENABLED=false`, and keep stdin off the terminal with `</dev/null`. The first variable prevents the desktop-app settings read that triggers the macOS dialog; the second is 1Password's official app-integration override.

- Required command shape: `OP_LOAD_DESKTOP_APP_SETTINGS=false OP_BIOMETRIC_UNLOCK_ENABLED=false op item get "<item>" --vault agents ... </dev/null`
- `--vault agents` is required on reads.
- NEVER `op signin` and NEVER `--account` on this path. Either one routes through the desktop app. Worse: while `OP_SERVICE_ACCOUNT_TOKEN` is exported, it silently overrides `--account` and confines reads to service-account vaults — commands "succeed" against the wrong scope.
- Token missing/expired or a read fails: report the exact error and ask. Do NOT silently fall back to the desktop app.
- Quick health check: `OP_LOAD_DESKTOP_APP_SETTINGS=false OP_BIOMETRIC_UNLOCK_ENABLED=false op whoami </dev/null >/dev/null 2>&1; echo op_rc:$?`

Verified service-account permission boundary (2026-08-13, op 2.38.1):

- CAN create vaults (`op vault create`).
- CAN grant users access to vaults it created (`op vault user grant --vault <v> --user <id> --permissions allow_viewing,allow_editing,allow_managing`).
- CAN move items between vaults it can write to (`op item move`) — but this re-creates the item with a NEW ID.
- CANNOT delete vaults created by a person (403 Forbidden); it can only delete vaults it created itself. Person-created vaults must be deleted from the app/web.

**2. Desktop app — explicit consent only.** For items genuinely outside `agents` (the personal `Personal` vault). No automatic fallback.

- STOP and ask in chat first: item name + why needed. Wait for yes.
- After consent, in the SAME command: `unset OP_SERVICE_ACCOUNT_TOKEN` first, then use `--account my.1password.com`. The unset must happen in every shell — `~/.zshrc` re-exports the token on each shell init.
- Desktop app integration is enabled on this machine, so no `op signin` is needed while the 1Password app is unlocked; the app handles authorization. If the app is locked, the command waits on the app's unlock prompt.
- The 1Password account email is `ty91kr@gmail.com` — NO dot. `ty91.kr@gmail.com` is not a user in this account and fails user lookups.
- Read metadata only unless the task needs a value; never print values.

## Known items in `agents` (skip discovery)

Exact titles; go straight to the service-account read. No enumeration needed.

| Purpose | Item title | Fields of note |
|---|---|---|
| Cloudflare R2 via Wrangler | `Cloudflare R2 (Wrangler)` | `access key id`, `secret access key` (concealed), `api token` (concealed), `account id`, `s3 api endpoint` |
| Supabase backup DB | `Supabase PostgreSQL Backup` | `host`, `port`, `database name`, `username`, `database password` (concealed), `Supabase project ref` |
| vread Supabase DB | `vread-supabase` | `host`, `port`, `database name`, `username`, `database password` (concealed), `Supabase project ref` |

History: these items were consolidated into `agents` from the retired `infra` and `studio-jakdo` vaults on 2026-08-13. `op item move` issues new item IDs, so any old `op://infra/...` or `op://studio-jakdo/...` secret reference is dead — use `op://agents/...`.

## Workflow

1. Known/expected `agents` item → service-account read directly (path 1). Run the `whoami` health check first if unsure the token works.
2. Item unknown → check the table above → vault-scoped metadata search in `agents` (service account, titles/ids only) → only then the desktop consent ask (path 2).
3. Always append `</dev/null` so `op` never waits on interactive stdin.
4. New secrets default to the `agents` vault via the service account. Personal-vault writes only on explicit ask.

## Exact field reads

For a known item, verify the field shape before using it live: length, expected prefix, newline count — never the value. `op --field NAME` and `--fields label=NAME` can silently return the WRONG concealed field when an item has several concealed fields (upstream measured 65 chars returned where the correct value was 4432 — a truncated secret pushed into CI). For anything feeding CI, config, or another service, read the item as JSON and extract the exact label:

```bash
value="$(
  OP_LOAD_DESKTOP_APP_SETTINGS=false \
    OP_BIOMETRIC_UNLOCK_ENABLED=false \
    op item get "<item title>" --vault agents --format json </dev/null |
    FIELD_LABEL="<label>" node -e 'let s="";process.stdin.on("data",d=>s+=d);process.stdin.on("end",()=>{const f=(JSON.parse(s).fields||[]).find(x=>x.label===process.env.FIELD_LABEL);if(!f?.value)process.exit(2);process.stdout.write(f.value);})'
)"
echo "field_len:${#value}"
echo "field_has_newline:$(printf %s "$value" | wc -l | tr -d ' ')"
```

Keep JSON extraction scoped to the known item and vault. Do not enumerate vaults or items to discover candidates.

## Known working secret-write pattern

```bash
OP_LOAD_DESKTOP_APP_SETTINGS=false OP_BIOMETRIC_UNLOCK_ENABLED=false \
  op item create --vault agents --category "API Credential" \
  --title "<title>" "<field>[password]=<value>" >/dev/null </dev/null
OP_LOAD_DESKTOP_APP_SETTINGS=false OP_BIOMETRIC_UNLOCK_ENABLED=false \
  op item get "<title>" --vault agents --format json </dev/null >/dev/null && echo stored
```

The `op` category string is human-readable and case-sensitive: use `"API Credential"`, not `api_credential`. Never echo the value; verify by reading it back into `/dev/null` or by shape check only.

## Repeated macOS App Data dialogs

At startup `op` reads the 1Password desktop app's group-container settings unless `OP_LOAD_DESKTOP_APP_SETTINGS=false` is set; macOS can then fire the App Data Protection dialog ("op would like to access data from other apps") and block in `open()` until answered. `OP_BIOMETRIC_UNLOCK_ENABLED=false` alone is NOT sufficient (verified upstream on op 2.35). TCC approval can be PID-scoped: a later `op` process may prompt again despite a previous Allow. Each executable path is also a separate TCC client — that is why `op` stays at the one stable path.

If dialogs repeat: stop the retry loop and fix the invocation (add the two overrides); do not keep clicking Allow. Every `op` run can spawn a background `op daemon`; stale daemons can re-trigger dialogs. Only when no `op` task is active, `pkill -f 'op daemon'` is safe.

## Guardrails

- Never paste secrets into logs, chat, or code. Shape-only validation (length/prefix/newlines).
- Path-1 commands always set both override variables and keep stdin plus secret-bearing stdout off the terminal.
- Prefer `op run` / `op inject` over writing secrets to disk.
- No broad enumeration: vault-scoped, metadata-only searches, only when an exact-title read failed or the user asked.
- Desktop path only after explicit chat consent; the app's unlock prompt then handles actual authorization.
- Never `eval "$(op completion zsh)"` unguarded in rc files; it runs `op` on every shell start and is a known dialog-spam source.
