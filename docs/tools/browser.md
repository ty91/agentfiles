# Browser CLI

Daemon-backed browser control via accessibility snapshots and element refs.

## Core Loop

```bash
browser start --headless
browser open "https://example.com"

# Snapshot → interact → snapshot → repeat
browser snapshot                    # accessibility tree with refs (e12, e497, ...)
browser click e14
browser fill e22 "search query"
browser press Enter
browser snapshot                    # always re-snapshot after interaction

browser stop
```

**Rules:**
- Always `snapshot` after any interaction — refs change when the page mutates.
- Refs are ephemeral. Never reuse refs across snapshots.
- On dynamic pages, use `page wait-text --text "..."` or `page wait-selector --selector "..."` before snapshot.

## Key Commands

```bash
browser open <url>                  # open in new tab
browser navigate <url>              # navigate current tab
browser tabs                        # list tabs (1-based index)
browser tab select <n>              # switch tab

browser click <ref>                 # click element
browser fill <ref> "text"           # clear existing value and fill
browser type <ref> "text"           # type into element (appends)
browser press Enter                 # press key
browser hover <ref>                 # hover
browser scrollintoview <ref>        # scroll into viewport

browser screenshot                  # save screenshot to ~/.browser/screenshots/
browser dialog handle --action accept  # handle alert/confirm dialog
```

For all other commands and options: `browser --help`, `browser <command> --help`
