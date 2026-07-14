# Component Composition

UI grows by composition, not by piling up props. Compound component interface guidance lives in [codebase-design](../../codebase-design/frontend/compound-components.md).

## The two populations

Every component belongs to one of two populations, and one look at its imports decides which:

- **Design-system parts** speak the vocabulary of form: `variant`, `size`, `children`, `onClick`. They import nothing from the domain — no domain types, no domain hooks, no cache keys.
- **Domain components** speak the project's language: `member`, `team`, `onInvite`. They import the domain freely, compose design-system parts freely, and live with the feature or entity they serve.

There is no third population. Fetching is not an identity and "container" is not a kind: a domain component may render markup, hold interaction state, and read its owners directly. How a value reaches a component is a provisioning decision ([09-state-provisioning.md](09-state-provisioning.md)), not a component kind.

## Rules

**1. New UI is decided in this order: compose → extend → create.**

- **Compose**: when all you need is arrangement, with no new state or invariant, compose existing components at the call site. The default answer is to stop here.
- **Extend**: extend an existing component only when one value is added to a variation axis it already has. Adding a variant value (`variant="destructive"` on `Button`) belongs here.
- **Create**: create a new component only when a new state or invariant appears. Implement its internals by composing existing components.

If you are unsure whether composition is enough, rewrite the component as a composition of existing parts. If after the rewrite the call site has no new convention to remember and no state to carry, the component was only freezing an arrangement; do not create it.

If you are unsure whether to extend or create, decide like this:

- Are all prop combinations still valid after the extension? If a dependent prop appears that is only meaningful when another prop is present, it is a new component. Build `DateRangePicker` instead of bolting `range` onto `DatePicker`.
- Does the existing component's render path fork on an `if`? One line in a variant map is an extension; a forked path is a new component.
- Is the existing name still accurate at the call site? Is-a means extend; uses-a means create.
- Still unsure? Choose create. A wrong new component is duplication, easy to merge later; a wrong extension contaminates every existing call site and is hard to undo.

```tsx
// Bad: a new component disguised as an extension.
// endValue and onEndChange are dependent props, meaningful only when range is set, and the render path forks
function DatePicker({ value, onChange, range, endValue, onEndChange }: DatePickerProps) {
  if (range) {
    // a separate render path coordinating two dates
  }
  // single-date path
}

// Good: an extension. One value joins a variation axis, and every prop combination stays valid
const buttonVariants = cva(base, {
  variants: {
    variant: {
      default: "...",
      destructive: "bg-destructive text-destructive-foreground",
    },
  },
});

// Good: a new component. It owns a new state, the coordination of two dates, and its internals compose existing parts
function DateRangePicker({ value, onChange }: DateRangePickerProps) {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button variant="outline">{formatRange(value)}</Button>
      </PopoverTrigger>
      <PopoverContent>{/* internals coordinating start and end dates, composed from existing parts */}</PopoverContent>
    </Popover>
  );
}
```

**2. The moment a prop is only received and passed straight down, that spot is restructured. Composition through children is the default remedy; when composition cannot reach the reader, choose the transport with the ladder in [09-state-provisioning.md](09-state-provisioning.md).** This rule is about props that merely pass through app components. Spreading `...props` into a DOM element or an underlying primitive is not covered.

```tsx
// Bad: Layout and Sidebar never use user; they only pass it along
function Layout({ user }: { user: User }) {
  return <Sidebar user={user} />;
}
function Sidebar({ user }: { user: User }) {
  return <UserMenu user={user} />;
}

// Good: compose the component that uses user at the place that has it
<Layout>
  <Sidebar>
    <UserMenu user={user} />
  </Sidebar>
</Layout>
```

**3. A component owns no outer margin. Spacing belongs to the parent that composes it.** The moment the root carries a `margin`, the component is welded to one particular arrangement and composition breaks.

```tsx
// Bad: the component decides its own placement
function CommentComposer() {
  return <form className="mt-6">…</form>;
}

// Good: the parent owns spacing through gap
<div className="flex flex-col gap-6">
  <CommentList />
  <CommentComposer />
</div>
```

**4. Dependencies point one way: a design-system part never imports the domain.**

Domain components import design-system parts; the reverse is contamination. A design-system part that needs domain-specific content receives it through composition — children, slots, callbacks — never through an import. The moment a part imports a domain type, every screen that uses it carries that domain, and the part can no longer be judged by its form alone. The check is mechanical: one look at the import list.

```tsx
// Bad: a design-system part imports the domain. Every consumer of Avatar now carries Member
import type { Member } from "@/features/team/contracts";
function Avatar({ member }: { member: Member }) {
  return <img src={member.avatarUrl} alt={member.name} />;
}

// Good: the part speaks form; the domain arrives at the call site
function Avatar({ src, alt }: { src: string; alt: string }) {
  return <img src={src} alt={alt} />;
}
<Avatar src={member.avatarUrl} alt={member.name} />;
```

**5. Every kind of shared code has one home; the design system is the home for components.**

A component moves into the design system only when all three are true: it is domain-free by rule 4's test, more than one context actually uses it, and it is a component by rule 1's bar — a state, an invariant, or a variation axis of its own, not a frozen arrangement. When you are unsure whether something qualifies, it does not, yet. Leave it in its feature; a second copy is cheaper than a wrong promotion.

Domain-free code that is not a component — a hook, a formatter, a shared client — promotes the same way, minus the component test. Its home is the repo's precedent for that kind; a missing home is surfaced, not improvised.

When reuse pressure lands on a domain component, promotion splits it along the populations: the form is stripped into a design-system part, and each context keeps its own thin domain component. Promoting the domain component whole means every new context adds a prop or a conditional, until the component belongs to no one.

How and when to promote is covered in [duplication-and-promotion](../shared/duplication-and-promotion.md). This rule only fixes what makes a place a home and what is allowed in.

```tsx
// Bad: promoted whole. Each context that adopted the card left a prop behind
function MemberCard({ member, showRole, compact, isSearchResult }: MemberCardProps) { /* … */ }

// Good: the form moved to the design system; each context keeps its own thin domain component
function ProfileCard({ avatar, title, meta }: ProfileCardProps) { /* … */ } // design system
function MemberCard({ member }: { member: Member }) {
  return <ProfileCard avatar={member.avatarUrl} title={member.name} meta={member.role} />;
}
```

**6. A domain prop is introduced by real use, never by anticipation.**

The default form of a domain component has no domain props: it reads its owners where it stands ([09-state-provisioning.md](09-state-provisioning.md)). A prop that a single caller fills with the value the component could read itself is not an interface; it is indirection. A domain value earns its place as a prop in exactly two situations: the parent generates structure from data it already holds (a list handing each row its item), or a second real consumer arrives that feeds different data through the same rendering (a draft preview, a story). Do not split a component into a fetching shell and a rendering body for a consumer that has not arrived.

```tsx
// Bad: a fetching shell and a rendering body, split for a second consumer that never came
function MemberPanelContainer() {
  const teamId = useTeamIdParam();
  const { data: team } = useTeam(teamId);
  return <MemberPanelView team={team} />;
}

// Good: the default form reads its owners where it stands
function MemberPanel() {
  const teamId = useTeamIdParam();
  const { data: team } = useTeam(teamId);
  // …
}

// Good: the parent generates structure from data it already holds; each row reads its prop
{members.map((m) => (
  <MemberRow key={m.id} member={m} />
))}
```

**7. Files cohere by what they are about. A feature's code lives in the feature's folder; only domain-free code coheres by kind.**

The two populations have two homes. Design-system parts — domain-free by rule 4's test — cohere by kind, in the design system. Domain code — components, hooks, clients, contracts that speak the project's language — coheres by the feature or entity it serves, and everything one component owns (its hook, its test, its types) colocates next to it. Slicing a feature across top-level role buckets (`components/`, `hooks/`, `api/`) fragments it: following one feature's data flow becomes a tour of the directory tree, and each bucket is a drawer with no admission bar ([duplication-and-promotion](../shared/duplication-and-promotion.md)). New code lands where its feature already lives; a second parallel home for the same feature is a fork.

```
// Bad: one feature sliced across role buckets; its data flow spans four directories
src/components/MemberPanel.tsx
src/hooks/use-members.ts
src/api/members-client.ts
src/types/member.ts

// Good: the feature is the home; roles are just files inside it
src/features/team/
  MemberPanel.tsx
  MemberPanel.test.tsx
  use-members.ts
  members-client.ts
  contracts.ts
src/components/ui/          // domain-free parts cohere by kind: the design system
```
