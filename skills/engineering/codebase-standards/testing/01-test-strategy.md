# 01. Test Strategy

Test obligations, not files. Use the smallest sufficient surface. Give each obligation one primary owner.

## 1. Define the obligation

1. Write one requirement sentence for a caller, component, operator, or the business.
2. Name behavior, not implementation.
   - Obligation: "Every emitted cursor decodes to the same item position."
   - Implementation: "The cursor codec calls `Buffer.from`."
3. Add a test only when a concrete defect can escape every other check.
4. Do not test something merely because a constant, type, configuration, hook, file, or function exists.

## 2. Use the cheapest sufficient verification

Stop at the first mechanism that fully proves the obligation:

1. Type system or compiler
2. Linter or static rule
3. Runtime schema at the trust boundary
4. Database constraint for every writer
5. Existing test
6. New test

- Do not copy types, schemas, constraints, or implementations into assertions.
- Keep distinct obligations separate. A constraint may own uniqueness while a module test owns the public conflict response.

## 3. Choose the smallest sufficient surface

| Obligation | Use for | Surface |
| --- | --- | --- |
| Decision rule | Calculation, parsing, normalization, state transition, codec | Pure function or small domain interface |
| Storage or adapter | SQL, constraints, transactions, serialization, filesystem, vendor translation | Repository or adapter with a matching dependency or substitute |
| Module behavior | Assembly, authorization, orchestration, error translation, visible component behavior | Public route, handler, job entry point, or component tree with real internals |
| Component contract | Independently built or deployed producers and consumers | Contract from one authoritative schema or verified artifact |
| User journey | Critical workflow requiring the real runtime path | Real application path through the required components |
| Operational quality | Concurrency, performance, resilience, security, recovery, deployment | Environment that reproduces the property |

- Explore decision rules directly and cheaply.
- Test representative success and each externally distinct failure at the module surface.
- Use contract, journey, and operational tests only when narrower surfaces cannot prove the obligation. See `04-contract-and-system-tests.md`.
- Incidental coverage does not own edge cases. Prefer the surface with the least unrelated setup and clearest failure.

## 4. Give each obligation one primary owner

- Two tests are duplicates when the same defect makes both fail for the same reason.
- Keep the smaller sufficient test or the one with stronger production fidelity.
- When a new test becomes the better owner, delete the old owner in the same change.
- Allow overlap only for a distinct failure mode or justified defense of security, money, tenant isolation, or data loss.
- Treat provider production, consumer interpretation, and deployed delivery as separate obligations when they can fail independently.
- For every overlap, name the defect it catches that the primary owner cannot.

## 5. Classify the change

- **New or changed behavior**: test each obligation at its primary surface.
- **Behavior-preserving change**: add no test unless it reveals an unowned obligation.
- **Bug or discovered risk**: express the standing obligation. Use boundaries, a table, or a property when one example reveals an input class.
- **Contract change**: verify provider production and consumer interpretation.
- **Contract removal or narrowing**: describe the standing contract. Assert absence only for a durable security, privacy, or compatibility obligation.
- **Operational change**: reproduce the property, such as multiple database connections for concurrency or a real browser for focus.

Work one obligation at a time: fail its test, implement the minimum behavior, pass it, remove test scaffolding, continue. RED indicates an unmet obligation; it is not a goal.

## 6. Review the test list first

Record each proposed test before implementation:

1. Obligation
2. Classification from rule 3
3. Failure cost
4. Surface
5. Why existing verification is insufficient
6. Unique defect it catches

- No test without an obligation.
- No accepted obligation without verification.
- Test count is not coverage.

## 7. Finish the test change

Before handing off:

- Remove scaffolding that only proves the change was applied.
- Delete lower-value duplicates.
- Keep edge-case tables at the decision surface.
- Use a real environment for properties substitutes cannot reproduce.
- For every test, name the unique defect that passes without it.
