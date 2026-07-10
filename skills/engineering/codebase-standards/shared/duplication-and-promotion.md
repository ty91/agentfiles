# Duplication and Promotion

The moment you are about to write code that already exists somewhere else is a decision point, not a reflex. Shared vocabulary gets promoted to its one qualified home. Coincidental lookalikes stay apart. Silent copies are forbidden. Promotion follows real use, never anticipation. These rules apply to every stack; where each stack's shared home lives is declared in that stack's composition document.

## 1. Treat the second copy as a decision

Code starts local. The first version of anything belongs to the module that needs it, and needs no justification. The moment a second place needs the same thing, you are at a decision point: promote it to the shared home, or copy it on purpose and note where the original lives.

What you may not do is copy silently. Silent copies are how a codebase ends up with seven versions of the same cursor codec, each drifting apart one bugfix at a time.

## 2. Promote what changes together

Two pieces of code are duplicates only when a change to one must also be made to the other. Looking alike is not enough. A validation helper and a formatting helper may share every line today and still be different things, because they will change for different reasons.

So before promoting, ask: if the rule behind this code changes, do both places change? If yes, it is shared vocabulary; promote it. If they would evolve apart, they are not duplicates; keep them separate and let them diverge in peace.

## 3. Promoted code moves to a home, never a drawer

Every kind of shared code has exactly one home, and every home has an admission bar; backend's is the shared kernel in 01-module-composition, and the frontend's are declared in 01-component-composition. Promotion means meeting that bar, and promoting the smallest piece that is actually shared, not the whole file it happens to live in.

Never create a `utils`, `helpers`, `common`, or `misc` folder. A drawer has no admission criteria, so it collects everything and explains nothing. If the code you want to share cannot meet the home's bar, it is not ready to be shared.

## 4. Never fork and rename

Copying a whole module and renaming its symbols does not create a new feature; it creates a second codebase. Every fix must now be found and applied twice, and one day it will not be.

When two features genuinely share most of their behavior, extract the shared part as vocabulary both can use, or keep one module and give it an explicit variation point. If they truly deserve separate code, write the second one from its own requirements, not from the first one's text.

## 5. Do not abstract ahead of need

Promotion follows use; it never anticipates it. Code with one caller stays with its caller, no matter how reusable it looks. Do not design a shared helper for a second user who has not arrived yet.

This is the other half of rule 1, and it matters just as much. A copy is cheap to fix later. A wrong abstraction spreads its mistake to everyone who adopted it, and unwinding it costs more than the duplication ever did. When in doubt, wait for the second copy; it will tell you what the abstraction should have been.
