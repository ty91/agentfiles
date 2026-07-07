# State Management

State is a liability, not an asset. Creating a piece of state issues a promise to keep that value true. The fewer promises the better, and the ones that remain should be impossible to break by construction.

## Rules

**1. Facts change in event handlers. `useEffect` is reserved for synchronizing with external systems.** State does not change state. When a requirement arrives shaped as "when X changes, do Y", find the event that sentence is really describing and handle it there. When swapping the subject should reset all of its state, do not hunt for an event; declare the component's identity with `key` (`<Editor key={documentId} />`).

```tsx
// Bad: reacts to a state change by changing other state. The causality is written nowhere in the code
useEffect(() => {
  if (isOpen) {
    setDraft(initialDraft);
  }
}, [isOpen]);

// Good: change both in the event that caused it
function handleOpen() {
  setDraft(initialDraft);
  setIsOpen(true);
}
```

**2. Illegal states are not caught; they are made unrepresentable.** When booleans move together, merge them into one discriminated union. Data that exists only in a particular state lives only on that branch.

```tsx
// Bad: most of the 8 combinations are illegal, and message exists even when there is no error
const [isSubmitting, setIsSubmitting] = useState(false);
const [isError, setIsError] = useState(false);
const [message, setMessage] = useState("");

// Good: what can be represented is exactly what is legal
type SubmitState =
  | { status: "idle" }
  | { status: "submitting" }
  | { status: "error"; message: string };
const [submit, setSubmit] = useState<SubmitState>({ status: "idle" });
```

**3. Match a state's lifetime to the lifetime of the thing it describes.** Put state in the lowest common ancestor of the components that read it, and never higher "because we might need it later". The right place is the one where the state disappears together with its subject.

```tsx
// Bad: the draft outlives the dialog. Close and reopen, and last time's input is still there
function MembersPage() {
  const [inviteEmail, setInviteEmail] = useState("");
  return (
    <>
      {/* … */}
      {isInviteOpen && <InviteDialog email={inviteEmail} onEmailChange={setInviteEmail} />}
    </>
  );
}

// Good: the draft shares its lifetime with the interaction it describes
function InviteDialog() {
  const [email, setEmail] = useState("");
  // …
}
```

**4. Make a copy only when a machine owns its invalidation.** When a computation is expensive enough to materialize its result, use a mechanism where a machine manages the copy's lifetime, such as a dependency array or a cache key. Never create a copy whose refresh points a human has to remember.

```tsx
// Bad: a human owns invalidation. Miss one refresh point and it silently goes stale
const [sorted, setSorted] = useState<Item[]>([]);
function handleAdd(item: Item) {
  setItems([...items, item]);
  setSorted(sortItems([...items, item], order));
}
function handleReorder(next: Order) {
  setOrder(next);
  setSorted(sortItems(items, next)); // handleRemove forgot to do this
}

// Good: invalidation is owned by a machine, the dependency array
const sorted = useMemo(() => sortItems(items, order), [items, order]);
```
