# Concepts and Relationships

Use when a term refers to different things or a relationship affects state, permissions, or storage.

1. Read existing terminology, relevant code, and user scenarios together. Do not replace project language wholesale with preferred architectural vocabulary.
2. Identify what each concept represents, when its lifetime ends, and who may change it.
3. Check relationships using concrete cases relevant to the request. For example, determine whether one recording belongs to one meeting and whether transcription retry creates a new record or resumes existing work.
4. Define invariants and allowed state transitions, then reflect them in types, storage constraints, and ownership.
5. When code and descriptions disagree, distinguish current behavior from intended behavior. Ask the user when the difference affects a decision and existing context does not resolve it.

A terminology difference alone need not interrupt the task or create a file. If the agreed meaning needs to persist, follow [documentation](../documentation/SKILL.md) and update the relevant existing document.

The same word can have different meanings in different areas. Separate concepts when ownership or lifetime differs; do not merge them just to standardize a word.
