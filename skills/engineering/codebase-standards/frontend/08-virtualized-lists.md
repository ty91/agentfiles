# Virtualized Lists

A list can be as long as the data, but the screen is finite. The DOM follows the size of the window, not the size of the data. In a virtualized list, mounting and unmounting rows is a side effect of scrolling, so a row must be a thin presentation that entrusts both its identity and its state to the data.

## Rules

**1. The prescription for a long list is bounding first, then virtualization. A list whose size is finite by design is not virtualized.**

- **Bound it**: first ask "does this screen need all of these rows". Do not replace what the server can filter (search, filters, pagination) with client-side scrolling. The cheapest row is the row you never fetched.
- **Virtualize**: what remains after that: lists that grow with the data and whose consumption is scrolling itself. Chat and message history, logs and event streams, spreadsheet-like data tables, infinite feeds. Beyond these, introduce virtualization only when a measured performance problem demands it; never lay it down preemptively on a guess.
- **Do not virtualize**: menus, role lists, settings items, lists whose size is finite by design. Virtualization is not free: in-browser search dies, accessibility and testing get harder, and the height machinery comes along.

Virtualization only works inside a finite window. The scroll container must own its height; if the container stretches to fit the content, every row is "visible" and everything renders.

```tsx
// Bad: the DOM grows with the data. Ten thousand rows, ten thousand nodes
{members.map((m) => (
  <MemberRow key={m.id} member={m} />
))}

// Bad: virtualizing a 12-row role list. Nothing gained, simplicity lost
const rows = useVirtualRows({ count: roles.length, estimateHeight: 40 });

// Good: the DOM exists only as much as is visible
const rows = useVirtualRows({ count: members.length, estimateHeight: 48 });
{rows.map((row) => (
  <MemberRow key={members[row.index].id} member={members[row.index]} />
))}
```

**2. A row's identity comes from the data, and state that must outlive the row lives outside the row.**

In a virtualized list, scrolling decides mounting and unmounting. Using the index as the key makes identity positional instead of data-bound, so when rows shift, state sticks to different data. A row component's local state evaporates on scroll-out. State that must survive scrolling, like selection or expansion, is managed by the list's owner, keyed by item id.

```tsx
// Bad: identity is position. When rows shift, state sticks to different data
{rows.map((row) => (
  <MemberRow key={row.index} member={members[row.index]} />
))}

// Bad: the row owns state. It evaporates on scroll-out
function MemberRow({ member }: { member: Member }) {
  const [isSelected, setIsSelected] = useState(false);
  // …
}

// Good: identity comes from the id, and the list owns selection by id
const [selectedIds, setSelectedIds] = useState<ReadonlySet<string>>(new Set());
{rows.map((row) => {
  const member = members[row.index];
  return (
    <MemberRow
      key={member.id}
      member={member}
      selected={selectedIds.has(member.id)}
      onToggleSelect={() => toggleSelected(member.id)}
    />
  );
})}
```

**3. Mounting a row must be free. Scrolling is mounting.**

In a virtualized list, rows are born and die on every scroll frame. A fetch, a subscription, or an expensive initialization attached to row mount turns scrolling into a request storm. Data arrives at the list level; the row draws what it is given. Even the next-page request of infinite scrolling is decided by the list watching the visible range, not by a row.

```tsx
// Bad: mounting a row fires a request. One scroll, dozens of requests
function MemberRow({ member }: { member: Member }) {
  const { data: presence } = usePresence(member.id);
  // …
}

// Good: data arrives at the list level, and the row draws what it received
function MemberList({ teamId }: { teamId: string }) {
  const { data: members } = useMembers(teamId);
  const { data: presences } = usePresences(teamId);
  // …
}
```

**4. Row height is a declaration or a machine's measurement. A row does not change its own size after render.**

If the height is fixed, declare it fixed. If it varies, provide an estimate and leave the measuring to the machine, the virtualization layer. Do not build a human-maintained copy that computes and stores each row's height. Either way, row content does not resize itself after render: things that arrive asynchronously, like images, reserve their space first. Every time one row grows, everything below it shifts and the scrollbar jumps around.

```tsx
// Bad: the row grows on its own. The scrollbar jumps every time a load finishes
function MessageRow({ message }: { message: Message }) {
  return (
    <div>
      <img src={message.imageUrl} />
      {message.text}
    </div>
  );
}

// Good: the space is promised up front. Height is the same before and after the load
function MessageRow({ message }: { message: Message }) {
  return (
    <div>
      <img src={message.imageUrl} width={320} height={180} />
      {message.text}
    </div>
  );
}
```
