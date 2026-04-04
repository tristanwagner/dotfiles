---
name: sharp-edges
description: Identifies error-prone APIs, dangerous configurations, and footgun designs. Use when reviewing API design, auditing configs for dangerous options, or checking for "footguns" and "secure defaults".
---

# Sharp Edges Analysis

## Overview

Identifies error-prone APIs, dangerous configurations, and footgun designs that enable security mistakes. Evaluates whether APIs follow "secure by default" and "pit of success" principles.

## When to Use

- Reviewing API or library design decisions
- Auditing configuration schemas for dangerous options
- Evaluating authentication/authorization interfaces
- Reviewing code that exposes security-relevant choices to developers
- When asked to check for "footguns", "misuse-resistant design", or "secure defaults"

## When NOT to Use

- Implementation bugs (use standard code review)
- Business logic flaws (use domain-specific analysis)
- Performance optimization

## Core Principle

**The pit of success**: Secure usage should be the path of least resistance. If developers must read docs carefully or remember special rules to avoid vulnerabilities, the API has failed.

## Rationalizations to Reject

| Rationalization | Why It's Wrong | Required Action |
|-----------------|----------------|-----------------|
| "It's documented" | Devs don't read docs under deadline pressure | Make secure choice the default |
| "Advanced users need flexibility" | Flexibility creates footguns; most "advanced" usage is copy-paste | Provide safe high-level APIs |
| "It's the developer's responsibility" | Blame-shifting; you designed the footgun | Remove the footgun |
| "Nobody would actually do that" | Developers do everything under pressure | Assume maximum confusion |
| "It's just a configuration option" | Config is code; wrong configs ship to prod | Validate; reject dangerous combos |
| "We need backwards compatibility" | Insecure defaults can't be grandfathered | Deprecate loudly; force migration |

## Sharp Edge Categories

### 1. Algorithm/Mode Selection Footguns
APIs that let developers choose algorithms invite choosing wrong ones.
- Function parameters like `algorithm`, `mode`, `cipher`, `hash_type`
- Enums/strings selecting cryptographic primitives
- Configuration options for security mechanisms

### 2. Dangerous Defaults
Settings that start insecure and require opt-in to safety.
- `verify_ssl=True` should be default, not opt-in
- `allow_any_origin=False` should be default
- Missing rate limits, missing auth requirements

### 3. Error Handling Footguns
APIs where error handling mistakes lead to security bypasses.
- Auth functions returning null (bypassed by not checking)
- Exceptions that skip security checks when caught broadly
- Boolean returns where both values look "normal"

### 4. Stringly-Typed Security
Security decisions driven by string comparisons or parsing.
- Role checks via string matching (`if role == "admin"`)
- Permission systems using string concatenation
- SQL/command injection via string interpolation

### 5. Implicit State Dependencies
Security that depends on calling functions in the right order.
- Must call `authenticate()` before `authorize()`
- Must call `validate()` before `process()`
- Session state that can be in inconsistent states

## Protocol

1. Identify all public APIs, configuration schemas, and developer-facing interfaces
2. For each, evaluate against the 5 categories above
3. Check: "Can a tired developer at 2 AM use this wrong?"
4. For each finding, provide: the footgun, the exploit/mistake scenario, and the fix

## Quality Gates

- [ ] All public APIs evaluated for misuse potential
- [ ] Each finding includes a concrete mistake scenario
- [ ] Each finding includes a specific fix recommendation
- [ ] Rationalizations challenged, not accepted

## Exit Protocol

```
---HANDOFF---
- Scope reviewed: [APIs/configs/interfaces checked]
- Sharp edges found: [count by category]
- Critical: [list items that could lead to security bypass]
- Recommendations: [top fixes ranked by impact]
- Unresolved: [areas needing deeper review or "none"]
---
```
