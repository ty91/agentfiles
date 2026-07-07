# Mutation Patterns

The screen shows only facts the owner has confirmed. A mutation is a proposal, not a command. Until confirmation, the facts on screen do not change; after confirmation, the screen derives again from the owner.

## Rules

**1. A cache acquires a new value in exactly two ways: ask the owner again (invalidation), or transcribe a value the owner sent (response, push).** Values computed by the client never enter the cache. Invalidation is the default; transcription is for when the round trip of asking again would be visible to the user. Derivatives the transcription cannot reach (list order, aggregates) are invalidated alongside.

```tsx
// Bad: puts a client-computed value into the cache
cache.set(memberList(teamId), (old) => [...old, { ...draft, id: tempId(), status: "active" }]);

// Good: asks the owner again. The default
cache.invalidate(memberList(teamId));

// Good: a value the owner sent can be transcribed. Derivatives the transcription cannot reach are invalidated alongside
cache.set(memberDetail(created.id), created);
cache.invalidate(memberList(created.teamId));
```

**2. The invalidation scope is declared with the mutation definition.** The answer to "what does this change make stale" is written once, next to the mutation, and never reinvented per call site.

```tsx
// Bad: invalidation reinvented at each call site. The next call site has to guess the scope again
function InviteDialog() {
  const invite = useMutation(sendInvite);
  function handleSubmit() {
    invite.run(draft, {
      onSuccess: () => {
        cache.invalidate(memberList(teamId));
        cache.invalidate(seatCount(teamId)); // another call site forgot this one
      },
    });
  }
}

// Good: what this change makes stale is written once, next to the definition
export const sendInvite = defineMutation({
  run: (input: Invite) => api.sendInvite(input),
  invalidates: ({ teamId }) => [memberList(teamId), seatCount(teamId)],
});
```

**3. Progress state derives from the mutation transition.** Disabling the trigger and preventing double-firing derive from the transition, and the pending indicator sits next to the trigger that caused the action. No global spinners.

```tsx
// Bad: duplicates progress into separate state and covers the whole screen
const [isSaving, setIsSaving] = useState(false);
{isSaving && <FullScreenSpinner />}

// Good: derives from the transition, and the indicator sits next to the trigger
const invite = useMutation(sendInvite);
const isRunning = invite.state.status === "running";
<Button disabled={isRunning} onClick={handleSubmit}>
  {isRunning ? "Sending…" : "Send invite"}
</Button>
```

**4. A mutation's outcome is handled at its origin.** The completion callback is the event. Success side effects (navigation, closing, notification) run in the completion callback, and failure is shown next to the place that caused the action. Global notification is only for when the origin has left the screen.

```tsx
// Bad: success handling scattered into a data-watching effect. The causality is erased
useEffect(() => {
  if (members.some((m) => m.email === draft.email)) {
    setIsOpen(false);
  }
}, [members]);

// Good: handle the outcome in the completion callback
invite.run(draft, {
  onSuccess: () => setIsOpen(false),
  onError: (error) => setSubmit({ status: "error", fields: error.fields }),
});
```
