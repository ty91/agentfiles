# Compound Components

A deep UI interface hides implementation complexity while making valid structure visible through composition.

- Minimize what callers must know, not necessarily the number of entry points.
- Expose structural variation as composable parts instead of configuration props.
- A compound component may expose several parts and still provide a deep interface.
- Use one when a parent coordinates context and callers assemble parts into valid structures.

## Rules

**1. Structural variation is composition; appearance variation is a variant axis.** Do not compress structural choices into boolean props. Booleans that represent state, such as `disabled` or `isLoading`, are fine.

```tsx
// Bad: structural variation is hidden behind props
<Card title="Billing history" showFooter footerAlign="right" />

// Good: the valid structure is visible at the call site
<Card>
  <CardHeader>
    <CardTitle>Billing history</CardTitle>
  </CardHeader>
  <CardFooter className="justify-end">…</CardFooter>
</Card>
```

**2. Export parts as individual components with flat names.** Use `CardHeader` and `CardFooter`, not dot notation such as `Card.Header` and `Card.Footer`.

**3. Adding a part to an existing compound component is an extension when it adds another valid structural position to the same concept.** For example, adding `CardAction` to `Card` extends `Card`. If the change introduces new state, a new invariant, dependent props, or a forked render path, create a new component instead.

**4. Context carries instance-scoped coordination shared by compound parts.** Use a scoped store only when high-frequency changes require granular subscriptions.

**5. Parts that form one compound component may live in and be exported from one defining module.** Multiple exports from that module do not make it a barrel; the parts are one concept intended to be used together. Import them from the module that defines them rather than through a re-export index.
