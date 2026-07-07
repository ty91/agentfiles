# 01. Test Strategy

A test suite is a set of promises about behavior, and every promise costs review, maintenance, and trust. The default for any piece of code is no test; a test earns its place by pinning a rule that could be wrong. The test surface is the module's interface, not its files. Each rule is pinned exactly once, and whether a diff may add tests at all is decided by what kind of diff it is. RED is a symptom, not a goal.

## 1. The unit of testing is the module's interface, not the file

A test file per source file is a reflex, not a strategy. Each module has one primary test surface: the public interface its real callers use, assembled from real internals. For a backend module that is its routes, running the real decisions and data layers on a local database substitute (see 03-test-doubles); for a UI module it is the component tree, driven through roles, labels, and user-visible outcomes. Internal layers — repository, service, router — do not get their own suites: a suite behind a tested surface re-proves what the surface already proves, through an interface no caller uses.

The exception is pure logic with real complexity of its own: a codec, a calculation, a state derivation. That logic has a small public interface of its own; test it there directly.

The discriminator: does any real caller call the interface this test calls? If the only caller is the test, the test is pinning an internal, and the pin will break on the next refactor that changes no behavior.

## 2. A test pins a rule that can be wrong

What earns a test: a domain rule that branches, a state transition, a boundary where the answer changes, a contract's failure modes, storage semantics running on a real substitute, a serialization round-trip. Each of these can be silently wrong tomorrow, and the test is what says so.

What never earns a test: restating code. A schema definition transcribed into assertions, a config file's contents matched against itself, a constant array repeated, a type's shape, an internal call's arguments, a cache key's tuple, a class name, "renders without crashing." These tests cannot catch a bug — they fail only when the code is edited, which means they detect change, not defects.

The discriminator: if the only way to make this test fail is to edit the source it describes, it is not a test; it is a second copy of the code, and shared/duplication-and-promotion forbids silent copies. Schema invariants need no transcription test: the database enforces them (see backend/02-data-modeling) and every surface test running on the real substitute exercises them.

## 3. Each rule is pinned exactly once

The same rule asserted at several layers is a silent copy: when the rule changes, every copy must be found and changed, and one day one will not be. One error code asserted in the repository test, the service test, the route test, the client test, and the page test is five tests and one rule. Pin the rule at the lowest surface that can prove it, and let the other layers inherit the guarantee.

At the surface, coverage is one representative success per operation plus each failure whose observable answer differs — not every input value, and not the same failure re-dressed per layer. Choose boundary values that prove the rule: inventory 10 with order 10 succeeds, order 11 fails.

## 4. The diff decides whether a new test exists

Classify the change before writing any test:

- **A new obligation on the interface** — new behavior, a new rule, changed contract semantics. The only case where RED is legitimate: one failing test per new obligation, then the implementation that meets it.
- **A behavior-preserving change** — internal restructuring, efficiency, cleanup. Zero new tests. The verification is the existing suite staying green; that is the suite doing its job. A RED test can only be manufactured here by reaching past the interface, so the attempt itself is a rule-2 violation in progress.
- **A bug fix** — a bug is a missing pin. Add exactly one test that reproduces it and fails on the old code. This is the routine way a regression test is born; rule 6 decides whether it stays.
- **A contract removal or narrowing** — the work is editing and deleting existing tests until the suite describes the new contract, never adding an absence assertion. A test that asserts a field is gone or a route no longer exists pins the transition, not the system; transitions are recorded in commits and ADRs. The suite describes what the system is, not what it stopped being.

RED is a symptom, not a goal. It appears when a new obligation exists and is not yet met; when there is no obligation to add, there is no RED to seek.

## 5. Scaffolding comes down when the work ends

While working, a test that verifies "my change was applied" — the removed field is absent from the response, the new module got wired — is a legitimate steering device, with the same status as a debug print. Finishing the work includes deleting it.

Two discriminators separate scaffolding from a real pin. First: is the subject of this test a rule of the system, or the change just made? Second: would someone building this module from its spec, with no knowledge of the diff's history, write this test? An absence assertion can be a real pin when the absence itself is a standing obligation — password hashes never leave the repository, admin-only fields never reach customer responses. "The legacy route returns 404" is neither; it is the memory of a deletion.

## 6. A regression test is the product of an incident, not of a change

Blanket "regression protection" added alongside every change is scaffolding by rule 5. A regression test earns a permanent place only when all three hold: the defect actually happened and its recurrence would be costly; it revealed a hole in the existing test surface; and it can be rewritten as a standing obligation of the interface. When all three hold, rewrite it that way — the name states the obligation, and the test reads like any other behavior test, not like an incident report.

## 7. The test list is the plan and the review surface

Before implementing, write the behaviors to pin as one-line requirement sentences. That list is what a reviewer approves; the diff's tests map to it one to one — no test in the diff without a sentence, no sentence without a test.

Then work one obligation at a time: one failing test, the minimal implementation that meets it, green, next. Never refactor while RED. And tests are replaced, not layered: when a stronger test at the surface comes to cover what an earlier, narrower test proved, the narrower one is deleted in the same change.
