# 04. API Contracts

The surface is where untrusted bytes become narrow types, and where domain results become promised shapes. Parse once at the boundary. Answer in one shape, fail in one shape. Every endpoint is born with authorization, and the policy it enforces is declared in one place. Internal models stay inside. A contract is what callers build against, so it changes deliberately or not at all.

## 1. Extend before you add an endpoint

An endpoint is a permanent promise: it must be authorized, documented, versioned, and maintained for as long as one caller exists. So climb the ladder: a new field on an existing endpoint, then a new parameter or variant, then a new endpoint. Most features are a field, not a route.

The ladder runs the other way too. When one endpoint starts answering two different questions depending on who asks, split it; an overloaded endpoint is two contracts wearing one URL.

## 2. Parse once, at the boundary

Everything arriving from outside is untrusted bytes until a runtime schema at the surface says otherwise. The reward for validating once is a narrow type the rest of the code trusts without re-checking; deeper layers never re-parse.

Type annotations are not validation. A compile-time type on a request body checks nothing at runtime; it only makes unvalidated data look validated, which is worse than leaving it obviously raw.

## 3. One success shape, one failure shape

Success and failure envelopes are uniform across every endpoint, and the translation from domain failure to HTTP status lives in one translator, not in each router. Status meanings are fixed: not found is 404, conflict is 409, invalid input is 400, creation is 201, and infrastructure trouble is 5xx. A not-found returned as 400 teaches the client to stop trusting statuses at all.

Install a global handler so that even unexpected errors leave in the standard envelope. The second error shape in a system is the one that breaks clients, because nobody codes against it.

## 4. Every surface is born with authorization

An endpoint declares who may call it at the moment it is created, through one structural mechanism the whole codebase shares. Authorization re-implemented inline in each handler is authorization that a new handler will forget. If it is possible to register a route without an authorization declaration, that route will eventually ship.

## 5. Authorization policy is declared once

Who may read and who may write is a domain decision with a single source. A router that declares its own role constants is writing policy by accident: nine routers each guessing the admin roles will disagree, and the answer to "can staff write here?" becomes whichever module you happen to be reading. Routes reference the declared policy; they never restate it.

## 6. Internal models never leave

Responses are explicitly mapped contract types, never raw rows or persistence entities. The contract and the schema evolve on different clocks: renaming a column must not break a client, and adding a secret column must not create a leak. A response assembled by explicit mapping can only contain what you chose to put in it; 03-data-access covers the same discipline on the way in.
