# 08. Error Handling

A failure is information, and the code's job is to keep that information alive until someone can act on it. Expected failures travel as typed values; unexpected ones travel as loud exceptions; each is translated exactly once, at the boundary. Swallowing an error does not handle it; it converts a specific truth into a permanent mystery.

## 1. Never swallow

Every caught error is one of three things: handled, meaning behavior genuinely changes because of it; enriched and rethrown; or returned as a typed failure. A bare catch that maps everything to a generic "unavailable" is none of these. It flattens every future defect, from a typo to a dead database, into the same opaque 503, and destroys the only evidence at the same time. If a catch block cannot do something meaningful, it should not exist; and a catch that keeps the error but tells no one has a twin rule in 09-observability.

## 2. Expected failures are values

Outcomes the domain anticipates, such as not found, conflict, invalid input, or an unavailable dependency, return as typed results in one codebase-wide shape. Exceptions are reserved for the unexpected: bugs and broken infrastructure. The difference matters because types force every caller to face the failure case, while a thrown "not found" is a control-flow jump that some layer will forget to catch, and another layer will swallow.

## 3. Translate once, at the surface

A failure keeps its identity from where it happens to where it leaves the system, and becomes an HTTP status or a log entry exactly once, in the surface's single translator (see 04-api-contracts). Every intermediate re-wrapping loses information: a repository error renamed by the service and renamed again by the router arrives at the client as nothing in particular. Layers in between pass failures along; they do not rename them.

## 4. Say whether retrying helps

A failure declares whether it is transient or permanent. Timeouts and contention may resolve on a second attempt; validation errors and missing records will not, no matter how many times the caller insists. Retry decisions in callers, jobs (06-background-work), and clients hang on this declaration, not on string-matching an error message.
