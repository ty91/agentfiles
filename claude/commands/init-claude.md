---
description: Generate a well-crafted CLAUDE.md file for this project
---

Analyze this codebase and create a CLAUDE.md file following these strict guidelines:

## Core Principles

1. **Keep it minimal**: Target under 60 lines, never exceed 300 lines
2. **Only universal rules**: Include only instructions that apply to EVERY task in this codebase
3. **No code snippets**: Use `file:line` references instead of embedding code

## Required Sections

### 1. WHAT (Project Overview)
- Tech stack (languages, frameworks, key dependencies)
- Project structure (brief directory map)
- Key entry points

### 2. WHY (Purpose)
- What this project does in 1-2 sentences
- Core domain concepts (if any)

### 3. HOW (Workflows)
- Package manager commands (install, build, test, lint)
- How to run the project locally
- Any critical commands developers must know

## Progressive Disclosure

If detailed documentation exists or is needed, create an `agent_docs/` directory structure and reference it in CLAUDE.md:
```
agent_docs/
  ├── architecture.md
  ├── testing.md
  └── conventions.md
```

Only list these files with one-line descriptions. Let Claude read them when needed.

## Do NOT Include

- Code style rules (use linters instead)
- Database schemas or API specifications
- Task-specific or situational instructions
- Boilerplate or auto-generated content
- Obvious instructions that any senior developer would know

## Output Format

Return ONLY the CLAUDE.md content, ready to be saved directly to the file. No explanations or meta-commentary.
