---
name: tests
description: Choose and maintain verification for a change. Use when writing tests, selecting test scope or dependencies, reviewing coverage, or deciding whether a test should be added, kept, moved, or removed.
---

# Tests

Every test must own a failure: one no other test catches, observed at the layer where it shows most directly. Ask this when adding a test as well as when keeping one. A test that cannot answer is a removal candidate.

- Add nothing when types, schemas, or existing tests already guarantee the rule, or the change is copy or styling.
- One rule has one owning layer. Other layers check only that it is connected, with one representative case. Move domain decisions out of components and handlers into code that can be tested directly.
- Slower layers must earn their place. Start from the state the conclusion needs rather than a long unrelated setup.
- Name tests by the rule they protect. A name listing several rules signals a test to split or move down, unless the flow itself is the requirement.
- Derive expected values independently of the implementation. Assert contractual results, not internal calls.
- Use real dependencies where the risk lives. Substitute to control failure, time, or order, and cover separately what the substitute hides.

Project test guidance overrides this skill.

Remove or merge tests the change made redundant. Report tests added, removed, and run, and what remains unverified. Do not claim unexecuted checks passed.

UI: [frontend.md](frontend.md) · Storage and jobs: [backend.md](backend.md) · Test-first: [tdd.md](tdd.md)
