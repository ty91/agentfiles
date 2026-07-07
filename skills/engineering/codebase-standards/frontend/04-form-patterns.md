# Form Patterns

A form is a procedure for transferring ownership. Borrow the fact as a draft, refine it through validation, and return it at submit.

## Rules

**1. A form has exactly two pieces of state: the draft and the submit transition.** Validity, dirtiness, submittability, and whether to show errors all derive from these two and are never stored. Duplicate-submit prevention also derives from the submit transition.

```tsx
// Bad: derived values stored as state, one synchronization point per field
const [email, setEmail] = useState("");
const [role, setRole] = useState("");
const [isValid, setIsValid] = useState(false);
const [isDirty, setIsDirty] = useState(false);
const [isSubmitting, setIsSubmitting] = useState(false);
const [errorMessage, setErrorMessage] = useState("");

// Good: two pieces of state; everything else derives
const [draft, setDraft] = useState(initialDraft);
const [submit, setSubmit] = useState<SubmitState>({ status: "idle" });
const validation = inviteSchema.parse(draft);
const canSubmit = validation.ok && submit.status !== "submitting";
```

**2. Validation is owned by one schema. Data that passes validation earns a narrower type.** Validation logic scattered across fields or handlers is a violation.

```tsx
// Bad: validation scattered through the handler, and passing it leaves the type as wide as before
function handleSubmit() {
  if (!draft.email.includes("@")) return setError("Please enter a valid email");
  if (draft.role === "") return setError("Please select a role");
  sendInvite(draft); // still { email: string; role: string }
}

// Good: the schema owns it, and what passes becomes a narrow type
function handleSubmit() {
  const result = inviteSchema.parse(draft);
  if (!result.ok) return setSubmit({ status: "error", fields: result.errors });
  sendInvite(result.value); // the Invite type. The validated fact is engraved in the type
}
```

**3. When validation is shown is fixed by one policy: quiet before the first submit, and a field that failed a submit re-alerts the moment it is edited.** Field errors returned by the server appear in the same place, the same way. As far as display is concerned, an error's origin is meaningless. Do not reinvent timing per form.

```tsx
// Bad: the timing policy leaks out as a touched map, reinvented per form
const [touched, setTouched] = useState<Record<string, boolean>>({});
<Input onBlur={() => setTouched((t) => ({ ...t, email: true }))} />;

// Good: whether to show derives from the submit transition
const fieldErrors = submit.status === "error" ? submit.fields : {};
```

**4. Fields are assembled from one standard anatomy.** A field is a composition of Label, Control, and Error parts. Do not reinvent this markup per form.

```tsx
// Bad: every field reinvents the markup
<div className="space-y-1">
  <label htmlFor="email" className="text-sm font-medium">Email</label>
  <input id="email" className="…" />
  {fieldErrors.email && <p className="text-sm text-destructive">{fieldErrors.email}</p>}
</div>

// Good: the anatomy is defined once; a field is assembly
<Field name="email" error={fieldErrors.email}>
  <FieldLabel>Email</FieldLabel>
  <FieldControl>
    <Input value={draft.email} onChange={(e) => setField("email", e.target.value)} />
  </FieldControl>
  <FieldError />
</Field>
```

**5. When a form gets heavy, the remedy is narrower subscriptions, not decomposed state.** Only a component that needs the whole form is entitled to subscribe to the whole form. A field subscribes to its own slice. Splitting the draft into several states as an optimization violates rule 1.

```tsx
// Bad: splits the draft into per-field state because re-renders feel expensive
const [email, setEmail] = useState("");
const [role, setRole] = useState("");
// validation and submit now have to reassemble the scattered pieces

// Good: keep one draft, narrow the subscription
const email = useDraftField("email"); // this component re-renders only when email changes
```
