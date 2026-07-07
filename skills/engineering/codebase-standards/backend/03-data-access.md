# 03. Data Access

Reading is a budget. Every query costs a round trip, every row costs memory, and the cheapest row is the one you never fetch. Load lists in one query, bound every result, project only what you need, and ask the table's owner. Read cost scales with the answer you return, never with the history of the table.

## 1. Load lists at the list level

One collection, one query. If a loop contains a database call, the loop belongs inside the query: fetch the batch with a join or an `IN` clause, not item by item. A twenty-item list that queries per item makes twenty-one round trips, holds its transaction open the whole time, and gets slower with every row the feature succeeds in creating.

The same goes for writing collections: a batch is inserted as a batch, not as a loop of single inserts.

## 2. Every query has a bound

Every list query carries a limit, even when it feels like there could never be that many rows. Tables only grow, and the query written without a bound is the one that takes the service down two years later. Paginate with a cursor on the sort key plus a unique tiebreaker, fetching one row beyond the page to know whether a next page exists.

The bound must also be honest. A paged query that first aggregates an entire history before returning its page is unbounded in disguise. If answering a page costs everything that ever happened, the model needs a running fact, not a bigger query; see 02-data-modeling for when a derived value may be stored.

## 3. The cheapest row is the one you never fetch

Select the columns the caller needs, never whole rows by habit. Filter and aggregate where the data lives: if the application loads a thousand rows to answer with ten, the database was asked the wrong question. Counting, summing, and checking existence are all questions the database answers in one row.

Explicit projection has a second job: a column that is never selected can never leak. Secrets stay out of responses by never entering the process.

## 4. Ask the owner

Every table is queried in one place: the module that owns it. A module that needs another module's data calls the owner's public surface; it does not join the owner's tables, because a foreign query silently depends on invariants only the owner knows how to keep.

Derived questions have one owner too. A formula like an available balance is implemented exactly once, in the module that owns its inputs. Two implementations of the same formula will drift, and one day they will give two different answers to the same question.
