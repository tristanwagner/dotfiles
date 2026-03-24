# PR Prep

## Overview

Pre-flight checklist before creating a pull request. Runs all checks, catches common issues, and generates a PR description from the diff.

## When to Use

**Always** before creating a PR or when asked to "prep for PR", "review before merging", or "get this ready for review".

**Skip when:** Just committing WIP, or the user explicitly says to skip checks.

## Protocol

### 1. Gather the diff

```bash
git diff main...HEAD --stat
git diff main...HEAD
git log main..HEAD --oneline
```

If the base branch isn't `main`/`master`, ask which branch to compare against.

### 2. Run project checks

Run these in order, fix issues before proceeding:

```bash
# Typecheck
pnpm check-types

# Lint + format
pnpm check

# Tests
pnpm test
```

If any fail, fix them before continuing. If a failure is pre-existing (not from this branch's changes), note it but proceed.

### 3. Scan for leftover debug artifacts

Search the diff for common mistakes:
- `console.log` / `console.debug` (not in intentional logging)
- `debugger` statements
- `// TODO` or `// HACK` or `// FIXME` added in this PR
- `.only` in test files (`.it.only`, `.describe.only`, `.test.only`)
- Hardcoded `localhost` URLs
- Commented-out code blocks (more than 3 lines)
- `any` type annotations added (in TypeScript)

Report findings. Don't auto-fix -- let the user decide what's intentional.

### 4. Check for missing pieces

- New exports: are they re-exported from index files if needed?
- New DB schema changes: was a migration generated?
- New API endpoints: do they have error handling?
- New components: do they have tests?
- New env vars: are they documented / added to .env.example?

### 5. Generate PR description

Based on the diff and commit history, generate a PR description:

```markdown
## What

[1-2 sentence summary of what changed and why]

## Changes

- [Bullet list of concrete changes, grouped by area]

## Testing

- [How this was tested / what tests were added]

## Notes

- [Anything reviewers should pay attention to]
```

### 6. Report

Present the full report:
- Checks passed/failed
- Debug artifacts found
- Missing pieces
- Generated PR description (ready to copy)

## Quality Gates

- [ ] `pnpm check-types` passes
- [ ] `pnpm check` passes (biome lint + format)
- [ ] `pnpm test` passes
- [ ] No `debugger` statements in diff
- [ ] No `.only` in test files
- [ ] No hardcoded secrets or localhost URLs in production code
- [ ] PR description generated

## Exit Protocol

```
---HANDOFF---
- PR status: [ready / needs fixes]
- Checks: [all passed / list failures]
- Issues found: [count and summary, or "none"]
- PR description: [generated above]
- Unresolved: [blockers or "none"]
---
```
