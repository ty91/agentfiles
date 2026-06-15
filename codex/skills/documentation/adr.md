# ADR Guidance

## Purpose

Use ADRs to preserve decisions that future engineers or agents would otherwise re-litigate. The value is in recording that a decision was made and why, not in filling out a heavy template.

Prefer short ADRs. A single paragraph is acceptable when it captures the context, the decision, and the reason.

## Location And Naming

Store ADRs in `docs/adr/`.

Use sequential numbering:

```text
docs/adr/
├── 0001-use-postgres-for-write-model.md
├── 0002-keep-billing-context-separate.md
└── 0003-reject-runtime-theming.md
```

When creating a new ADR:

1. Scan `docs/adr/` for the highest existing number.
2. Increment it by one.
3. Use a short, descriptive kebab-case slug.
4. Create `docs/adr/` lazily if it does not exist.

For context-scoped decisions in a multi-context repo, follow the repo's existing convention. If it already uses paths like `src/<context>/docs/adr/`, place the ADR in the relevant context instead of the root.

## When To Create An ADR

Offer or create an ADR only when all three are true:

1. **Hard to reverse**: changing the decision later would be meaningfully expensive.
2. **Surprising without context**: a future reader might wonder why this path was chosen.
3. **Real trade-off**: there were plausible alternatives and one was intentionally rejected.

Good ADR subjects:

- Architectural shape: monorepo, service split, event sourcing, modular boundary.
- Ownership and context boundaries: which module/context owns a concept or data.
- Integration pattern: domain events vs synchronous HTTP, polling vs webhooks.
- Technology choices with lock-in: database, message bus, auth provider, deployment platform.
- Non-obvious deviation: manual SQL instead of ORM, no GraphQL, no runtime plugins.
- Durable constraints: compliance, latency, hosting, operational, or business constraints.
- Rejected alternatives likely to be suggested again.

Skip ADRs for easy-to-reverse choices, obvious implementation details, temporary scheduling reasons, or decisions with no meaningful alternative.

## Template

Use this minimal template by default:

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

Example:

```md
# 쓰기 모델에 Postgres를 사용한다

주문 변경은 관계형 제약과 트랜잭션 일관성이 필요하므로 쓰기 모델에는 Postgres를 사용한다.
SQLite도 검토했지만, 동시 창고 작업을 안전하게 처리하기에는 운영 보장이 부족해서 채택하지 않는다.
```

## Optional Sections

Add sections only when they clarify a real future question. Most ADRs should not need all of these.

```md
---
status: accepted
---

# 주문과 정산은 도메인 이벤트로 연동한다

주문 생성 지연 시간이 청구서 생성에 의존하지 않도록 주문과 정산은 동기 HTTP가 아니라 도메인 이벤트로 연동한다.
정산 장애가 주문 접수를 막으면 안 되기 때문에 동기 HTTP 연동은 채택하지 않는다.

## 검토한 대안

- 도메인 이벤트
- 동기 HTTP
- 공유 데이터베이스 테이블

## 결과

- 정산은 주문과 최종적 일관성을 가진다.
- 이벤트 consumer는 멱등하게 구현해야 한다.
```

Supported status values when status is useful:

- `proposed`
- `accepted`
- `deprecated`
- `superseded by ADR-NNNN`

## Updating ADRs

Do not delete old ADRs just because the decision changed. Historical context remains useful.

When a decision changes:

1. Write a new ADR with the new decision.
2. Mark or mention the old ADR as superseded if the repo uses status metadata.
3. Link the old and new ADRs by number.

When an ADR only needs clarification, edit it in place if the decision itself is unchanged.

## Style

- Write in plain Korean.
- Explain the why, not the code mechanics.
- Name rejected alternatives when they are likely to recur.
- Keep titles decision-shaped: `Y에 X를 사용한다`, `X와 Y를 분리한다`, `Y 때문에 X를 채택하지 않는다`.
- Avoid vague reasons like "simpler" unless you state what complexity is avoided.
