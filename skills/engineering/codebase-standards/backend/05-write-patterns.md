# 05. Write Patterns

Every write happens twice: once the way you designed it, and once concurrently with itself, retried by a client you cannot see. A transaction draws the boundary of an invariant. Read-modify-write happens atomically or not at all. Every write can arrive twice without doubling its effect. Concurrency is not an edge case; it is the normal condition your write lives in.

## 1. A transaction is the boundary of an invariant

Everything that must be true together commits together. If a rule spans two tables, one transaction spans both writes; if a precondition guards a write, the check and the write share the transaction, with the rows the check depends on locked. A check in one statement and a write in another is not a sequence, it is a race: the world is allowed to change between them.

The boundary works both ways. A transaction wider than its invariant holds locks it does not need and blocks writers it has no business blocking.

## 2. Read-modify-write is atomic

Never read a value, compute in the application, and write the result back as if the value had waited for you. Push the computation into the database as a single atomic update, carry the precondition in the write itself, or lock what you read until you write. Two writers that each read the same value and write back their answer will lose one update, silently; under default isolation this is the expected behavior, not a rarity.

## 3. Every write survives arriving twice

Clients retry on timeouts, and a timeout does not mean the write failed; it means the client stopped waiting. The second arrival must be harmless: an idempotency key, a unique constraint that absorbs the duplicate, or an operation that is naturally idempotent. If a doubled request creates a doubled order, the defect is in the write path, not in the client that retried.

## 4. No network inside a transaction

A transaction holds locks and a connection; a network call inside it holds them hostage to someone else's latency. Call out before the transaction starts or after it commits, never in between. When the outside world must learn about a change, record that intention inside the transaction and deliver it after commit; 06-background-work explains how.
