# 01. Module Composition

Every piece of code has one right place, and this standard makes that place predictable. All modules share one shape. Decisions live in one layer. Dependencies flow one way. Assembly happens in one place, loudly. Read one module and you can navigate them all; that predictability is worth more than any local improvement.

## The standard anatomy

Every module has the same shape, built from four roles:

- **Surface**: entry points. Parses input, checks authorization, calls the decisions layer, maps responses.
- **Decisions**: the domain layer. Owns every business decision: policies, calculations, state transitions.
- **Data**: persistence. Stores and fetches facts, and nothing else.
- **Contracts**: the types these roles share with each other and with callers.

The codebase also has one **shared kernel**: the single home for vocabulary that all modules use, such as pure types, codecs, and small invariant helpers.

Two things to keep in mind. A module only creates the roles it actually needs; an empty folder helps no one. And no module invents a new role. When a role grows past one file, split it the same way other modules already split that role.

## 1. Keep every module the same shape

A new module copies the shape of the existing ones, so anyone who has read one module can navigate them all. If you believe the shape itself should change, change it for every module in the same change. A shape that only one module follows is not an improvement; it is a dialect.

At the same time, the anatomy is vocabulary, not scaffolding. Never add files or folders just to make a module look complete.

## 2. Only build layers that earn their place

A layer earns its place by isolating something or deciding something. If it only forwards calls, delete it and call the real thing directly. The deletion test decides: imagine the layer gone — if complexity vanishes with it, it was a pass-through; if its complexity reappears spread across every caller, it was earning its keep. The same goes for interfaces with a single implementation, and for wrappers whose name does not match what they hold. A field called `routes` that actually contains a service is a small lie that everyone after you has to un-learn.

## 3. Put decisions in the decisions layer

The surface translates: it parses, authorizes, delegates, and shapes the response. The data layer stores and fetches. Everything that decides, such as whether a transition is allowed, what a value should be, or which policy applies, belongs in the decisions layer.

This cuts both ways. Business branching inside a handler means the decision sits too high. A repository that owns locks, transition checks, or warnings, while the service just normalizes input and wraps errors, means the decision sank too low. An empty middle layer is as much a smell as a fat edge.

## 4. Point dependencies one way

Inside a module, dependencies flow surface → decisions → data → contracts, never backwards. Across modules, depend only on another module's declared public surface. Do not import its internal files, and do not query its tables (see 03-data-access).

If a dependency feels wrong in that direction, the fix is to move the code or the decision, not to insert a middleman layer that launders the import.

## 5. Wire everything in one place, and fail loudly

All modules are constructed and connected at a single assembly root, following one convention with no per-module exceptions. If a required dependency is missing, the application must fail at boot. A route that silently never gets registered is one of the most expensive bugs to find.

The assembly root only wires. If it starts making decisions, those decisions belong in a module (see rule 3).

## 6. Extend before you create

By default, new behavior goes into an existing module. Climb this ladder one step at a time: a new rule inside an existing module, then a subdivision of that module, then a new module. A new module is justified only when it owns its own facts and its own decisions.

Copying an existing module and renaming its symbols is not a new module; it is duplication, and shared/duplication-and-promotion explains what to do instead. The ladder also runs downward: when a module turns into a hub that reaches into everyone else's facts, that is the signal to split it.

## 7. The shared kernel is a home, not a drawer

Code moves into the shared kernel only when all three are true: it makes no domain decisions, its dependencies point only downward, and more than one module actually uses it. When you are unsure whether something qualifies, it does not, yet. Leave it where it is; a second copy is cheaper than a wrong abstraction.

How and when to promote duplicated code is covered in shared/duplication-and-promotion. This document only fixes where the shared home is and what is allowed in.
