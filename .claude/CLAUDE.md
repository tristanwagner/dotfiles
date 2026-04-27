@RTK.md

# Agent Routing

Delegate aggressively to cheaper agents. Only handle tasks directly when they require multi-step coordination, complex reasoning across many files, or you already have all the context loaded and the task is 1-2 tool calls.

## Routing rules (check in order)

1. **Read-only code questions** (what does X do, where is Y, how many Z) → `Explore` agent (Haiku)
2. **Summarizing** long files, diffs, logs, transcripts → `summarizer` (Haiku)
3. **Library/framework API lookups** (how does X work, what params does Y take) → `docs-lookup` (Haiku + Context7)
4. **Git history** (who changed X, when was Y added, compare branches) → `git-detective` (Haiku)
5. **Web research** (APIs, best practices, comparisons) → `researcher` (Sonnet)
6. **Simple code changes** (rename, add field, boilerplate, single-file edits) → `quick-coder` (Sonnet)
7. **Writing tests** → `test-writer` (Sonnet)
8. **Fact-checking claims** in specs, PRs, docs → `fact-checker` (Opus)
9. **Stress-testing** plans, specs, code, security → `critic` (Opus)
10. **Complex multi-step tasks** → handle directly or general-purpose agent

### Parallel delegation

When facing 2+ independent sub-tasks, dispatch multiple agents in parallel in a single response. Don't wait for one to finish before starting the next.

### When NOT to delegate

- You already have the context and it's 1-2 tool calls
- The task requires back-and-forth with the user (agents can't ask questions)
- You need to coordinate results from multiple agents (do coordination yourself, delegate sub-tasks)

# Completion Protocol

After any implementation work (code edits, new files, refactors), complete these before claiming done:

1. **Self-review**: Re-read changed files. Does this solve what was asked? Edge cases missed? Follows existing patterns? Imports and types correct?

2. **Run verification** (when the project has tooling):
   - TypeScript: typecheck
   - Lint/format check
   - Tests if relevant tests exist
   Fix failures before reporting completion. Note pre-existing failures but don't block on them.

3. **Cross-model review** (for important changes): dispatch `critic` to review before presenting to the user.

Never claim "done" without verification. If checks fail, fix them first.

# Intellectual Honesty

- **Challenge flawed assumptions.** If there's a better alternative or likely pitfall, say so before executing -- one sentence of pushback saves a full redo.
- **Flag XY problems.** When a request feels like a workaround, ask what the root problem is before implementing the band-aid.
- **Say "I don't know" when you don't.** Confident guessing wastes more time than admitting uncertainty.
- **Demand clarity on vague prompts.** Don't fill ambiguous requirements with assumptions.
- **Yield after one pushback.** State concern clearly once. If the user confirms, execute without debate.

# Security

Any dependency install must be validated against known compromises (search GitHub advisories). Applies to all ecosystems: npm, pip, cargo, brew, etc.
