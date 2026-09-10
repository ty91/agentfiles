# UI Composition

Consider composition when structural differences between callers produce tangled conditional props. Shared appearance alone may need only a regular component or shared styling.

- Express structural choices through children or explicit parts when that makes valid usage clearer. Limited visual differences such as color or size can be variants.
- Booleans are natural for simple states such as disabled or loading. Model dependent states so their valid combinations are visible.
- If participant and glossary inputs share duplicate prevention and IME handling, reuse that input behavior. Do not assume their persistence behavior is also identical.
- Use context when parts genuinely share instance state. Adjust subscription scope when update cost becomes a problem.
- Parts of one concept can live in one file. Follow the project's naming, export notation, and styling conventions.
- When adding a part or state, check whether it belongs to the existing contract. A new state does not automatically require a new component, and reuse does not justify unrelated behavior flags.

Check that representative call sites make composition readable and that input, error, and state responsibilities are easy to locate. Use [frontend.md](../tests/frontend.md) for behavioral verification.
