# Storage and Job Verification

- Verify SQL, transactions, and constraints on a real engine.
- For schema changes, verify upgrades from existing versions and data, not only fresh creation.
- Exercise the interruption the change risks: partial save then retry of remaining work, a late completion from a stale attempt, interruption mid-process, external success with local persistence failure.
- Report live provider behavior as unverified unless a live check ran within the task's authorization.
