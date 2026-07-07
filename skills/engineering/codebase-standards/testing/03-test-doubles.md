# 03. Test Doubles

A double is a claim that a boundary exists. Doubling something you own tests a system that does not exist: the double encodes a guess about the real thing's behavior, the guess drifts from the real thing one change at a time, and the suite keeps passing against the guess. Everything you own runs real; substitution happens only at boundaries you do not control, and each kind of boundary has one sanctioned substitute.

## 1. Never double what you own

No mocked repositories, no fake services, no hand-rolled call recorders standing in for your own modules. A test that mocks the layer below can only assert delegation — that A called B with the right arguments — which proves wiring, not behavior. Stack that pattern and the same behavior is asserted as plumbing at every layer and exercised for real at none: the service is tested against a guessed repository, the repository against guessed rows, and the actual query that orders, filters, and scopes is run by no test at all. The suite is large, green, and blind to the most likely bug.

```ts
// Bad: the repository is ours; the mock asserts delegation against a guess
const repository = { listDeliveries: vi.fn().mockResolvedValue(rows) };
const service = createDeliveriesService({ repository });
await service.listDeliveries(principal, query);
expect(repository.listDeliveries).toHaveBeenCalledWith({ tenantId: "t-1" });

// Good: real service, real repository, real query on a local database substitute
const app = buildTestApp(); // real modules, database on the local substitute
await seed(app.db, [delivery({ area: "east" }), delivery({ area: null })]);
const response = await app.inject({ method: "GET", url: "/deliveries?date=2026-06-24" });
expect(response.json().sections.map((s) => s.area)).toEqual(["east", "unassigned"]);
```

## 2. Substitute by kind of boundary

The kind of dependency decides the substitute; the decision is made once here, not per test.

| Dependency | In tests |
| --- | --- |
| Pure in-process logic | Nothing. Run it real. |
| Infrastructure with a local stand-in (database, filesystem) | The stand-in runs inside the suite (an embedded Postgres, a temp directory). Storage semantics are tested for real. |
| Our own service across a network | A port at the seam; tests use an in-memory adapter, production uses the transport adapter. |
| A true third party (payments, push, email) | A mock at the adapter, in the domain's vocabulary. Vendor shapes appear only in the adapter's own tests (see backend/07-external-calls). |
| Time and randomness | Injected, always: `now: () => …`, seeded generators. Never read the ambient clock in tested code. |

One consequence worth naming: "the database is hard to test against" is not a reason to mock the repository — it is the reason the local stand-in exists. If no stand-in is available for a piece of infrastructure, treat it as a third party: put an adapter in front of it and mock the adapter.

## 3. Assert outcomes, not conversations

`toHaveBeenCalledWith` on an internal collaborator pins the conversation between two pieces of code you own — a conversation every refactor is entitled to change. Assert what a caller can observe through the interface: the returned value, the stored fact, the rendered screen.

The exception is a declared port. When the module's contract with its environment *is* the call — a component's `onSend` prop, an adapter invoked at a true external boundary — then the call on the injected port is the module's observable output, and asserting it is asserting an outcome.

```tsx
// Bad: a conversation between two modules we own
expect(repository.getDelivery).toHaveBeenCalledWith({ deliveryId: "d-1" });

// Good: the injected port is this component's declared output
render(<Composer onSend={onSend} />);
await user.click(screen.getByRole("button", { name: "Send" }));
expect(onSend).toHaveBeenCalledWith("hello");
```

The discriminator: is the callee part of the module's declared interface with its environment, or a collaborator hidden behind it? If deleting the assertion changes nothing a caller could notice, it was a conversation.

## 4. Boundaries are built to be substituted

A boundary that cannot be substituted breeds the doubles rule 1 forbids, so the design rules land on the production code. Dependencies arrive as arguments; a module that constructs its own client has welded the boundary shut (see backend/01-module-composition on assembly). And ports expose one function per operation rather than a generic fetcher, so a test double returns one shape instead of growing conditional logic that itself needs testing.

```ts
// Bad: the boundary is welded shut, and the only lever left is monkey-patching
function processPayment(order: Order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}

// Good: the dependency arrives, one operation per function, one shape per double
function processPayment(order: Order, payments: PaymentsPort) {
  return payments.charge(order.total);
}
```
