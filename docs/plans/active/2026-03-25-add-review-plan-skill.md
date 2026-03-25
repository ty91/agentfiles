# Add review-plan Skill

## Context

현재 워크플로우에서 `create-plan`(Claude) → `executing-plan`(Codex)으로 이어지지만, 중간에 계획을 검증하는 단계가 없다. 계획의 실현 가능성과 완성도를 Codex로 리뷰하는 Claude Code 스킬을 추가하여 **create-plan → review-plan → executing-plan** 흐름을 완성한다.

## Implementation Approach

파일 1개만 생성하면 된다: `claude/skills/review-plan/SKILL.md`

`setup-skills.sh`는 `claude/skills/` 하위 디렉토리를 자동 탐색하므로 별도 수정 불필요 (line 61의 glob loop).

### SKILL.md 구조

**Frontmatter:**
```yaml
---
name: review-plan
description: Review a plan file for feasibility and completeness by delegating to Codex agent.
argument-hint: "[plan file path or partial name]"
allowed-tools: Bash(codex:*), Bash(ls:*), Bash(cat:*), Bash(wc:*), Read, Glob, AskUserQuestion
---
```

**Context section** (merge-pr 패턴 따름):
```markdown
## Context
- Current directory: !`pwd`
- Candidate from argument: `#$ARGUMENTS`
- Active plans: !`ls docs/plans/active/*.md 2>/dev/null || echo "No active plans found"`
```

**Steps:**

### Step 1: Resolve plan file

| 인자 | 동작 |
|------|------|
| 정확한 경로 (e.g., `docs/plans/active/2026-03-25-foo.md`) | `ls`로 존재 확인 후 사용 |
| 날짜 (e.g., `2026-03-25`) | `docs/plans/active/<date>-*.md` 매칭 |
| 키워드 (e.g., `authentication`) | `docs/plans/active/*-*<keyword>*.md` 매칭 |
| 인자 없음 | `docs/plans/active/` 목록 → AskUserQuestion으로 선택 |
| 다수 매칭 | 목록 보여주고 사용자 선택 요청 |
| 매칭 실패 | 에러 + 사용 가능한 계획 목록 표시, 중단 |

단일 파일이 확정될 때까지 진행하지 않는다.

### Step 2: Verify codex CLI

`codex --version` 실행. 미설치 시 안내 메시지 출력하고 중단:
> `codex` CLI is not installed. Install it with `npm install -g @openai/codex` and try again.

### Step 3: Run Codex review

절대 경로로 변환한 후 실행:

```bash
codex exec --full-auto --ephemeral \
  -o /tmp/plan-review-result.md \
  "<리뷰 프롬프트>"
```

**리뷰 프롬프트 내용:**

```
Review the implementation plan at <ABSOLUTE_PLAN_PATH>.

## Instructions

1. Read the plan file completely.
2. Explore the codebase to verify feasibility:
   - Do the files, functions, and modules referenced in the plan actually exist?
   - Are there dependency or constraint conflicts?
   - Does the plan conflict with existing code patterns or conventions?
3. Check completeness:
   - Are there missing implementation steps?
   - Are edge cases and error handling addressed?
   - Are verification/testing steps sufficient?
4. Output your review in this exact format:

## Verdict: PASS | NEEDS REVISION

## Feasibility Issues
- [P0|P1|P2] description with file references
(or "None found." if no issues)

## Completeness Gaps
- missing item or concern
(or "None found." if no gaps)

## Suggestions
- improvement recommendation
(or "None." if no suggestions)

P0 = blocks execution, P1 = significant risk, P2 = minor concern.
If there are any P0 issues, the verdict MUST be NEEDS REVISION.
```

### Step 4: Handle errors

- `codex exec` 비정상 종료 → 에러 출력, 재시도 안 함
- `/tmp/plan-review-result.md` 없거나 빈 파일 → 실패로 간주, 에러 출력
- 정상이면 다음 단계로

### Step 5: Present results

- `/tmp/plan-review-result.md` 읽어서 터미널에 그대로 출력
- 파일 수정/커밋 일체 없음
- NEEDS REVISION이면 `executing-plan` 실행 전 이슈 해결을 권장

## Critical Files

| 파일 | 역할 |
|------|------|
| `claude/skills/review-plan/SKILL.md` | **생성** — 스킬 정의 (유일한 deliverable) |
| `claude/skills/merge-pr/SKILL.md` | 참조 — Context section, frontmatter 패턴 |
| `claude/skills/jira/SKILL.md` | 참조 — CLI 가용성 체크 패턴 |
| `codex/skills/executing-plan/SKILL.md` | 참조 — plan file resolve 패턴 |
| `setup-skills.sh` | 확인 — 자동 탐색으로 수정 불필요 |

## Reusable Patterns

- **Frontmatter format**: `merge-pr/SKILL.md` (name, description, argument-hint, allowed-tools)
- **Context with shell interpolation**: `merge-pr/SKILL.md` (`!` backtick, `#$ARGUMENTS`)
- **CLI availability check**: `jira/SKILL.md` (check before first command)
- **Plan file resolution logic**: `codex/skills/executing-plan/SKILL.md` (argument → glob → ask user)

## Verification

1. `mkdir -p claude/skills/review-plan && cat claude/skills/review-plan/SKILL.md` — 파일 존재 및 내용 확인
2. `bash setup-skills.sh --dry-run` — 새 스킬이 감지되는지 확인
3. `bash setup-skills.sh` — 심링크 생성
4. `ls -la ~/.claude/skills/review-plan` — 심링크 정상 확인
5. `/review-plan` 호출 (인자 없음) — active plans 목록 또는 "No active plans found" 확인
6. 실제 계획 파일이 있다면 `/review-plan <path>` — codex exec 실행 및 리뷰 결과 출력 확인
