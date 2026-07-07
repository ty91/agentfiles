# 06. Background Work

A request either answers now or records an intention for later; there is nothing in between. Background work is durable, re-enterable, and enqueued in the same transaction as the fact that demands it. Retries are bounded, and failures land where a human looks. Work that exists only in a running process is work the next restart will erase.

## 1. Answer now, or record an intention

The deciding question is whether the caller needs the result to proceed. If yes, do the work in the request. If no, write a durable job record and return.

A promise fired and forgotten inside a request is neither of these. It dies with the process, succeeds or fails invisibly, and never retries. If the work matters, it deserves a durable record; if it does not matter, it deserves deletion.

## 2. The job record commits with the fact

Work born from a data change is enqueued in the same transaction as the change. A committed change without its job is work nobody will ever do; a job without its committed change is work on something that never happened. The crash window between the two is not exotic; every deploy walks through it.

## 3. Every job runs twice

Write the handler as if it will be re-entered, because it will be: retries, restarts, and duplicate deliveries guarantee it. Use the same tools that protect writes in 05-write-patterns: unique constraints that absorb the second run, state checks inside the job's own transaction, and effects that are safe to repeat. A job that must not run twice is a job that is not finished being designed.

## 4. Retries end, and failures have an address

Every job has a bounded number of attempts with backoff, and after the last attempt it lands in a dead-letter state that someone actually sees. Retrying every fifteen minutes forever is not persistence; it is a slow leak that fills the queue with the permanently broken.

A failure that becomes a quiet row in a table nobody queries has not been handled; it has been hidden. The end of a job's retries is the beginning of a human's involvement, and the system must make that handoff visible.
