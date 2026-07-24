# Backend Tests

The standard form, the DB rules, and the only accepted justifications for testing below the HTTP seam.

## Standard form

Assemble the real app in-process, drive it over HTTP, use a real database engine, stub only true externals at the network boundary. Assert on the response **and** on persisted state — persisted state is an outward-facing result, not a side channel, when the write is the behavior under test.

```ts
test("applying a valid coupon discounts the order and persists it", async () => {
  await seedCoupon(db, { code: "WELCOME10", rate: 0.1 });
  paymentGateway.willApprove(); // third-party stubbed at the network boundary — the ONLY stub

  const res = await app.inject({
    method: "POST",
    url: "/api/v1/orders",
    headers: authenticatedHeaders(),
    payload: { items: [{ sku: "A-1", qty: 2, price: 10_000 }], coupon: "WELCOME10" },
  });

  expect(res.statusCode).toBe(201);
  expect(res.json().total).toBe(18_000);
  const saved = await db.query.orders.findFirst();
  expect(saved?.total).toBe(18_000);
});
```

One representative path per flow, plus failure cases that differ in user-observable outcome (expired coupon → 400 + unchanged total; gateway declined → order not persisted). Branch exhaustion belongs in unit tests of extracted pure functions, not here.

Seed through real domain modules (recorders, services) rather than raw row inserts when the domain owns the invariants — the seed path then exercises real behavior for free.

## Database rules

- **Real engine, cheap**: in-process engine (e.g. PGlite) or container (Testcontainers) with per-test truncation or transaction rollback. In-process engines may lack production extensions — if the gap is risky for this repo, use the container.
- **Build the test DB by running the migration chain** (`migrate`), never by schema-sync (`push`). Then every integration test implicitly verifies: migrations apply cleanly AND the resulting schema supports the app's real queries. A field missing from a migration fails the first insert/select that needs it.
- **Never assert on migration SQL text** ("the SQL must contain field X"). That is a mirror of the schema — a change detector that tests the generator, which is third-party-verified. The real risks (applies cleanly, app runs on the result) are covered by the rule above.
- **Data-transforming migrations** (backfill, column split) get one targeted test: seed old-shape rows → run the migration → assert transformed rows. Only for that migration.
- **Destructive-change detection** (DROP, data loss) is CI policy / review work, not a test.

## Below the HTTP seam: the only accepted justifications

A test file under the outer seam must state which of these it claims:

1. **Complex-query exception.** The query itself is branch-heavy logic (dynamic filters, pagination + aggregation, upsert conflict handling, locking) and SQL cannot be extracted into a pure function. Test the repository directly — but still against the real DB, never a mock. Do not re-test what the HTTP tests already cover (plain search, plain pagination).
2. **Pure-function extraction.** Combinatorial domain logic (pricing, assembly, sorting tie-breakers) extracted into a pure module. Exhaustive unit tests on data in / data out. No I/O, no stubs needed by construction.
3. **Load-bearing invariant / diagnostic value** — per [principles.md](principles.md).

Everything else — service wiring, route mapping, error-shape mapping, input pass-through — is covered by the HTTP tests with marginal confidence zero. Do not write it.

## Anti-patterns (delete on sight)

```ts
// BAD: mockist layer test — stubs an internal collaborator, asserts on the interaction
const calls: unknown[] = [];
const reader = {
  async search(tenantId, criteria) { calls.push({ tenantId, ...criteria }); return empty; },
  async find() { throw new Error("must not be called"); }, // call-order pinning
};
const service = createService({ reader });
await service.search(17, { search: "  beef  " });
expect(calls).toEqual([{ tenantId: 17, search: "beef" }]); // interaction, not behavior
```

Why it's wrong: the assertion observes an internal call, so it breaks on any internal refactor and verifies nothing a consumer can see. The behavior it wants ("search input is trimmed") is testable for real at the HTTP seam (`?search=%20beef%20` matches) or, if the normalization has many branches, as a pure function.

```ts
// BAD: route test with a stubbed service, re-asserting response shapes the HTTP tests already assert
// BAD: expect(generatedMigrationSql).toContain("coupon_code")   — schema mirror
// BAD: expect(mockRepo.save).toHaveBeenCalledWith(order)        — interaction; assert persisted state instead
```

## Escape hatch

This strategy assumes the DB tax is cheap. If the suite grows slow despite rollback/parallel schemas, that is the signal to introduce the classical seam — repository interface + in-memory fake + contract tests run against both implementations — not to abandon real-DB verification. The junction must still be tested for real somewhere.
