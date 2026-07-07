---
name: codebase-standards
description: Team codebase standards encoding our engineering judgment. MUST be used whenever writing, changing, or reviewing code. Before designing, implementing, refactoring, or reviewing any change, open this map and read the documents matching the work at hand.
---

# Codebase Standards

Find the triggers below that match the work at hand and read those documents; skip the rest. Paths are relative to this directory.

## Always

- `shared/duplication-and-promotion.md`: you are about to copy code, write a helper, extract something shared, or create a second module that resembles an existing one.
- `shared/domain-language.md`: naming a new domain concept; a term conflicts with `CONTEXT.md`; introducing domain vocabulary into code, schema, or an API contract.

## Backend

- `backend/01-module-composition.md`: creating or restructuring a module, deciding where code lives, adding layers, wiring and assembly.
- `backend/02-data-modeling.md`: designing tables, columns, constraints, or status fields; storing a derived or cached value.
- `backend/03-data-access.md`: writing queries; lists, pagination, projections; needing another module's data.
- `backend/04-api-contracts.md`: adding or changing endpoints; request validation; response and error shapes; authorization.
- `backend/05-write-patterns.md`: writes, transactions, concurrent updates, client retries.
- `backend/06-background-work.md`: jobs, queues, schedulers, anything that runs after the response.
- `backend/07-external-calls.md`: calling a third-party API or another service; timeouts, retries, adapters.
- `backend/08-error-handling.md`: try/catch, failure types, propagating and translating errors.
- `backend/09-observability.md`: logging, log levels, request correlation.

## Frontend

- `frontend/01-component-composition.md`: creating or restructuring components, deciding component boundaries; whether a component may import the domain; a container/presentational split; promoting a component into the design system; deciding where a component's files live.
- `frontend/02-data-ownership.md`: deciding which component or layer owns a piece of data.
- `frontend/03-state-management.md`: adding state, reaching for useEffect, deriving or copying values.
- `frontend/04-form-patterns.md`: building or changing forms and their validation.
- `frontend/05-mutation-patterns.md`: submitting changes to the server; cache updates and invalidation.
- `frontend/06-animation-conventions.md`: adding animation or transitions.
- `frontend/07-code-splitting.md`: lazy loading, bundle boundaries, barrel imports.
- `frontend/08-virtualized-lists.md`: rendering long or unbounded lists.
- `frontend/09-state-provisioning.md`: a prop passing through components that don't read it; reaching for context, a scoped store, or global state; deciding how a value reaches its readers.
- `frontend/10-visual-design.md`: choosing color, spacing, typography, radius, or elevation; any raw design value in a diff; new UI that must match the design system.
- `frontend/11-accessibility.md`: any new screen or interactive element; keyboard, focus, and screen-reader behavior; loading, empty, and error states; responsive layout.

## Testing

- `testing/01-test-strategy.md`: deciding whether a change needs new tests at all; what deserves a test and at which surface; adding, keeping, or deleting tests; TDD; regression tests.
- `testing/02-writing-tests.md`: writing or changing test code; test names, test data, assertions.
- `testing/03-test-doubles.md`: reaching for a mock, stub, fake, or in-memory substitute; testing code that touches a database, another service, a third party, time, or randomness.
