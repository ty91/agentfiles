# 04. Contract and System Tests

Use wide tests only for risks that a narrower surface cannot prove.

## 1. Test contracts across independent components

Use a contract test when producer and consumer can be built, versioned, or deployed independently.

- Keep one authoritative machine-readable contract or provider-verified artifact.
- Use a runtime schema, OpenAPI document, event schema, generated client, consumer-driven contract, or verified provider response.
- Verify both obligations:
  1. The producer emits values accepted by the contract.
  2. The consumer interprets every required value correctly.
- Cover success and error shapes, status meanings, enum values, optional fields, and version behavior.
- Generate, validate, or exercise contract fixtures through the authority.
- Do not treat hand-written JSON as evidence of provider compatibility.
- Update the authority and both checks in the same contract change.
- Follow the compatibility policy for additive, versioned, or coordinated changes.

## 2. Keep user journeys few and critical

- Use the actual browser, network, authentication, API, database, proxy, and deployment path required by the obligation.
- Test workflows whose failure blocks important user or business activity:
  - login and authenticated navigation;
  - primary create, update, and retrieval;
  - refresh and deep links;
  - cookies, proxy, and origin behavior;
  - browser focus and navigation;
  - post-deploy smoke paths.
- Give each journey one business outcome.
- Use realistic data and leave a known final state.
- Keep validation matrices and domain branches in decision, storage, or module tests.

## 3. Reproduce operational properties

- **Concurrency**: production database engine, independent connections, intended isolation, controlled overlap.
- **Performance and load**: workload, data volume, concurrency, latency or throughput target, resource limits.
- **Resilience**: injected failure, timeout, retry policy, recovery behavior, final durable state.
- **Security**: attacker capability, protected asset, trust boundary, denied outcome.
- **Recovery and deployment**: starting state, operation, interruption point, observable result.

Do not overclaim:

- Concurrent promises do not prove concurrent storage unless database work overlaps on independent connections.
- An embedded database does not prove pool behavior.
- A local process does not prove proxy, TLS, container, or deployment behavior.

## 4. Declare environment and evidence limits

Make these facts discoverable in the test setup, name, or suite documentation:

1. Obligation and failure cost
2. Components and versions
3. Real and substituted dependencies
4. Relevant concurrency, timeout, isolation, data volume, and browser conditions
5. Properties the test does not prove
6. Owner who receives failures

Claim only properties the environment reproduces. Use both contract artifacts for API compatibility, a real browser for browser behavior, and real PostgreSQL connections for PostgreSQL locks.

## 5. Choose the execution stage

| Test class | Default stage |
| --- | --- |
| Decision | Local and every pull request |
| Storage, adapter, module | Local and every pull request |
| Provider-consumer contract | Every pull request for either side |
| Critical browser journey | Pull request when fast and stable, otherwise main |
| Production database concurrency | Relevant pull requests and main |
| Load, resilience, extended security | Scheduled run or release gate |
| Deployment smoke and rollback | Deployment pipeline |

- Run a test earlier when failure frequency or cost justifies its feedback time.
- Move a slow test later only when a faster test covers the immediate risk and the later stage has a failure owner.

## 6. Keep failures actionable

- Keep each wide test focused on one compatibility, journey, or operational risk.
- Do not use a journey as a validation matrix.
- Do not make concurrency tests verify full response contracts.
- Do not make load tests own functional edge cases.
- Place a discovered defect at the smallest surface that reproduces it faithfully.
- Keep the wide test only when it catches a distinct assembly, compatibility, or runtime failure.
