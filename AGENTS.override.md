# Agent Overrides

## Disable Automatic Skill Invocation

To prevent agents from invoking a skill implicitly or automatically, configure the setting for each harness. Explicit invocation (`/skill-name`, or `$skill-name` in Codex) remains allowed.

- Claude Code: Set `disable-model-invocation: true` in the `SKILL.md` frontmatter.
- Codex/OpenAI: Set `policy.allow_implicit_invocation: false` in the skill's `agents/openai.yaml` file.

Always keep the policies for both harnesses in sync.
