# Thin post-edit checks

This is a lightweight verification policy inspired by Factory's `post-edit-check`, without turning it into hard automation.

## Default rule

After editing, run the smallest relevant check that gives confidence in the change.

Prefer targeted verification over full-project enforcement.

## How to choose checks

### Formatting

Run the formatter only for files you changed when the repo supports it.

### Linting

Run the narrowest lint command that covers the edited files or package.

### Typechecking

Run the smallest useful typecheck for the affected package, module, or project.

### Tests

Run the closest test that exercises the changed behavior.
If no targeted test exists, use the smallest broader test that gives confidence.

## Boundary-first validation

Prioritize checks at system boundaries:

- user input
- parsing and serialization
- API requests and responses
- persistence and file I/O
- auth, permissions, and security-sensitive code

Internal refactors usually need focused regression checks, not blanket enforcement.

## Practical examples

- Single TypeScript file: format + targeted lint + relevant typecheck or test
- Python module: formatter/linter + focused test for the touched behavior
- Shell or dotfile change: syntax check or direct command validation when available
- Config-only change: validate by loading or using the affected tool if possible

## Escalation

Start small. If the targeted check fails in a way that suggests wider impact, expand to package-level or project-level verification.

## Anti-patterns

- Running the whole test suite by default for tiny edits
- Skipping checks on behavior changes
- Treating formatting-only success as proof of correctness
- Adding enforcement that slows down simple work without improving outcomes
