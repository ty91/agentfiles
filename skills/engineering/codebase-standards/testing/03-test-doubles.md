# 03. Test Doubles and Fidelity

Substitute only declared boundaries. Run owned code for real inside the selected surface. Claim only properties the test environment reproduces.

## 1. Run owned code for real

- Decision tests run the real calculation.
- Storage tests run the real query.
- Module tests assemble real decisions and data code.
- Do not mock repositories, fake services, or record calls to test hidden wiring.
- Prove assembly through observable behavior and boot failure for missing dependencies.
- Assert returned values, stored facts, rendered states, emitted contracts, or declared environmental calls.
- Assert a call only when it is the declared output to the environment, such as `onSend` or an email port.
- Treat a call as internal when changing it affects no caller, consumer, operator, or stored fact.

## 2. Substitute declared boundaries

Use a substitute when the dependency is outside the selected surface and the test needs control, speed, or isolation:

- true third party;
- separately deployed service;
- time, randomness, or process environment;
- slow or unavailable resource outside the obligation;
- timeout, retryable failure, partial response, or rare condition;
- browser or database behavior the substitute faithfully supports.

- Expose the boundary as an explicit dependency or port.
- Express the port in domain vocabulary.
- Keep vendor shapes, generic fetch conditions, and hidden collaborator methods out of domain tests.

## 3. Match the environment to the property

Use the lightest environment that reproduces the property. Respect its evidence limit.

| Property | Environment | Does not prove |
| --- | --- | --- |
| Pure logic | Real code | Unselected inputs or properties |
| SQL, schema, constraints, basic transactions | Local database substitute with real migrations and queries | Production driver, network, pool, multiple connections |
| Locks, isolation, deadlocks, concurrent writers | Production database engine with independent connections | Unconfigured engines or isolation conditions |
| Filesystem | Real calls in a temporary directory | Deployment permissions or remote storage |
| Owned network service | Domain port plus provider-consumer contract | Port alone does not prove transport compatibility |
| Third party | Domain adapter double plus contract or sandbox test | Current vendor behavior from the double alone |
| Time and randomness | Injected clock and seeded generator | Unselected times or seeds |
| React behavior | jsdom with the real component tree | Layout, browser focus, navigation, cookies |
| Browser behavior | Real browser | Unselected browsers or deployment paths |

- `Promise.all` over one embedded database connection does not prove multi-connection concurrency.
- A hand-written fetch response does not prove deployed API compatibility.

## 4. Inject faults at a declared port

- Treat an environmental failure as an input to the caller.
- Inject it at the narrowest declared boundary that can express it.
- Use ports for timeouts, queue rejection, retryable responses, partial responses, and controlled storage failures.
- Assert preserved data, bounded retry, typed failure, rollback, or visible recovery.
- Use the real dependency when the obligation depends on its failure semantics. A port can prove conflict handling; the database must prove the conflict occurs under the intended constraint and isolation.

## 5. Keep doubles small

- Expose one function per operation and one domain result shape.
- Prefer a focused stub, small in-memory adapter, or provider-verified fixture.
- Do not build a general fake with route, query, call-order, or mutable-state branches.
- Reset shared substitutes between tests.
- Never depend on another test's call history or mutations.

## 6. Build substitutable boundaries

- Inject dependencies through construction or function arguments.
- Let the assembly root supply production adapters and tests supply controlled ports.
- Do not construct vendor clients, clocks, random generators, or transports inside decisions.
- Create a port only for an environmental boundary or real alternate behavior.
- Keep a single internal implementation direct. Do not add an interface only for testing.
