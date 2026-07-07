# 02. Writing Tests

A test is read at two moments: in review, when a human decides whether the promise is right, and at failure, when someone must see which rule broke. Both readers need the same thing: the rule, visible. The name states the requirement, the body shows only the values the rule turns on, and the assertion states the rule's answer, not the world's.

## 1. The name is a requirement sentence

A test name reads like a line from the spec, so the test list (see 01-test-strategy) can be reviewed without reading the bodies. Names that describe mechanism instead of requirement are violations — they survive only as long as the mechanism does.

```ts
// Bad: the name describes the mechanism
it("calls validateCart");
it("sets status to confirmed");

// Good: the name states a requirement
it("rejects checkout of an empty cart");
it("confirms the order when payment succeeds");
```

A test has one reason to fail. Several assertions are fine when they describe one observable behavior; split the test when the assertions cover separate rules, because a shared body hides which rule broke.

## 2. Assert the rule, not the world

A deep-equal of the whole response pins every field the module returns, so every test breaks whenever any field changes, and the rule under test drowns in fields it never touches. Assert exactly the facts the rule decides; the rest of the response is other rules' business.

```ts
// Bad: one rule (grouping and order), ninety lines of world
expect(result.value).toEqual({
  sections: [
    { area: "east", deliveries: [/* every field of every delivery */] },
    { area: "unassigned", deliveries: [/* … */] },
  ],
});

// Good: the assertion states the rule
expect(result.value.sections.map((s) => s.area)).toEqual(["east", "unassigned"]);
expect(result.value.sections[0].deliveries.map((d) => d.id)).toEqual(["d-1", "d-3", "d-2"]);
```

The full shape of a contract is pinned once, by the schema that validates it at the boundary (see backend/04-api-contracts) — not re-pinned by every behavior test.

## 3. The data shows only what the rule turns on

Test data is an argument for the rule, and irrelevant values are noise in that argument. Builders and factories own the defaults; the test body sets only the values the rule reads. Positional tuples are forbidden in test data — a reviewer cannot tell which of twenty-eight columns the rule is about.

```ts
// Bad: which of these values does the sorting rule read?
seedRow(["d-1", "o-1", "pending", "2026-06-23", null, "c-1", "East Butcher", 2, 12500, null]);

// Good: the builder hides the defaults; the visible values are the rule's inputs
const delivery = aDelivery().inArea("east").receivedAt("2026-06-23T01:30:00Z");
```

The smell test: when the fixture is longer than the assertion, the data is hiding the rule instead of stating it.

## 4. Expected values are concrete examples

An assertion that recomputes the expected value replays the implementation, and a test that replays the implementation agrees with every bug in it. Fix a concrete example that a human can verify by hand, chosen at the values where the rule changes.

```ts
// Bad: the assertion mirrors the implementation
expect(total).toBe(price * quantity * (1 - discountRate));

// Good: a concrete example pins the rule
expect(calculateTotal({ price: 1000, quantity: 3, discountRate: 0.1 })).toBe(2700);
```

## 5. A test that outgrows the page is testing the wrong thing

Size is a symptom, and the fix is never "a bigger test." A body past roughly twenty lines means the data has not been factored into builders (rule 3) or the assertion is describing the world (rule 2). A hand-rolled fake spanning hundreds of lines means the test surface is wrong (see 01-test-strategy) or a real substitute is missing (see 03-test-doubles). A test file rivaling its implementation in length means the suite is restating the code, one mirrored branch at a time.

Test code is refactored like any code — after green, never while RED. Extract builders when setup repeats, rename tests until they read as requirements, and delete a test whenever a stronger neighbor fails for the same reason.
