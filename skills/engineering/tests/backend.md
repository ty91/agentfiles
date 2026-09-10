# Server and Storage Verification

Choose the HTTP, SQL, file-processing, or background-work scope affected by the change. Direct tests of repository or job-management APIs are valid.

## Data and files

- Use a real engine when verifying SQL, transactions, or constraints. If using a substitute engine, check whether production feature differences affect the risk.
- Use temporary databases, directories, or isolated schemas and clean them up. Keep user data and real credentials out of tests.
- Create a fresh test database through the app's initialization or migration path. For schema changes, also verify upgrades from relevant existing versions and data.
- Check transformed and preserved data during migration. Fresh database creation or matching SQL text alone does not establish upgrade correctness or data preservation.
- For file-processing changes, verify relevant size, format, partial-write, cleanup, and streaming behavior using real temporary files.

## HTTP and external integrations

Use the assembled app when routing, input validation, authentication, or serialization is at risk. If persistence is part of the behavior, verify the response and durable result. Not every calculation boundary needs repetition over HTTP.

Control external failures and delays through a substitute server or transport appropriate to the project. Verify request shape and outcomes after failure, and check that substitute responses match the real contract. Matching types alone does not establish real service behavior.

Distinguish local substitute tests from live provider verification. Before a necessary live call, check the task's authorization, cost, and data-transfer constraints. Report the boundary as unverified if no live check was performed.

## Interruption and retry

Choose transitions relevant to the change.

- Save partial results, fail, retain those results, and retry only remaining work.
- Compete for a job or complete an old attempt late while preserving current ownership and results.
- Interrupt a process, detect the interruption, and exercise the promised automatic or manual recovery.
- Succeed externally but fail to persist locally, then handle duplicate effects or uncertain success.

Control response order and time to reproduce the scenario. Restarting after successful completion does not verify recovery from interruption during processing.
