# Writing Feature Specs

Write the spec primarily in Korean. Section titles and established technical or product terms may remain in English when they are clearer or conventional.

Each requirement MUST be clear, unambiguous, and independently testable.

If any required information is still unknown after the interview, either continue `grilling` only for that gap or mark it with `[NEEDS CLARIFICATION: ...]`.

## User Story Rules

Each user story MUST:

- Have a priority: `P1`, `P2`, or `P3`
- Be independently testable
- Be independently demoable
- Deliver user-visible value on its own

Priority definitions:

- `P1`: Required for the MVP
- `P2`: Important, but should come after P1
- `P3`: Nice-to-have extension

## Quality Checklist

Before publishing, ensure the spec satisfies all of the following:

- Contains no implementation details
- Is centered on user value
- Is readable by non-technical stakeholders
- Has testable requirements
- Has measurable success criteria
- Has acceptance scenarios
- Has edge cases
- Has clear scope boundaries

## Feature Spec Template

```md
# 기능 명세: [기능 이름]

## 유저 시나리오

### User Story 1 - [짧은 제목] (우선순위: P1)

[이 유저 여정을 쉬운 말로 설명]

**가치**: [유저 가치와 이 우선순위가 적절한 이유를 설명]

**테스트**: [이 스토리를 독립적으로 테스트하는 방법을 설명]

**인수 시나리오**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [짧은 제목] (우선순위: P2)

[이 유저 여정을 쉬운 말로 설명]

**가치**: [유저 가치와 이 우선순위가 적절한 이유를 설명]

**테스트**: [이 스토리를 독립적으로 테스트하는 방법을 설명]

**인수 시나리오**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### 엣지 케이스

- [경계 조건]일 때 어떤 일이 발생하는가?
- 시스템은 [오류 상황]을 어떻게 처리하는가?

## 요구사항

### 기능 요구사항

- **FR-001**: 시스템은 [구체적으로 외부에서 관찰 가능한 기능]을 제공해야 한다
- **FR-002**: 시스템은 [구체적으로 외부에서 관찰 가능한 기능]을 제공해야 한다
- **FR-003**: 사용자는 [핵심 상호작용]을 할 수 있어야 한다
- **FR-004**: 시스템은 [관찰 가능한 데이터 또는 상태 요구사항]을 충족해야 한다
- **FR-005**: 시스템은 [구체적으로 외부에서 관찰 가능한 동작]을 수행해야 한다
- **FR-006**: 시스템은 [NEEDS CLARIFICATION: 미해결 제품 동작]을 처리해야 한다

### 성공 기준

- **SC-001**: [측정 가능한 결과 또는 완료 기준]
- **SC-002**: [측정 가능한 결과 또는 완료 기준]

## 가정

- [대상 유저에 대한 가정]
- [범위 경계에 대한 가정]
- [데이터 또는 환경에 대한 가정]
- [기존 시스템 또는 서비스에 대한 의존성, 구현 설계 없이 설명]

## 범위에서 제외

- [명시적으로 제외되는 동작, 워크플로, 또는 유저 그룹]
- [계획 단계로 의도적으로 미룬 구현 세부사항]
```
