# Boundary Discipline

Apply when defining public contracts, validating external data, handling failures, or wiring frameworks and I/O.

- Parse external input into a named domain type at ingress. Network payloads, persisted data, configuration, and environment values are untrusted until checked. A type assertion is not validation.
- Use the repository's existing schema system when it owns the shape, and derive types from it. Do not maintain a parallel interface and validator that can drift.
- Trust the validated internal contract. Do not scatter the same validation down call chains. A value from another trust boundary must be parsed at that boundary, even when a local type names it.
- Expose domain concepts. Keep transport schemas, storage representation, and framework objects private unless they are deliberately the public contract.
- Put domain decisions in pure functions and keep the I/O shell mechanical. Give effects explicit completion, failure, and cleanup owners. Place substitutable dependencies at composition points when environments vary or execution must be controlled.
- Make inputs, results, and failures visible in names and types. Distinguish an absent result from an error. Preserve diagnostic causes while returning actionable failure information.
- Keep general mechanisms inside the module and caller-specific policy at the boundary. Do not expose internal sequencing as public options.

Trace one external input to a result or effect. Identify where it becomes trusted, what the public caller observes, and who handles failure. Internal code should not need the external representation to do its job.
