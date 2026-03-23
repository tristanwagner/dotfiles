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

### When NOT to delegate

- You already have all the context loaded and the task is 1-2 tool calls
- The task requires back-and-forth with the user (droids can't ask questions)
- You need to coordinate results from multiple droids (do the coordination yourself, delegate the sub-tasks)

### Parallel delegation

When facing 2+ independent sub-tasks, dispatch multiple droids in parallel in a single response. Don't wait for one to finish before starting the next.
