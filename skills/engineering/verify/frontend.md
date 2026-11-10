# UI Verification

- A DOM environment does not establish real layout, clipboard, codec, or IME behavior. Synthetic composition events do not verify real IME input. Check these in a browser when at risk.
- A broad DOM or text snapshot does not replace behavioral assertions.
- Control response order when stale responses or duplicate submissions are risks.
- Confirm that a success indication agrees with the data actually submitted.
