# Design Red Flags

Screen every candidate. Revise or reject a shape when a flag applies, or explain the concrete constraint that requires it.

| Flag | Evidence and correction |
|---|---|
| Shallow module | The interface exposes many options but hides little. Move coordination behind a smaller contract. |
| Caller orchestration | One operation requires callers to sequence methods and cleanup correctly. Give the operation an owner. |
| Information leakage | Several modules depend on one storage, transport, or policy decision. Keep that decision behind its domain boundary. |
| Temporal decomposition | Load, validate, transform, and save modules repeat the same domain knowledge. Group by the decisions they protect. |
| Pass-through layer | A layer repeats the next layer's methods and arguments without adaptation or policy. Remove it or give it a meaningful boundary. |
| Split ownership | Multiple modules write the same state or synchronize copies. Choose one owner, or separate independent facts. |
| Parallel ways to do one task | Old and new APIs both attract callers. Migrate and delete the obsolete path subject to compatibility constraints. |
| Importable internals | Callers can bypass the public contract. Use available module or build controls to reject the wrong import. |
| Hand-synced lists | Adding one item requires matching edits in several lists. Derive them from one source, or fail a check on disagreement. |
| Invalid state combinations | Optional fields, casts, or synchronized booleans hide the actual states. Encode valid variants and transitions. |
| Unowned asynchronous completion | A stale or duplicate operation can persist results without authority. Define the attempt owner and recovery contract. |

Assume the next contributor reads only a few files and copies the nearest example. Prefer a design where a locally plausible change preserves the repository's invariants. State which boundaries are enforced and which still depend on convention.
