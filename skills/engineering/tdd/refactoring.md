# Refactor Candidates

After TDD cycle, look for:

- **Duplication** → Extract function/class
- **Long methods** → Break into private helpers (keep tests on public interface)
- **Shallow modules** → Combine or deepen
- **Feature envy** → Move logic to where data lives
- **Primitive obsession** → Introduce value objects
- **Existing code** the new code reveals as problematic

## Test Refactoring

After reaching GREEN, refactor tests too. Keep the behavior coverage, but reduce noise and coupling.

Look for:

- **Duplicate setup** → Extract a small factory or builder when repeated setup hides intent
- **Unclear names** → Rename tests so they read like behavior specifications
- **Implementation assertions** → Replace internal call/order/count checks with observable behavior checks
- **Repeated coverage** → Merge or delete tests that fail for the same reason and add no new signal
- **Obsolete exploration tests** → Delete early tracer tests when stronger behavior tests now cover the same rule
- **Over-broad tests** → Split tests that cover unrelated rules or have multiple reasons to fail

Do not refactor tests while RED. First make the current behavior pass, then simplify the tests without changing what behavior they protect.
