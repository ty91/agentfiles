# 02. Writing Tests

Make one obligation obvious in the name, data, actions, and assertions.

## 1. Name the obligation

- Write a requirement sentence.
- Name behavior, not mechanism.
  - Requirement: `rejects checkout of an empty cart`
  - Mechanism: `calls validateCart`
- Give each test one primary reason to fail.
- Keep multiple assertions only when they describe one outcome.
- Split independent obligations. Treat unrelated promises joined by "and" as a warning.

## 2. Assert only the obligation

- Assert only facts the obligation decides.
- Do not deep-equal an entire response for one behavior.
- Verify full shapes in schemas or contract tests.
- Use negative assertions only for standing obligations, such as secrets never leaving a boundary.

## 3. Show only relevant data

- Let builders and factories own ordinary valid defaults.
- Override only values that can change the answer.
- Extract a builder only when valid setup repeats.
- Let helpers hide incidental setup, never values or actions that explain the obligation.
- Do not use positional records when fields are unclear.
- Do not build one conditional fixture for every feature.
- Treat setup longer than the assertion as a signal that data may hide the obligation.

## 4. Keep expected values independent

- Do not calculate expectations with production formulas, parsers, or helpers.
- Use a concrete, human-verifiable value for representative behavior.
- Use a table for equivalence classes and named boundaries.
- Use a property when many values share an invariant, such as `decode(encode(value)) === value`.
- Add concrete cases when a property has business-significant boundaries.
- Generalize a bug into a table or property when it reveals an input class.

## 5. Assert outcomes, not conversations

- Observe a returned value, stored fact, emitted contract, rendered state, or declared environmental call.
- Do not assert calls between hidden collaborators.
- Treat a call as an outcome only when it is the declared interface with the environment, such as `onSend` or a payment port.
- Follow `03-test-doubles.md` for substitution and call assertions.

## 6. Treat length as a review signal

For a long test, ask:

1. Does it contain multiple obligations?
2. Can incidental setup move into a focused builder?
3. Is the length inherent to one contract, journey, or operational scenario?

- Split independent obligations.
- Keep one workflow intact when splitting would hide causality.
- Do not split tests merely because the body or file is long.

## 7. Drive UI through user behavior

- Query by role, accessible name, label, and visible result.
- Use `userEvent` for typing, clicking, tabbing, and selecting.
- Use `fireEvent` only for a low-level event that user interaction does not produce.
- Use component tests for semantic DOM and application state.
- Use the real browser for layout, browser focus, navigation, and platform behavior. See `04-contract-and-system-tests.md`.
