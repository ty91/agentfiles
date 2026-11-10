# Asynchronous Work and Recovery

Use when duplicate execution, late responses, or process interruption can change the result. Address relevant failure modes without introducing a queue or state machine for every asynchronous function.

| Situation | Decision |
|---|---|
| An earlier query completes later | Which request may update the current view? |
| A user repeats a mutation | Are duplicates allowed, combined, or rejected? |
| Workers modify the same data | Who may claim work and persist its result? |
| A process stops during work | What survives, when is interruption detected, and who resumes it? |
| An external effect succeeds but its response is lost | How is uncertain success handled on retry? |

Disabling a UI control reduces repeated user actions. If duplicate processing matters on the server, enforce that contract there too, using an appropriate constraint, idempotency key, or work claim.

A request generation can prevent stale view updates; a job token can distinguish which worker may persist results. Define what timeouts, cancellation, and heartbeats detect and which effects they can stop.

For long work, use durably saved results as resume checkpoints. Check whether saved results remain reusable when chunking rules or model settings change. Smaller checkpoints reduce repeated work but increase request and storage overhead.

Define whether retries are automatic or manual, their attempt or time limits, which errors are retryable, and how completed results are treated. Do not assume exactly-once execution across an external effect and local persistence.

First ask whether concurrent actors need the same mutable object. Prefer separate owned state merged at the read boundary. When shared writing is a real invariant, enforce it with exclusive ownership, atomic operations, or appropriate locking; instructions are not concurrency control.

Read current state and apply only the difference needed to reach the goal. Check repeated execution and interruption at each meaningful boundary. A later run must be able to recognize stale claims, partial records, and temporary artifacts. Preserve the distinction between external success and locally recorded success.

Use [verify](../verify/SKILL.md), then [backend.md](../verify/backend.md) or [frontend.md](../verify/frontend.md) for the affected surface.
