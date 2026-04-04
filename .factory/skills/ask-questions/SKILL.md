---
name: ask-questions
description: Clarify requirements before implementing when requests are underspecified. Use when a task has multiple plausible interpretations or key details are unclear.
---

# Ask Questions If Underspecified

## Overview

Clarify requirements before implementing. Stop and ask when serious doubts arise.

**Core principle:** If multiple plausible interpretations exist, the request is underspecified. Ask before coding.

## When to Use

Use when a request has multiple plausible interpretations or key details are unclear:
- Objective (what should change vs stay the same)
- Done criteria (acceptance criteria, examples, edge cases)
- Scope (which files/components are in/out)
- Constraints (compatibility, performance, style, deps)
- Environment (language/runtime versions, build/test runner)
- Safety/reversibility (data migration, rollout/rollback, risk)

## When NOT to Use

- Request is already clear
- A quick read of configs/existing code can answer the question
- Trivial changes with obvious intent

## Protocol

### 1. Decide whether the request is underspecified

After exploring how to perform the work, check if the items above are clear. If multiple plausible interpretations exist, it is underspecified.

### 2. Ask must-have questions first (keep it small)

Ask 1-5 questions in the first pass. Prefer questions that eliminate whole branches of work.

Make questions easy to answer:
- Short, numbered questions (not paragraphs)
- Multiple-choice options when possible
- Suggest reasonable defaults (bold the recommended choice)
- Include a fast-path response (e.g., reply `defaults` to accept all)
- Structure so the user can respond compactly (e.g., `1b 2a 3c`)

Use the AskUser tool for structured questionnaires.

### 3. Pause before acting

Until must-have answers arrive:
- Do NOT run commands, edit files, or produce a detailed plan that depends on unknowns
- DO perform low-risk discovery (inspect repo structure, read config files)

If the user asks you to proceed without answers:
- State your assumptions as a short numbered list
- Ask for confirmation before proceeding

### 4. Confirm interpretation, then proceed

Once you have answers, restate requirements in 1-3 sentences (including key constraints and what success looks like), then start work.

## Anti-patterns

- Don't ask questions you can answer with a quick read of existing code/configs
- Don't ask open-ended questions when tight multiple-choice eliminates ambiguity faster
- Don't ask more than 5 questions in the first pass
- Don't stall on "nice to know" -- focus on "need to know"

## Quality Gates

- [ ] No implementation started before must-have questions answered
- [ ] Questions are numbered with multiple-choice options
- [ ] Default/recommended option is clearly marked
- [ ] Requirements restated and confirmed before work begins
