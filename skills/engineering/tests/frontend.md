# Frontend Tests

Unit and integration layers for UI code. Known accepted limitation: DOM-environment tests (jsdom/happy-dom) have no layout engine, so "present in DOM but not actually visible/clickable" bugs are structurally out of scope here.

## The territory line

**Unit tests own pure logic outside components. Components are never unit-tested** — a component's verification unit is a user scenario, which is integration territory. The unit is a branch, not a component: "I built this component, so it needs a test" produces mirror tests; "I built this branch, so it needs a test" produces real ones.

## Unit litmus (all four must hold)

1. **No render needed.** If it needs `render`, it's an integration candidate.
2. **No MSW needed.** If the network boundary appears, it's not a unit. Extract the response-transforming logic (`transformOrderResponse(json) → viewModel`) and unit-test it on fixed JSON input.
3. **Branches, edge values, or transitions exist.** No branches → no behavior → no test.
4. **Extraction is easy.** If logic is tangled inside a component or hook and hard to pull out, that is design feedback: components are thin shells, logic lives in pure modules.

## What to unit test

- **Validation rules** — `validatePassword(value) → errors`, exhaustive over branches. Integration keeps one wiring case ("invalid input shows the message and disables submit").
- **Display transforms** — relative time (59s/60s boundaries), currency (zero, negative, rounding), file size. Inject the clock; nondeterminism sources get parameters.
- **Reducers / state machines** — cart (qty 0 removes the line, stock cap), wizards, undo/redo. State × action → state: ideal unit clients.
- **Selectors / derived state** — permission matrix → visible menus, filter+sort+search → visible list, cart → totals. Compute in a function; never count DOM nodes to verify this logic.

## What NOT to unit test

- **Props/callbacks in isolation** (`expect(onSubmit).toHaveBeenCalledWith(...)`) — interaction with an internal collaborator; users don't experience callbacks. Parent-child wiring is covered free by the tree-level integration test.
- **Hooks via `renderHook`, internal state** — implementation welding. Complex hook logic is an extraction signal. Sole exception: a library-grade shared hook whose public API *is* the hook.
- **Static rendering mirrors and DOM snapshots** — "the button text appears", enumerating sidebar menus. Change detectors: they break on intended copy changes and catch nothing (the framework rendering your JSX is third-party-verified). Static existence is verified free when a flow test queries and clicks the element.
- **Third-party engines** — react-hook-form, TanStack Query, Zod. Test the rules you hand them, not their machinery.

## Integration standard form

Render the full tree (real children, real store, real router), substitute ONLY the network boundary with MSW, interact like a user, assert on what the user sees — via role and accessible name.

```tsx
test("applying a coupon shows the discounted total and submits it", async () => {
  render(<CheckoutPage />, { route: "/checkout" });
  await user.type(screen.getByLabelText("쿠폰 코드"), "WELCOME10");
  await user.click(screen.getByRole("button", { name: "적용" }));
  expect(await screen.findByText("총 18,000원")).toBeInTheDocument();
});
```

**Per screen, case the four async states** — loading (delayed handler), success, error (and its *recovery path*: retry click → success), empty. Success-only is the default failure mode of test authors; the four-state checklist is the discipline. Default handlers model the happy path; each test's deviation is declared inline with `server.use(...)`.

**Assert outbound requests** — the frontend analog of backend's "assert persisted state". Capture the request body in the handler and assert on it: visible discount with no `couponCode` in the payload is a bug only this catches. Call counts only when user-meaningful ("double-click submits one order").

**Timing behaviors** — submit-in-flight disables the button; optimistic update rolls back on failure. Reproducible only via MSW delay/failure control.

**URL ↔ screen sync** — changing a filter updates the query string; entering that URL restores the filter. Real-router territory; corresponds to refresh and link-sharing.

## MSW handler rules

- Happy path in default handlers; per-test deviations inline via `server.use`.
- Response shapes come from one factory/fixture module, not hand-built JSON per handler — one place to fix when the API changes.
- **Honesty guard**: type the factories against the API contract (OpenAPI-generated types or shared schema). A handler is a belief about the backend; untyped beliefs drift, and MSW without a contract guard is a mockist suite with the boundary moved.

## Integration anti-patterns

- Re-running unit branches through the DOM (15 validation cases via typing).
- `vi.mock("./useOrders")` or store swapping — the only substitution point is MSW.
- Arbitrary sleeps — await conditions (`findBy*`).
- Over-specified asserts (full-sentence text match, DOM structure) — use role + accessible name; it survives copy tweaks and doubles as an accessibility check (what the test can't find by role, a screen reader can't either).
