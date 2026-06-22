# Good and Bad Tests

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- Has one reason to fail

## Test Selection Principles

Write the next test as a small requirement, not as a mechanical line of coverage.

**Name tests like behavior specs**:

```typescript
test("checkout rejects an empty cart", async () => {});
test("checkout confirms the order when payment succeeds", async () => {});
```

Avoid names that describe implementation:

```typescript
test("calls validateCart", async () => {});
test("sets status", async () => {});
```

**Prefer one reason to fail over one assertion.** Multiple assertions are fine when they describe one observable behavior. Split the test when assertions cover separate rules.

```typescript
// GOOD: one behavior, multiple observable results
test("checkout confirms a paid order", async () => {
  const result = await checkout(validCart, validPayment);

  expect(result.status).toBe("confirmed");
  expect(result.orderId).toBeDefined();
  expect(result.total).toBe(3000);
});

// BAD: three independent rules in one test
test("checkout behavior", async () => {
  expect(await checkout(validCart, validPayment)).toMatchObject({ status: "confirmed" });
  await expect(checkout(emptyCart, validPayment)).rejects.toThrow("empty cart");
  await expect(checkout(validCart, expiredPayment)).rejects.toThrow("payment expired");
});
```

**Start with the simplest meaningful failing case.** The first test should prove the path through the public interface, not cover every variation. Add tests one at a time as each rule becomes real.

Good order:

1. Valid cart can checkout
2. Empty cart is rejected
3. Payment failure leaves the order unconfirmed
4. Boundary case where the business rule changes

**Cover boundaries and failure paths where rules change.** Do not enumerate every possible value. Pick values that prove the rule.

Examples:

- Inventory 10, order 10 succeeds
- Inventory 10, order 11 fails
- Expired token is rejected
- Already-cancelled order stays cancelled

## Test Data

Test data should make the behavior obvious. Show values that matter to the rule; hide irrelevant defaults behind factories or builders.

```typescript
// BAD: irrelevant data obscures the rule
const cart = createCart("user-1", "KRW", true, null, "standard", [
  { sku: "pork-belly", quantity: 2, price: 1500 },
]);

// GOOD: only relevant values are visible
const cart = aCart().withItem("pork-belly", { quantity: 2, price: 1500 });
```

Avoid fixtures so large that the test passes only because nobody can see what matters. Prefer small inline examples for simple rules and named factories/builders for repeated setup.

## Expected Values

Do not duplicate the implementation logic in the assertion. Use concrete examples that pin the rule.

```typescript
// BAD: mirrors the implementation
expect(total).toBe(price * quantity * (1 - discountRate));

// GOOD: fixes an example outcome
expect(calculateTotal({ price: 1000, quantity: 3, discountRate: 0.1 })).toBe(2700);
```

If expected values require complex setup, introduce named intermediate facts in the test so the requirement remains readable.

## Test Level

Choose the lowest test level that proves the behavior without coupling to internals:

- Domain rule: fast unit test through the public domain API
- Module contract or persistence behavior: integration test through the module interface
- Critical user workflow: small number of end-to-end tests

Avoid using end-to-end tests to cover simple branches. Avoid using isolated unit tests when the risk is integration or wiring.

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```typescript
// BAD: Tests implementation details
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Red flags:

- Mocking internal collaborators
- Testing private methods
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```
