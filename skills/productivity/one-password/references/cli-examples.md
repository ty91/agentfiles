# op CLI examples

## Read

- `op read op://agents/vread-supabase/database\ password`
- `op read "op://agents/Cloudflare R2 (Wrangler)/api token"`
- `op read --out-file ./key.pem "op://agents/<item>/<file field>"`

## Run / Inject (preferred over writing secrets to disk)

- `export DB_PASSWORD="op://agents/vread-supabase/database password"`
- `op run --no-masking -- printenv DB_PASSWORD`
- `op run --env-file="./.env" -- <command>`
- `echo "db_password: {{ op://agents/vread-supabase/database password }}" | op inject`
- `op inject -i config.yml.tpl -o config.yml`

All of these follow the path-1 rules: prefix with the two override variables and append `</dev/null`.

## Whoami / accounts

- `op whoami` — with the service token exported, reports `SERVICE_ACCOUNT`.
- `op account list` — desktop-integrated accounts; shows `my.1password.com` / `ty91kr@gmail.com`.

## Account routing

- Default path: service account (`OP_SERVICE_ACCOUNT_TOKEN` from `~/.zshrc` + `--vault agents`). No `--account`, no `op signin` — either forces the desktop-app path.
- The exported token silently overrides `--account`; before any personal-account command, `unset OP_SERVICE_ACCOUNT_TOKEN` in that same shell.
- Personal reads: `--account my.1password.com` only in a consented desktop flow. Account email is `ty91kr@gmail.com` (no dot).

## Item create/edit without printing secrets

`op item create` category values are the human-readable name. For API tokens, use `"API Credential"` (case-sensitive).

Default (service account, agents vault, no prompts):

```bash
ITEM_TITLE="Service API Tokens"
FIELD_NAME="api_token"
TOKEN="$(pbpaste)"
OP_LOAD_DESKTOP_APP_SETTINGS=false OP_BIOMETRIC_UNLOCK_ENABLED=false \
  op item create --vault agents --category "API Credential" \
  --title "$ITEM_TITLE" "$FIELD_NAME[password]=$TOKEN" >/dev/null </dev/null
OP_LOAD_DESKTOP_APP_SETTINGS=false OP_BIOMETRIC_UNLOCK_ENABLED=false \
  op item get "$ITEM_TITLE" --vault agents --format json </dev/null >/dev/null && echo stored
```

Personal account (explicit ask only, consented desktop flow):

```bash
unset OP_SERVICE_ACCOUNT_TOKEN
op item edit "$ITEM_TITLE" --account my.1password.com "$FIELD_NAME[password]=$TOKEN" >/dev/null
```

## Vault administration (service account limits, verified 2026-08-13)

- Create vault: `op vault create <name>` — works.
- Grant a person access to a service-created vault:
  `op vault user grant --vault <name> --user <user-id> --permissions allow_viewing,allow_editing,allow_managing` — works.
- Delete a person-created vault: fails with 403; delete from the 1Password app/web instead.
- `op item move --current-vault <a> --destination-vault <b>` re-creates the item with a new ID; update any `op://` references afterward.
