# Decision Records

Follow the repository's existing ADR location, numbering, and format. Otherwise use docs/adr/NNNN-slug.md, taking the next number after the current maximum.

## When to record

Record decisions that are meaningfully costly to reverse, difficult to understand without context, and the result of a real trade-off. Easily changed implementation details can stay in code or the relevant topic document.

Subjects may include data ownership, storage or integration choices, operating constraints, and non-obvious alternatives likely to be proposed again. Create a file when there is a decision to record.

## Content

Make the title state the decision. Connect context, choice, and rationale in a short explanation.

> # Persist transcription results by chunk
>
> Save each completed chunk so a failure late in a long recording does not require repeating successful transcription.
> This adds progress-management work compared with saving only the final result, but reduces repeated requests and lost results.

Add alternatives, consequences, reconsideration conditions, or status when they help the reader. Not every record needs the same sections.

## Updates

Clarify an existing record in place when the decision is unchanged. When the decision changes, create a new record and link to it from the old one. Update current operating or architecture documentation alongside it.
