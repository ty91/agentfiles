# Domain Language

The codebase speaks one language, and that language is written down. `CONTEXT.md` is the project's glossary: the single home for what domain concepts are called and what those names mean. Code, schema, API contracts, and conversation all draw their vocabulary from it. A concept with two names is duplication in the naming dimension — every synonym is a silent copy of a meaning, and it drifts like any other copy.

## The glossary file

Most repos have one context: a single `CONTEXT.md` at the root. Entries are canonical terms with tight definitions and the rejected synonyms parked where everyone can see them:

```md
# Ordering

Receives and tracks customer orders.

## Language

**Order**:
A customer's confirmed request for products, priced at confirmation time.
_Avoid_: purchase, transaction

**Customer**:
A person or organization that places orders.
_Avoid_: client, buyer, account
```

When a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts; the map lists where each context's `CONTEXT.md` lives and how the contexts relate. Find the context the work belongs to before reading terms — the same word may legitimately mean different things in different contexts, and that is the map's job to keep straight.

Create the files lazily. No `CONTEXT.md` exists until the first term is resolved; no entry exists until its term does.

## 1. Names come from the glossary

Before naming a domain concept — a type, a table, an endpoint, a field, a test — read the glossary and use the canonical term, exactly. A term on an Avoid list never enters an identifier, a schema, an API contract, or user-facing copy; every appearance re-teaches the wrong word.

The concept keeps its name through every layer: the table, the type, the endpoint path, the response field, the variable. A rename at a layer boundary — a `customers` table surfacing as a `Client` type — is a translation every reader must carry in their head from then on.

## 2. One name per concept, one concept per name

The glossary is opinionated. When several words compete for one concept, one wins and the rest go under `_Avoid_`. The reverse holds too: one term may not quietly cover two concepts. When a requirement stretches an existing term over something that follows different rules, that is a fork of meaning and it needs a second term. The test: if two "orders" need different rules, they are two concepts wearing one word.

## 3. Conflicts are surfaced, never coded around

When a requirement, a user's phrasing, or the code itself uses a term in a way that contradicts the glossary, name the conflict and resolve it before writing code that depends on either reading. Coding to the "obvious" meaning bakes the ambiguity into an identifier, where it outlives the conversation that could have settled it. The contradiction can run both ways — the glossary may be stale, or the code may be wrong — and the resolution is to fix whichever one lies, in the same piece of work.

## 4. The glossary is updated in the change that resolves the term

The moment a term is pinned down, its entry is written — in the same change, not batched for later. A term resolved in discussion but never recorded will be re-litigated by the next person, and the two resolutions will not match. The same goes for new vocabulary: a domain name introduced in code without a glossary entry is a name nobody agreed to.

## 5. The glossary defines terms and nothing else

A definition is one or two sentences saying what the thing *is* — not how it is stored, computed, or rendered. `CONTEXT.md` is not a spec, a scratch pad, or a decision log: implementation details go where implementation lives, and a decision with its rationale goes in an ADR under `docs/adr` (the `documentation` skill owns that format). Only terms specific to this project's domain belong; general programming vocabulary — timeout, retry, cache — stays out no matter how often the project uses it.
