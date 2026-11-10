# agentfiles

개인 에이전트 지침과 스킬을 관리합니다.

- [엔지니어링 스킬 지도](docs/engineering-skills.md): 역할, 호출 조건, 원칙 소유권과 확장 영역
- [Architect](skills/engineering/architect/SKILL.md): 계약·상태·소유권·경계 설계
- [Verify](skills/engineering/verify/SKILL.md): 변경·회귀·test-first 검증
- [Autoreview](skills/engineering/autoreview/SKILL.md): 독립 코드 검토와 수정 완료 관리

`setup.sh`는 지침과 에이전트 설정을 연결하고, 스킬을 Codex와 Claude Code에 전역 설치합니다. 변경 없이 설치 작업을 확인하려면 `./setup.sh --dry-run`을 사용합니다.
