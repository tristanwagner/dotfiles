---
name: code-tour
description: Generate guided explanations of code changes with structured diff walkthroughs. Use when reviewing uncommitted changes, explaining complex patches, or understanding change intent and cross-file impact.
---

# Code Tour

## Overview

Generate guided walkthroughs of diffs to explain what changed and why across one or more files. Produces structured, ordered explanations of code changes relative to a base commit.

## When to Use

- Walking through uncommitted changes before review
- Explaining a complex patch in plain language
- Understanding change intent and cross-file impact
- Preparing PR descriptions or change summaries
- Onboarding reviewers to unfamiliar areas of the codebase

## When NOT to Use

- Exploring codebase architecture without a diff (use walkthrough instead)
- Simple single-file reads (use Read directly)
- Modifying or editing code

## Protocol

### 1. Identify the base revision

Determine the git commit hash to diff against. This is typically:
- `HEAD` for uncommitted working changes
- A branch point commit for feature branch changes
- A specific commit hash provided by the user

Run `git log --oneline -10` if needed to find the right base.

### 2. Generate the raw diff

```bash
git diff <baseRevision>
```

Review the diff to understand the scope of changes — which files were modified, added, or deleted.

### 3. Build the tour narrative

For each logical change group, create a tour stop:

- **Order stops by the change story** — not alphabetically, but in the order that makes the change easiest to understand
- **Group related file changes** — if a type change in `types.ts` drives changes in `handler.ts` and `test.ts`, present them together
- **Explain intent, not just mechanics** — "Added rate limiting to the API endpoint" not "Added an if statement on line 42"

### 4. Highlight cross-file relationships

Identify and call out:
- Type/interface changes that ripple across files
- Import changes that signal new dependencies
- Test changes that validate the production code changes
- Schema changes that require migration steps

### 5. Call out risk areas

Flag anything that warrants extra review attention:
- Breaking API changes
- Security-sensitive modifications
- Performance-impacting changes
- Missing test coverage for new code paths
- Database migration requirements

### 6. Structure the output

For each tour stop:

| Section | Content |
|---------|---------|
| **Title** | Short description of the change |
| **Files** | List of files involved |
| **What changed** | Plain-language explanation |
| **Why** | Intent and motivation |
| **Risk** | Any concerns or follow-up needed |

## Optional Focus Areas

The tour can be focused on a specific concern:
- **Architecture impact** — how the change affects system structure
- **API behavior** — changes to public interfaces and contracts
- **Risky changes** — security, performance, or correctness concerns
- **Specific subsystem** — filter to changes in a particular module

## Quality Gates

- [ ] All modified files accounted for in the tour
- [ ] Changes ordered by narrative flow, not file path
- [ ] Cross-file relationships identified and explained
- [ ] Risk areas flagged with specific concerns
- [ ] Intent ("why") explained, not just mechanics ("what")

## Exit Protocol

```
---HANDOFF---
- Base revision: [commit hash]
- Files changed: [count]
- Tour stops: [count]
- Risk areas: [list or "none"]
- Follow-up checks: [list or "none"]
---
```
