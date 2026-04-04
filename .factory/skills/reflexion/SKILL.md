---
name: reflexion
description: Self-refinement framework for iterative improvement after completing non-trivial work. Use to reflect on output, catch flaws, verify claims, and improve quality before delivering.
---

# Reflexion

## Overview

Self-refinement framework for iterative improvement. After completing work, reflect on the output to catch flaws, verify claims, and improve quality before delivering.

**Core principle:** First-draft output is rarely best output. Systematic self-critique catches what rush misses.

## When to Use

- After completing any non-trivial implementation
- After generating plans, specs, or documentation
- When confidence in output is below 90%
- When explicitly asked to "reflect" or "self-review"
- Before delivering final results to the user

## When NOT to Use

- Trivial changes (single-line edits, renames)
- When the user explicitly says to skip review
- During rapid iteration where speed matters more than polish

## Protocol

### 1. Complexity Triage

Classify the completed work:

| Complexity | Criteria                                                | Reflection Depth          |
| ---------- | ------------------------------------------------------- | ------------------------- |
| Low        | Single file, < 20 lines changed, no logic               | Quick scan (30s)          |
| Medium     | Multiple files, moderate logic, standard patterns       | Standard review (2-3 min) |
| High       | Architecture changes, security-sensitive, complex logic | Deep review (5+ min)      |

### 2. Quick Reflection (Low complexity)

- Scan for typos, syntax errors, missing imports
- Verify the change does what was asked
- Check for obvious regressions
- Done.

### 3. Standard Reflection (Medium complexity)

Run through this checklist:

**Correctness:**

- [ ] Does this actually solve the stated problem?
- [ ] Are there edge cases not handled?
- [ ] Are error states handled gracefully?
- [ ] Do all code paths have correct return types?

**Completeness:**

- [ ] Are all requirements from the prompt addressed?
- [ ] Are there implicit requirements that were missed?
- [ ] Are tests updated/added for changed behavior?

**Quality:**

- [ ] Does this follow existing project patterns?
- [ ] Are names clear and consistent?
- [ ] Is there unnecessary complexity that could be simplified?
- [ ] Are there any security implications?

### 4. Deep Reflection (High complexity)

Everything in Standard, plus:

**Architecture:**

- [ ] Does this change respect existing boundaries (module, package, layer)?
- [ ] Will this be maintainable in 6 months?
- [ ] Are there hidden coupling or dependency issues?
- [ ] Is the abstraction level appropriate?

**Fact-checking:**

- [ ] Are all technical claims verifiable?
- [ ] Are library APIs used correctly (check docs if unsure)?
- [ ] Are any assumptions made that should be validated?

**Adversarial thinking:**

- [ ] What would a hostile code reviewer say?
- [ ] What's the worst thing that could go wrong?
- [ ] If I had to argue against this approach, what would I say?

### 5. Act on Findings

For each issue found:

1. **Critical** (wrong behavior, security hole, data loss) -- Fix immediately
2. **Important** (missing edge case, unclear code, fragile design) -- Fix now
3. **Minor** (style, naming, optional improvement) -- Fix if quick, note if not

### 6. Confidence Score

After reflection, state your confidence:

- **95-100%**: Solid, well-tested, handles edge cases
- **80-94%**: Good but has areas of uncertainty (list them)
- **60-79%**: Significant concerns exist (list them, suggest what to verify)
- **Below 60%**: Recommend the user review carefully before accepting

## Quality Gates

- [ ] Complexity correctly triaged
- [ ] All checklist items for the appropriate depth level checked
- [ ] Issues found are categorized and acted on
- [ ] Confidence score stated with reasoning

## Exit Protocol

```
---HANDOFF---
- Reflection depth: [quick/standard/deep]
- Issues found: [count by severity]
- Issues fixed: [count]
- Confidence: [score]% -- [brief reasoning]
- Remaining concerns: [list or "none"]
---
```
