---
name: readability-review
description: Review code for cognitive readability based on neuroscience principles. Accepts "local changes", "main..", file paths, or glob patterns.
allowed-tools: Read, Glob, Grep, Bash(git:*)
---

# Readability Review

Review code for cognitive readability, grounded in neuroscience and cognitive psychology research.

This is a **read-only** review. No files will be modified.

## Input Handling

Parse the user's arguments to determine what to review:

| Input | Action |
|---|---|
| `local changes` | `git diff` + `git diff --cached` for all uncommitted changes |
| `main..` | `git diff main...HEAD` for changes between current branch and main |
| `<base>..` | `git diff <base>...HEAD` for changes between current branch and specified base |
| File paths (`src/a.ts src/b.ts`) | Read the specified files directly |
| Glob patterns (`src/**/*.ts`) | Find matching files with Glob, then read them |

If no changes or files are found, inform the user and stop.

For `local changes` and `branch`, focus on changed lines and their surrounding context.
For file paths and globs, review the entire file content.

## Review Principles

Evaluate against each principle below. **Only report findings that are actionable** — skip principles where no issues exist.

### P1. Working Memory Overload

A function or block requires tracking more than ~4 pieces of context simultaneously.

Look for:
- Many interleaved concerns in a single function
- Deep nesting that forces tracking multiple condition layers
- Long expressions combining unrelated computations

Not a violation: inherent domain complexity that cannot be decomposed further.

### P2. Chunking Failure

Code uses non-idiomatic patterns where established idioms exist in the language, framework, or project.

Look for:
- Custom solutions where standard library or framework idioms exist
- Patterns that deviate from project conventions
- Inconsistent approaches to the same kind of operation

Not a violation: deliberate deviation with a clear technical reason.

### P3. Unnecessary System 2 Activation

Code forces conscious analytical parsing where a simpler expression would convey the same meaning.

Look for:
- Double negations and convoluted boolean logic (`!(a < 18 || !b)` → `a >= 18 && b`)
- Cleverness that saves characters but costs comprehension
- Implicit behavior requiring knowledge absent from the immediate context

Not a violation: complexity inherent to the logic being expressed.

### P4. Gestalt Violation

Visual structure contradicts or fails to communicate logical structure.

- **Proximity**: Related code separated by unrelated code, or unrelated code not separated by blank lines
- **Similarity**: Inconsistent naming for the same kind of operation (`fetchUser` / `retrieveOrderList` / `loadPayments`)
- **Continuity**: Deep nesting forcing eye zigzag; missing early returns

Not a violation: formatting consistent with the project's established style.

### P5. Prediction Error

Names, interfaces, or structures set expectations that the implementation violates.

Look for:
- Functions doing more than their name promises (hidden side effects)
- Non-standard parameter/prop names where conventions exist (`value`/`onChange` vs `user`/`setUser`)
- File or directory names that don't reflect contents
- Surprising return types given the function name

Not a violation: well-named functions with expected behavior, even if internally complex.

### P6. Extraneous Cognitive Load

Complexity from representation rather than from the problem itself.

Look for:
- Unnecessary indirection or abstraction layers
- Mixed abstraction levels within a single function
- Redundant state the reader must keep in sync mentally
- Information that could be derived but must be manually tracked

Not a violation: essential complexity of the problem domain.

## Report Format

```markdown
## Readability Review

**Scope**: [what was reviewed — e.g., "local changes (3 files)" or "src/auth/**/*.ts (5 files)"]

### Findings

#### [High|Medium|Low] P[N]. [Principle Name] — `file:line`

[What causes cognitive load and why, in 1-2 sentences.]

Current:
\```[lang]
[problematic snippet]
\```

Suggested direction:
\```[lang]
[sketch of improvement — not a full rewrite]
\```

---

(repeat for each finding)

### Bias Check

[Note any findings above that might stem from the reviewer's unfamiliarity
with a valid pattern, rather than a genuine readability problem.
If none, state "No bias concerns identified."]

### Summary

| Severity | Count |
|----------|-------|
| High     | N     |
| Medium   | N     |
| Low      | N     |
```

### Severity Guide

- **High**: Working memory overload or prediction errors likely to cause misunderstanding or bugs
- **Medium**: Chunking failures, Gestalt violations, or extraneous load that slow comprehension
- **Low**: Minor naming or visual structure improvements

## Guidelines

1. **Be concrete** — always include `file:line`.
2. **Show, don't tell** — include a code snippet for both the problem and the suggested direction.
3. **Respect essential complexity** — only flag representational complexity, never domain complexity.
4. **Check project context** — before flagging a pattern as non-idiomatic, verify it isn't an established project convention.
5. **Skip clean code** — if a principle has no findings, omit it entirely.
6. **Bias-check yourself** — P7 from the source framework. If a finding might be your own unfamiliarity, say so in the Bias Check section.
