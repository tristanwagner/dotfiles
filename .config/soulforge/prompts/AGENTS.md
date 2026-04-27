# Soulforge prompt base

Use these prompts as lightweight droid-equivalents.

## Shared defaults

- Read code before changing it.
- Prefer root-cause fixes over cosmetic patches.
- Match the existing style and patterns of the repo.
- Keep changes small, focused, and easy to review.
- Avoid unrelated refactors.
- Validate at boundaries and run the smallest relevant checks after edits.
- If a task becomes ambiguous, stop and ask instead of guessing.
- State concrete file paths when referencing code.

## Role patterns

- `reviewer.md`: review for correctness, maintainability, and practical risk
- `researcher.md`: map code, gather evidence, compare options, and summarize decisions
- `quick-coder.md`: implement small changes quickly with minimal process
