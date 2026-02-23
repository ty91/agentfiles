# Browser CLI

Daemon-backed browser control for web automation via accessibility snapshots and element refs.

## Core Loop

```bash
# 1. Start session
browser start --headless

# 2. Open a page
browser open "https://example.com"

# 3. Get LLM-friendly snapshot (accessibility tree with refs like e12, e497)
browser snapshot

# 4. Interact using refs from the snapshot
browser click e14
browser type e22 "search query"
browser press Enter

# 5. Re-snapshot to see updated state
browser snapshot

# 6. Repeat 4-5 until done

# 7. Stop session
browser stop
```

**Rules:**
- Always `snapshot` after any interaction — refs change when the page mutates.
- Refs (e.g. `e12`) are ephemeral. Never reuse refs across snapshots.
- Snapshot output is truncated at 1500 lines. Use `scrollintoview` + re-snapshot for long pages.

## Session Lifecycle

| Command | Purpose |
|---|---|
| `browser start --headless` | Start headless session (default for agents) |
| `browser start --headed` | Start headed session (visible browser for debugging) |
| `browser status` | Check if session is running |
| `browser stop` | End session and close browser |
| `browser daemon start` | Start daemon (auto-started on first command) |
| `browser daemon status` | Check daemon health |

## Navigation & Tabs

```bash
browser open "https://example.com"       # Open URL in a NEW tab
browser navigate "https://example.com"    # Navigate CURRENT tab to URL

browser tabs                              # List tabs (1-based index)
browser tab select 2                      # Switch to tab 2
browser tab close 3                       # Close tab 3
```

Tabs use **1-based indexing**. `open` creates a new tab; `navigate` reuses the selected tab.

## Observation

```bash
browser snapshot              # Accessibility tree with element refs (primary)
browser observe state         # Quick page state: URL, title, loading status
browser screenshot            # Save screenshot to ~/.browser/screenshots/
browser screenshot --full     # Full-page screenshot
```

- `snapshot` — primary observation method. Use to find refs and understand page structure.
- `observe state` — lightweight URL/title check without the full tree.
- `screenshot` — visual verification. Read the saved file path from the output.

## Interaction

### Ref-based (use refs from `snapshot`)

```bash
browser click e14             # Click
browser doubleclick e14       # Double-click
browser hover e14             # Hover (tooltips, dropdowns)
browser type e22 "hello"      # Type text (APPENDS to existing content)
browser press Enter           # Press key (Enter, Tab, Escape, etc.)
browser scrollintoview e50    # Scroll element into viewport
```

### Form filling (use CSS selectors)

> **`type` vs `element fill`**: `type` simulates keystrokes and **appends**. `element fill` **clears first**, then sets the value. Use `element fill` when replacing existing text.

```bash
# Fill single field (clears existing value)
browser element fill --uid "#email" --value "user@example.com"

# Fill multiple fields at once
browser element fill-form --entries '[{"selector":"#email","value":"user@example.com"},{"selector":"#pass","value":"secret"}]'
```

## Waiting

Use wait commands before `snapshot` on pages with async loading (SPAs, AJAX).

```bash
browser page wait-text --text "Results loaded"
browser page wait-selector --selector ".results-container"
browser page wait-url --pattern "/dashboard"
```

## Tips

- **Snapshot after every action.** Page DOM changes after clicks, fills, navigation. Always re-snapshot for fresh refs.
- **Wait on dynamic pages.** SPAs need `page wait-text` / `page wait-selector` before snapshot shows final state.
- **Dialogs block interaction.** Handle with `browser dialog handle --action accept` (or `dismiss`) before continuing.
- **JSON output.** Add `--output json` to any command for structured output.
- **Discovery.** Run `browser <command> --help` for full options, `--describe` for schema/examples.

## Advanced Commands

```bash
# File upload
browser element upload --uid "#file-input" --file /path/to/file.pdf

# Drag and drop
browser element drag --from "#source" --to "#target"

# JavaScript evaluation
browser runtime eval --function "() => document.title"

# Dialog handling
browser dialog handle --action accept
browser dialog handle --action dismiss --prompt-text "cancel reason"

# Console / Network inspection
browser console list
browser console wait --pattern "error"
browser network list
browser network wait --match "/api/data" --method GET

# Coordinate-based input (prefer ref-based commands when possible)
browser input click --x 100 --y 200
browser input scroll --dy -300
```

For full options: `browser <command> --help`
