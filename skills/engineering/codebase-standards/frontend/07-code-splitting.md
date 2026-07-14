# Code Splitting

Users download only as much as the screen they are looking at. A static import claims "needed at the same time as me"; a dynamic import claims "fetched on request"; splitting is the act of honestly declaring later things as later. And the cheapest chunk is the code you never wrote.

## Rules

**1. There are exactly two split boundaries: the screen, and the heavy island behind an interaction. Do not split finer.**

- **Screen (route)**: the default unit of splitting. Users consume screen by screen, so they download screen by screen. The route table imports every screen lazily, and the entry chunk keeps only what draws the first screen.
- **Island**: something heavy that is not needed until opened. Rich editor, chart, PDF viewer. The opening interaction is the start of the download.
- **Nothing finer**: one chunk is one round trip. Splitting small components costs more in round trips and loading states than the bytes it saves.

The consumer declares the split. The route table, or the opening site, writes the dynamic import. A module does not know it is being split.

```tsx
// Bad: the entry statically pulls every screen. An inbox user downloads the admin screens too
import { AdminDashboard } from "./admin/AdminDashboard";
import { Inbox } from "./inbox/Inbox";

// Bad: over-splitting. One button buys one round trip
const Button = lazy(() => import("@/components/ui/button"));

// Good: the screen is the unit. The route table declares the split
const Inbox = lazy(() => import("./inbox/Inbox"));
const AdminDashboard = lazy(() => import("./admin/AdminDashboard"));

// Good: for a heavy island, the opening interaction starts the download
const ChartPanel = lazy(() => import("./reports/ChartPanel"));
{isChartOpen && <ChartPanel />}
```

**2. A module that is imported dynamically is imported dynamically by every consumer.**

Bundlers analyze the import graph statically. If even one place imports the module statically, the module returns to the entry chunk and the split is silently void. The build succeeds with no warning, so this must be caught in diffs. Conversely, if a boot-time static consumer is legitimate, the split is fiction; remove the split instead of fixing the mixture.

```tsx
// Bad: one static import silently voids the split
// routes.tsx
const ReportEditor = lazy(() => import("./reports/ReportEditor"));
// reports/ReportList.tsx
import { ReportEditor } from "./ReportEditor"; // the editor returns to the entry chunk

// Good: the second consumer passes through the same boundary
// reports/ReportList.tsx
const ReportEditor = lazy(() => import("./ReportEditor"));
```

**3. An import path points at the module that defines the code. Heavy dependencies may not enter modules shared by several screens.**

A barrel (re-export index) makes one path stand for a crowd of unrelated modules; import one thing and its neighbors ride into the graph. A module with many exports is not a barrel. The problem is re-export, not definition.

A shared module is an entry cost for every screen that imports it. The deciding question is "does a screen that never uses this module pay its weight?" Heavy things live inside the island that uses them, not in the shared layer.

```tsx
// Bad: one index drags in all of its neighbors
// components/ui/index.ts
export * from "./alert-dialog";
export * from "./chart";
// consumer: imported a dialog, and a chart rides into the graph
import { AlertDialog } from "@/components/ui";

// Bad: a shared module every screen passes through pulls in the heavy editor
// shared/text.ts
import { parseRichText } from "@/editor/rich-text";
export function toPlainText(doc: RichDoc) { /* … */ }

// Good: the path points at the defining module
import { AlertDialog, AlertDialogContent } from "@/components/ui/alert-dialog";
```

**4. One boundary, one wait. Code and data depart together at the boundary, and there is one fallback per boundary.**

Splitting creates a new delay. If the component mounts only after the chunk arrives, and only then does the fetch depart, the user waits through two round trips in sequence. Crossing the boundary must launch code and data in parallel. The fallback comes from the standard pattern, one per boundary; do not stack fallbacks inside the boundary so spinners appear layer by layer. When a boundary's delay becomes noticeable, the prescription is preloading on intent signals (link hover, viewport entry), not more fallbacks and not removing the boundary.

```tsx
// Bad: a waterfall. Data cannot depart until the code arrives
const ReportPage = lazy(() => import("./ReportPage"));
// ReportPage.tsx
function ReportPage({ reportId }: { reportId: string }) {
  const { data: report } = useReport(reportId); // the second round trip starts only here
}

// Good: code and data depart together at the boundary
{
  path: "/reports/:id",
  lazy: () => import("./ReportPage"),
  loader: ({ params }) => prefetchReport(params.id),
}
```
