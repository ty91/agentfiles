# 07. External Calls

Every external system will eventually hang, fail, and change its shape, and none of that may become our incident. Every call carries a deadline. Every retry has a cap and an idempotent target. Every vendor shape stops at the adapter, where their failure becomes our typed failure. The blast radius of someone else's outage is one feature, never the process.

## 1. Every call carries a deadline

A call without a timeout donates your availability to someone else's incident: one hung request blocks its worker, and everything queued behind that worker waits forever. Every outbound call sets an explicit deadline, and exceeding it is a failure like any other, handled and reported. No response is also a response; plan for it.

## 2. Retry only what is idempotent, and stop

A retry is a second delivery. If the remote operation is not idempotent, retrying it performs the action twice on their side. Retry only when a duplicate is safe, always with a bounded count and backoff. Classify what counts as retryable once, in the adapter, so every caller inherits the same judgment instead of inventing its own.

## 3. Their failure becomes our typed failure

An external outage is an expected failure of ours. Translate it into the domain's error vocabulary at the adapter, where the call happens: callers handle "notifications unavailable", never a raw vendor exception surfacing five layers up. This is what keeps their incident inside one feature; an untranslated failure travels the stack until it finds something it can break.

## 4. Vendor shapes stop at the adapter

The vendor's field names, status codes, and response layout are their vocabulary, not ours. Normalize into our own types at the adapter and let nothing vendor-shaped reach domain logic or the database. The test is concrete: switching vendors rewrites one adapter and zero domain files. Every vendor field that leaks inward is a migration you will owe later.
