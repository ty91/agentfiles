---
name: documentation
description: Update durable project documentation when behavior, public contracts, terminology, operating assumptions, or development procedures change. Record architectural decisions when their rationale needs to survive.
---

# Documentation

Preserve the context future readers need to understand current behavior and decisions. Follow the project's documentation structure and language; use concise Korean when no language convention is specified.

## Workflow

1. Read the README, documentation map, relevant topic documents, and ADRs. Locate the existing home for the change.
2. Update affected contracts, operating assumptions, terminology, or development procedures. Distinguish implemented behavior from planned work.
3. Update existing topics in place. Create a document when the topic is independent and worth revisiting, then link it from the existing documentation map.
4. Follow [adr.md](adr.md) when a decision needs its rationale recorded separately.
5. Compare descriptions with current code and configuration, check links, and include documentation updates in the same task.

## What to preserve

- Contracts, limits, errors, and recovery behavior needed by callers, users, or operators
- Durable assumptions about data ownership, compatibility, upgrades, and backups
- Rationale that code alone cannot explain, including conditions for reconsideration
- Terminology whose ambiguity affects implementation or usage

Express information through names or types when that makes it clear in code. Avoid repeating line-by-line implementation explanations, temporary work logs, or test success records in durable documents. An obvious local change may need no new documentation.

## Terminology and decisions

Use [domain-modeling.md](../codebase-design/domain-modeling.md) when concepts need clarification. Record settled meanings in the existing glossary or topic document; resolving a word does not require creating or updating CONTEXT.md.

Preserve existing document locations and roles. [adr.md](adr.md) is the single source for decision-record creation and updates.

Use relative links within the repository and shareable remote URLs for external references. Keep personal vault references, local environment paths, and secrets out of shared documents.

## Done

Finish when affected descriptions and links are current, and readers can find behavior, rationale, and remaining constraints in the existing documentation.
