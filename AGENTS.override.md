# Agent Overrides

## 스킬 자동 호출 막기

에이전트가 스킬을 암묵적으로(자동) 호출하지 못하게 하려면 하네스별로 설정한다. 명시 호출(`/skill-name`, Codex의 `$skill-name`)은 그대로 허용된다.

- Claude Code: `SKILL.md` frontmatter에 `disable-model-invocation: true`
- Codex/OpenAI: 해당 스킬의 `agents/openai.yaml`에 `policy.allow_implicit_invocation: false`

두 하네스 정책은 항상 일치시킨다.
