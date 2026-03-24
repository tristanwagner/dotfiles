# Agent Guidelines

## Droid Routing — Token Optimization

The primary agent is expensive (Opus Max). Delegate aggressively to cheaper droids whenever possible. Only handle tasks yourself when they require multi-step coordination, complex reasoning across many files, or tool calls that droids can't do.

### Routing rules (check in order)

1. **Read-only questions about code** (what does X do, where is Y defined, how many Z exist)
   → `explorer` (Haiku — cheapest)

2. **Summarizing** long files, diffs, logs, PR descriptions, or transcripts
   → `summarizer` (Haiku — cheapest)

3. **Library/framework API questions** ("how does drizzle findMany work", "what params does X take")
   → `docs-lookup` (Haiku + Context7 MCP — cheapest doc lookups)

4. **Git history questions** (who changed X, when was Y added, what did last commits do)
   → `git-detective` (Haiku — cheapest, uses git commands)

5. **Web lookups** — general research, blog posts, comparisons, "how do I do X"
   → `researcher` (Sonnet — has Context7, Exa, and grep.app MCP tools)

6. **Simple code changes** — rename, add a field, write boilerplate, small refactors, single-file edits
   → `quick-coder` (Sonnet)

7. **Design/plan review** — "does this look right", "what am I missing", sanity check a spec
   → `second-opinion` (GPT-5.4 — cross-model perspective)

8. **Stress-testing** — find holes in a spec, edge cases in code, security review
   → `critic` (Opus with high thinking)

9. **Complex multi-step tasks** — needs coordination, multiple file edits, or context the primary agent already has
   → `worker` (Opus) or handle directly

10. **Writing tests** for existing code, adding test coverage
    → `test-writer` (Sonnet — knows vitest, testing-library, project patterns)

11. **DB schema changes** — edit schema, generate migration, review SQL
    → `migrator` (Sonnet — end-to-end Drizzle workflow)

12. **Improving skills/droids/hooks** — review quality, fix issues, iterate
    → `skill-improver` (Sonnet — iterative review loop)

### When NOT to delegate

- You already have all the context loaded and the task is 1-2 tool calls
- The task requires back-and-forth with the user (droids can't ask questions)
- You need to coordinate results from multiple droids (do the coordination yourself, delegate the sub-tasks)

### Parallel delegation

When facing 2+ independent sub-tasks, dispatch multiple droids in parallel in a single response. Don't wait for one to finish before starting the next.

## Completion Protocol — Verification Before Finishing

**After any implementation work** (code edits, new files, refactors), you MUST complete these steps before telling the user you're done:

### 1. Self-review (always)
Before running checks, re-read the files you changed and verify:
- Does this actually solve what was asked?
- Are there obvious edge cases missed?
- Does this follow the project's existing patterns?
- Are imports correct and types sound?

For non-trivial changes (3+ files, new features, architecture changes), invoke the `reflexion` skill for a structured self-critique with complexity triage.

### 2. Run verification (always after code changes)
```bash
pnpm check-types    # TypeScript compilation
pnpm check          # Biome lint + format
pnpm test           # Tests (if relevant tests exist)
```
Fix any failures before reporting completion. If a failure is pre-existing (not from your changes), note it but don't block on it.

### 3. Cross-model review (for important changes)
For features, architecture changes, or security-sensitive code, dispatch a `second-opinion` or `critic` droid to review your work before presenting it to the user.

**Never claim "done" without verification. If checks fail, fix them first.**

## Session Hygiene

### Scope discipline
- One major topic per session. If the user pivots significantly (e.g., from implementing a feature to debugging model config), suggest starting a fresh session.
- If context is getting heavy (50+ tool calls), consider whether a new session would be cleaner.

### Plan persistence
- When a brainstorming or planning session produces a plan, save it to `docs/plans/` or `docs/specs/` so the next session can pick it up.
- Always reference existing specs/plans before starting implementation: check `docs/specs/` and `docs/plans/` first.
