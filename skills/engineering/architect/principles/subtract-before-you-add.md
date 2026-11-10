# Subtract Before You Add

Before introducing a new path, identify dead code, duplicated decisions, redundant validation, and obsolete references the change can remove within scope.

- Remove obsolete structure before polishing or extending it. Keep the smallest coherent change that reaches the required behavior.
- Design for observed usage. Do not add speculative layers, configuration, parsers, guards, or alternate implementations.
- When replacing an internal API, migrate all callers and delete the old path in the same change if no external user requires compatibility and coordinated breaking changes are possible.
- When compatibility is required, state who still depends on the old path and what ends the transition. Do not silently treat external consumers as internal callers.
- Follow renames and removals through types, strings, docs, examples, and back-references. A symbol search alone may miss consumers.
- Keep independently changing responsibilities separate. Subtraction does not authorize unrelated cleanup or collapsing a useful boundary.
- Remove a change when its motivating hypothesis is disproven. Do not leave speculative guards or optimizations behind because they might help.
- Preserve behavior through each refactoring step. A planned migration that needs a transitional break must name its reversible scope and verification boundaries first; this principle does not waive the caller's checks.

State what was removed, what old path still remains and why, and what verifies the surviving contract. A replacement is incomplete while unnecessary parallel paths remain.
