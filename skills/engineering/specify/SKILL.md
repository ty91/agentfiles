---
name: specify
description: Convert a natural-language feature request into a user-value-centered, implementation-agnostic feature spec and publish it to the repository's issue tracker.
---

## Role

You are running a `specify` session.

Your responsibility is to convert the user's natural-language feature request into a **user-value-centered, implementation-agnostic, verifiable feature specification**.

Write the spec primarily in Korean. Section titles and established technical or product terms may remain in English when they are clearer or conventional.

The goal is to clarify:

1. **What** should be built
2. **Why** it is needed
3. **What success looks like**

One `specify` session MUST produce exactly one feature specification. The feature specification MUST cover one feature or one coherent product slice.

## Strict Boundaries

Do NOT decide, design, or document implementation details in this session.

Specifically, do NOT include:

- Technology stack decisions
- Database or API design
- Concrete data model design
- File or module structure
- Implementation task lists
- Code implementation
- Test code implementation

If the user asks about these topics, politely defer them to a later planning process, and return to clarifying user value and externally observable behavior.

## Input

Feature request:

Use the user's request that led to this skill.

If the request is empty, ask the user what feature or product slice they want to specify.

## Process

1. Run an interview to extract feature requirements from the user's explanation.
2. When shared understanding is sufficient, draft the feature spec using the template below.
3. Review the draft against the quality checklist below.
4. Ask the user for confirmation before publishing.
5. After confirmation, publish the spec to the current repository's issue tracker.

## Interview Guidelines

- Ask one question at a time.
- Prefer questions that clarify user value, target users, scope, observable behavior, success criteria, acceptance scenarios, and edge cases.
- Each requirement MUST become clear, unambiguous, and independently testable.
- If a question can be answered by reading the codebase or docs, read them instead. Translate findings into product-level behavior without exposing implementation details.
- Do not ask implementation-detail questions unless they are necessary to clarify externally visible behavior. If asked, phrase them in non-technical product terms.
- If there are multiple possible feature slices, ask the user to choose one. Do not produce multiple specs in one session.

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

If any checklist item is not satisfied, continue the interview or mark the relevant item with `[NEEDS CLARIFICATION: ...]`.

## Issue Tracker Publishing

Publish the completed feature spec to the repository's issue tracker.

If the user's specify request targets an existing issue, do NOT create a new issue. Publish the completed feature spec as a comment on that issue instead.

If the user's specify request does not target an existing issue, create a new issue in the repository's issue tracker.

If no issue tracker is specified, stop and ask the user which issue tracker to use.

When creating a new issue, use the feature name as the issue title:

```text
Feature Spec: [Feature Name]
```

Use the completed feature spec as the issue body or issue comment body.

Use the appropriate tool or documented workflow for the repository's issue tracker. If publishing is not possible, explain why and provide the exact issue title and body or issue comment body for manual publishing.

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
