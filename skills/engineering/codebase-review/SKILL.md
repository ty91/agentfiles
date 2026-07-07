---
name: codebase-review
description: Audit a codebase, or a user-specified module or scope, against the codebase-standards rules and report concrete rule violations. Use when the user asks to review standards compliance, audit code against the team standards, or check whether a module follows codebase-standards.
disable-model-invocation: true
---

# Codebase Review

Review code against the rules in the `codebase-standards` skill and report which rules are violated, where. The standards documents are the only yardstick: a finding must cite a specific rule, and anything no rule covers is not a finding.

## Steps

1. **Fix the scope.** Use the module, path, or stack the user named; default to the whole repo. State the scope in the output.
2. **Load the rules.** Use `codebase-standards` skill and read every document whose triggers match what the scope contains: backend code loads the backend documents, UI loads the frontend documents, tests load the testing documents, and the shared documents always apply.
3. **Compare code to rules, not to taste.** Walk the scope one standards document at a time. For large scopes, review module by module. Style preferences, hypothetical improvements, and smells no rule names are out of scope.
4. **Verify before reporting.** Read the actual code at every candidate finding and keep only what the evidence supports. Aggregate repeated instances of the same violation into one finding with a list of sites; do not report the same rule once per occurrence.
5. **Report with the template below**, ordered by impact. If something looks genuinely harmful but no rule covers it, list it in one line under "Standards gap candidates" instead of inventing a rule.

## Output template

```md
# Codebase Review: {scope}

Reviewed against: {standards documents read}

## Violations

### 1. {one-line finding}
- **Rule**: `backend/03-data-access.md` §2 — "Every query has a bound"
- **Where**: `src/orders/repo.ts:142` (and {n} similar sites: …)
- **Evidence**: {one or two lines describing what the code does}
- **Fix direction**: {one line}

### 2. …

## Standards gap candidates (optional)

- {one line each: harmful pattern observed, but no standards rule covers it}
```
