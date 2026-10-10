---
name: cloudflare
description: Use the cf CLI to manage Cloudflare accounts, DNS, Workers, storage, and tunnels with explicit authentication profiles.
---

# Cloudflare CLI

Use `cf` for Cloudflare account and resource operations. Install with `npm install --global cf`; requires Node.js 22.18+, not the Bun runtime. Check command help: the CLI is in beta.

## Authentication and profiles

| Profile | Purpose |
| --- | --- |
| `default` | Personal account |
| `theyworks` | Work account |

Pass `--profile <NAME>` explicitly and verify its identity and accounts before operating.

```sh
cf auth list
cf auth whoami --profile default
cf zones list --profile theyworks
```

- Login: `cf auth login` for `default`, `cf auth create <NAME>` for a named profile. The user approves access in the browser.
- Directory binding: `cf auth activate <NAME> <DIRECTORY>` includes descendants.
- Credential priority: `CLOUDFLARE_API_TOKEN` (including `.env`) → `--profile` → nearest directory binding → `default`.
- Expired OAuth access tokens refresh automatically when possible. `expiresAt` is not the login session's final expiry.
- Automation: inject `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`; follow `one-password` for secrets. Discover account IDs at runtime. Select zones with `--zone <DOMAIN_OR_ID>`.
- Never commit credentials, emails, account/zone IDs, or resource inventories to this public repository.

## Working pattern

1. Run `cf cli search "<action and resource type>"`; exclude identifying values from searches.
2. Inspect the command's `--help` and `cf schema <COMMAND>`. If body fields are missing, consult the API reference and use `--body '<JSON>'`.
3. Confirm profile, account, zone, resource ID, and HTTP method. Operations default to remote; `--local` has limited support.
4. Preview changes with `--dry-run` where supported, execute within scope, and re-read the resource. Dry runs do not verify permissions or server-side validity.

## Important behavior

- JSON results use stdout; status/errors use stderr. Inspect output shape: arrays and envelopes both occur.
- Lists return one page. Check command-specific paging options before reporting totals.
- DNS `edit` is PATCH; `update` is PUT (overwrite). DNS create/edit currently require `--body` for record fields.
- Non-interactive deletes can print `Aborted.` and exit `0`. Verify state; `--force` can also alter API behavior.

## Workers projects

- Keep Wrangler for development/deployment in unmigrated Wrangler projects. `cf` resource commands work independently but ignore Wrangler's account setting.
- Inspect configuration first: `cf dev`, `cf build`, and `cf deploy --dry-run` can install packages and change files. Preview migration with `cf migrate --dry-run`.
- `cf build` skips the project's build script; preserve extra checks/code generation. Pin project versions and match the recorded mode for `--prebuilt` deployments.
- Live log streaming and single-secret updates still need Wrangler; check current support.

## References

- [Agent usage](https://developers.cloudflare.com/cf/agents/)
- [Authentication and profiles](https://developers.cloudflare.com/cf/get-started/)
- [Workers development and deployment](https://developers.cloudflare.com/cf/projects/)
- [Wrangler command mapping](https://developers.cloudflare.com/cf/wrangler/reference/)
