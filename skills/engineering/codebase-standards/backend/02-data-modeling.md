# 02. Data Modeling

The database is the system's memory. It records facts: what happened, stated once, guarded by constraints. Everything else, every count, every summary, every cached answer, must be derivable from those facts. One truth per concept, one writer per table, no fact living only in process memory. A data model rots exactly where a second copy of the truth appears.

## 1. The schema owns the invariants

A rule that must always hold about the data is expressed as a database constraint: foreign keys for references, NOT NULL for required facts, unique indexes for identity, checks for ranges. Application code that guards an invariant protects only the paths that remember to call it. A constraint protects every path, including the ones written next year.

The flip side: constraints are for invariants, not policies. A rule that changes with business decisions belongs in the decisions layer, where changing it does not require a migration.

## 2. Status columns are closed unions

A status column lists every state the domain allows, enforced by the database, using one mechanism for the whole codebase. When reality brings a new state, add it to the union and handle it in every transition.

Never add a catch-all value like `other` or `unknown`. One escape value quietly breaks the state machine: every transition must special-case it forever, and no one can say what rows in that state actually mean. The same applies to free-text columns holding values from a known set; if the set is closed, close the column.

## 3. Store facts, not what follows from them

If a value can be computed from stored facts, compute it when you read. A stored derived value is a second copy of the truth, and it starts lying the moment any writer updates the inputs without updating it.

There is one legitimate exception: a derived column whose recomputation has a single machine owner, updated in the same transaction as every write to its inputs. If invalidation relies on someone remembering, the column will go stale. And keep one truth per concept: when the same question can be answered from two places, one of them is already wrong; you just do not know which yet.

## 4. Every fact has one writer

Each table belongs to one module, and only that module writes it. Everyone else asks the owner through its public surface (see 01-module-composition). When two modules write the same table, its invariants have no owner: each writer preserves the rules it knows about and silently breaks the rest.

Reading other modules' data has its own rules; 03-data-access covers them.

## 5. Process memory does not own facts

A fact must survive a restart and be visible to a second instance, which means it lives in the database. In-memory maps, sets, and caches may accelerate reads of stored truth; they may never be the only place a truth exists.

The test is simple: if this process dies right now, is anything lost that cannot be rebuilt from the database? If yes, a fact was stored in memory. This includes designs that only work with exactly one instance running; that assumption is an unstored fact about the whole system, and it will be falsified by the first horizontal scale-out.
