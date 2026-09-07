# Agent Overrides

## Disable Automatic Skill Invocation

To prevent agents from invoking a skill implicitly or automatically, configure the setting for each harness. Explicit invocation (`/skill-name`, or `$skill-name` in Codex) remains allowed.

- Claude Code: Set `disable-model-invocation: true` in the `SKILL.md` frontmatter.
- Codex/OpenAI: Set `policy.allow_implicit_invocation: false` in the skill's `agents/openai.yaml` file.

Always keep the policies for both harnesses in sync.

## Removing Skills

When asked to delete a skill from this repo, also uninstall it from this machine:
- Run `npx skills remove <skill-name> --global --yes`. Multiple names are supported. Omit `--agent` to remove all agent links.
- Verify removal with `npx skills list --global --json`.
- Remove only the requested skills; never use `--all`.
