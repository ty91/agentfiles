# UI Verification

Render the smallest practical scope that contains the user behavior. A component may suffice; include the router, parent, or store when those connections matter.

## Input and state

- Find elements by accessible role and name, then exercise input, clicks, and keyboard behavior.
- When a component's input/output contract is the target, checking emitted values or callbacks can be appropriate. This does not replace verification of its connection to a parent.
- Test transformations or calculations directly when they have many boundary cases. Do not extract every hook or component behavior into a pure function just to create tests.
- Select loading, success, empty, error, and recovery states relevant to the change. Control ordering when stale responses or duplicate submissions are risks.
- Check important effects as well as state indicators. For example, confirm that a successful-save indication agrees with the submitted data.

## Test environment

Use existing tools to control network responses. MSW, a local substitute server, or browser request interception can each fit the environment. Keep fixtures aligned with the contract and verify actual server connections separately where needed.

A DOM environment does not establish real layout, codec support, OS clipboard behavior, or complete IME behavior. Add browser or manual checks when these are at risk. Synthetic composition events do not verify the entire real IME input path.

For styling or copy changes, inspect important presentation and interactions. Focused screenshots can be useful for visual comparisons. A broad DOM or text snapshot is not a substitute for behavioral verification.

Wait for observable conditions such as a displayed result or completed request. Do not hide unstable tests by increasing arbitrary delays.
