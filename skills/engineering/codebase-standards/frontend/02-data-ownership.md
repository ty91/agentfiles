# Data Ownership

Every piece of data has exactly one owner. Everything else on the screen is derived from the owner or cached from it. Never create a copy that can disagree with its owner.

## Rules

**1. The owner is decided by asking "who needs to see this data, and for how long". Ask in the order server → URL → device → component-local; the first match is the owner.**

- **Server**: other users or other devices must see it. The client holds only a cache.
- **URL**: whoever receives the link must see the same screen. Selected resource, filters, tabs.
- **Device**: it must still be there in the next session on the same device. Theme, sidebar collapse. localStorage owns it.
- **Component-local**: it only needs to live for the current interaction. Draft, open, hover. The default for client state.
- **Global**: the exception outside these axes. Only state that belongs nowhere yet must be seen by several unrelated screens at once lives globally. Toast queue, command palette open.

**2. Never copy server-owned data into client state. Server data on the client is a cache, and you read from the cache directly.**

```tsx
// Bad: copies server data into component state. This copy can disagree with the server
function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);
  // …
}

// Good: reads straight from the cache. The server owns the data; the client holds only a cache
function UserProfile({ userId }: { userId: string }) {
  const { data: user } = useUser(userId);
  // …
}
```

**3. Never store what can be derived. Compute it during render.** A derived value has no owner; only the source does.

```tsx
// Bad: keeps a derived value in state and synchronizes it
const [filtered, setFiltered] = useState<Item[]>([]);
useEffect(() => {
  setFiltered(items.filter((i) => i.name.includes(query)));
}, [items, query]);

// Good: computes during render. Use useMemo when it is expensive
const filtered = items.filter((i) => i.name.includes(query));
```

**4. Never copy a prop into state.** If the intent is to use it only as an initial value, name the prop to declare the transfer of ownership, like `defaultValue`. That state is not a copy; it is the temporary owner for the duration of editing, and it returns ownership at submit.

```tsx
// Bad: copies the prop into state. Later changes to user are silently ignored
function ProfileEditor({ user }: { user: User }) {
  const [draft, setDraft] = useState(user);
  // …
}

// Good: the name declares the transfer of ownership. draft is the owner while editing
function ProfileEditor({ defaultUser }: { defaultUser: User }) {
  const [draft, setDraft] = useState(defaultUser);
  // …
}
```
