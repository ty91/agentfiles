# State Provisioning

Ownership decides who holds a fact; provisioning decides how its readers reach it. A prop travels only through components that read it. The means of transport form a ladder ordered by reach: each rung down reaches farther and hides the dependency more. Take the highest rung that works, and never step down because passing props feels tedious.

## Rules

**1. A component never receives a prop it does not read. When a prop is only received and passed down, walk the ladder from the top; the first rung that works is the answer.**

- **Read the owner directly**: server-, URL-, and device-owned values are read at the point of use. Nothing travels but identity.
- **Compose**: when the consumer can be assembled where the data lives and the intermediates only arrange, restructure to children.
- **Context**: when the value is environmental — identical for every reader in the subtree, read-heavy, write-rare.
- **Scoped store**: when several descendants read and write interaction state, and readers need to subscribe to their own slice.
- **Global store**: the exception, unchanged from data ownership — state that belongs nowhere yet must be seen by several unrelated screens at once.

Reading means the prop appears in the component's own logic or markup; spreading `...props` into a DOM element or an underlying primitive is not passing down. Composition fails only when the intermediate generates structure from data (a list creating its rows, a virtualized window) or when the reader sits inside a subtree's internal implementation that cannot be pre-assembled from above. Tedium is not failure.

**2. Server-, URL-, and device-owned values are read where they are used. Only identity travels as props.**

The cache, the URL, and storage are already ambient layers; threading their contents through the tree is a bucket brigade for water that is already plumbed. Pass at most an id — and an id usually has a URL owner. Provision the source, not a derivative; deriving happens at the point of use.

```tsx
// Bad: server data rides through components that never read it
function TeamPage() {
  const teamId = useTeamIdParam();
  const { data: team } = useTeam(teamId);
  return <TeamLayout team={team} />;
}
function TeamLayout({ team }: { team: Team }) {
  return <MemberPanel team={team} />;
}

// Good: the reader reads the owner where it stands
function MemberPanel() {
  const teamId = useTeamIdParam();
  const { data: team } = useTeam(teamId);
  // …
}
```

**3. Context carries environment, not interaction. The admission test: when this value changes, may the entire subtree legitimately re-render?**

An environmental value is identical for every reader beneath the provider and changes rarely: theme, locale, a compound component's internal coordination, a form's context. If only some readers care, or the value changes with user interaction, the answer to the test is no — it is interaction state and belongs one rung down. Server data never enters context; the cache is already ambient (rule 2).

```tsx
// Bad: interaction state in context. Every selection change redraws everything beneath the provider
const EditorContext = createContext<{
  selection: Selection;
  setSelection: (s: Selection) => void;
} | null>(null);

// Good: context carries what the subtree breathes, not what it does
const DensityContext = createContext<"comfortable" | "compact">("comfortable");
```

**4. Interaction state shared across a subtree lives in a scoped store: the instance is created at the subtree root, provided through context, and read through selectors. A module-scope store is a global in disguise.**

The store's lifetime is the subtree's lifetime — unmount the subtree and the state dies with its subject, exactly like component state. Readers subscribe to their own slice, so a selection change redraws the row that cares, not the whole panel. A store created at module scope outlives every subtree, survives remounts, and leaks state between two instances of the same screen.

```tsx
// Bad: a module-scope singleton. Two editors share one selection, and closing the editor resets nothing
export const editorStore = createEditorStore();

// Good: the instance is born at the subtree root and dies with it
function Editor({ documentId }: { documentId: string }) {
  const [store] = useState(() => createEditorStore());
  return <EditorStoreProvider store={store}>{/* … */}</EditorStoreProvider>;
}

// Good: a reader subscribes to its slice
function RowHandle({ rowId }: { rowId: string }) {
  const isSelected = useEditorStore((s) => s.selectedIds.has(rowId));
  // …
}
```

**5. A store owns one subject. Global keeps the bar data ownership set: reached last, never first.**

A store is named for the subject it owns — the editor session, the selection model — not for where it happens to sit. When unrelated values pile into a store because a store was already there, provisioning has become a junk drawer. And nothing graduates to a global store for convenience: the bar stays "belongs nowhere, seen by several unrelated screens at once" (toast queue, command palette), exactly as data ownership defines it.

```tsx
// Bad: the store that happened to exist becomes a junk drawer
const useEditorStore = createStore({ selection, zoom, toasts, sidebarOpen });

// Good: one subject per store; the toast queue was never part of the editor session
const useEditorStore = createStore({ selection, zoom });
```
