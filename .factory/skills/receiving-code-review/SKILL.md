# Receiving Code Review

## Overview

Systematic approach to responding to code review feedback. Ensures every comment is properly understood, evaluated, and addressed without performative agreement.

## When to Use

- Responding to PR review comments
- When the user shares code review feedback to address
- After running `/review` and getting findings to act on
- When a reviewer (human or agent) has flagged issues

## When NOT to Use

- Writing a code review (use the `code-review` skill instead)
- General code improvements not tied to review feedback

## Protocol

### 1. Read all feedback first

Read every comment before responding to any. Understand the full picture:
- Are there themes across comments?
- Do some comments conflict with each other?
- What's the reviewer's main concern?

### 2. Categorize each comment

For each review comment:

| Category | Action |
|----------|--------|
| **Bug/correctness** | Fix. Verify with test. |
| **Security concern** | Fix. Prioritize above all else. |
| **Design/architecture** | Evaluate carefully. May need discussion. |
| **Style/convention** | Follow project conventions. Don't argue style. |
| **Nit/optional** | Fix if trivial. Note if you disagree. |
| **Question** | Answer concisely with code references. |
| **Wrong/misunderstanding** | Explain respectfully with evidence. |

### 3. Evaluate before agreeing

**Do NOT performatively agree.** For each suggestion:

- Is this actually an improvement, or just different?
- Does this follow the project's existing patterns?
- Does this introduce unnecessary complexity (YAGNI)?
- Is the reviewer seeing something you missed, or missing context you have?

If you disagree:
- Explain your reasoning with specific evidence (code, tests, docs)
- Propose an alternative if the concern is valid but the solution isn't
- Be open to being wrong -- the reviewer may have context you lack

### 4. Implement fixes

For each accepted comment:
1. Make the change
2. Verify it doesn't break anything (run tests, typecheck)
3. If the fix is non-obvious, add a brief comment explaining why

Group related changes into logical commits.

### 5. Respond to the review

For each comment thread:
- **Accepted**: "Fixed. [brief description of what changed]"
- **Accepted with modification**: "Addressed differently -- [explanation]. [what you did instead]"
- **Disagreed**: "[Your reasoning]. [Evidence]. Open to discussion."
- **Question**: "[Concise answer with code reference]"

### 6. Self-check before marking resolved

- [ ] Every comment has been addressed or responded to
- [ ] All changes compile and pass tests
- [ ] No unrelated changes snuck in
- [ ] Commit messages reference the review where relevant

## Anti-patterns

- Saying "good catch!" to everything (performative agreement)
- Making changes you don't understand just because a reviewer asked
- Arguing style preferences when the project has conventions
- Ignoring comments without responding
- Making unrelated "improvements" while addressing review

## Quality Gates

- [ ] Every review comment addressed or responded to
- [ ] No performative agreement -- each response has substance
- [ ] Tests pass after all changes
- [ ] No unrelated changes included

## Exit Protocol

```
---HANDOFF---
- Comments received: [count]
- Fixed: [count]
- Disagreed (with reasoning): [count]
- Tests status: [passing/failing]
- Unresolved: [threads still open or "none"]
---
```
