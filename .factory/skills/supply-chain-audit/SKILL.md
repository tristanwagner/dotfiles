---
name: supply-chain-audit
description: Identifies dependencies at heightened risk of exploitation or takeover. Use when assessing dependency risk, evaluating supply chain attack surface, or auditing for unmaintained packages.
---

# Supply Chain Risk Auditor

## Overview

Identifies dependencies at heightened risk of exploitation or takeover. Evaluates supply chain attack surface.

## When to Use

- Assessing dependency risk before a security audit
- Evaluating supply chain attack surface of a project
- Identifying unmaintained or risky dependencies
- Pre-engagement scoping for supply chain concerns
- When asked to "audit dependencies" or "check supply chain"

## When NOT to Use

- Active vulnerability scanning (use `npm audit`, `pip-audit`, etc.)
- Runtime dependency analysis
- License compliance auditing

## Risk Criteria

A dependency is high-risk if it has any of these factors:

* **Single maintainer** -- Bus factor of 1; account compromise = supply chain attack
* **Unmaintained** -- No commits in 12+ months; no response to issues/PRs
* **Low popularity** -- Few downloads/stars relative to criticality; less scrutiny
* **High-risk features** -- Install scripts, native code, network access, file system access
* **Past CVEs** -- History of vulnerabilities suggests more may exist
* **No security contact** -- No SECURITY.md, no security policy, no way to report

## Protocol

### 1. Inventory dependencies

Read `package.json` (or equivalent: `requirements.txt`, `go.mod`, `Cargo.toml`).
List all direct dependencies (skip devDependencies unless they run in CI/build).

### 2. Evaluate each dependency

For each direct dependency:
- Check maintainer count (GitHub contributors page, npm page)
- Check last commit date and release frequency
- Check download counts / stars
- Check for install scripts (`preinstall`, `postinstall`)
- Check for past CVEs (search `npm audit` output or CVE databases)
- Check for SECURITY.md or security policy

### 3. Build high-risk table

| Dependency | Version | Risk Factors | Severity | Suggested Alternative |
|-----------|---------|-------------|----------|----------------------|
| example   | 1.2.3   | Single maintainer, unmaintained | High | alternative-pkg |

### 4. Summarize

- Total dependencies audited
- Count by risk factor category
- Top 5 highest-risk dependencies
- Recommendations (replace, pin, vendor, monitor)

## Quality Gates

- [ ] All direct dependencies evaluated
- [ ] Each high-risk dependency has specific risk factors listed
- [ ] Alternatives suggested for high-risk items where possible
- [ ] Summary includes actionable recommendations

## Exit Protocol

```
---HANDOFF---
- Dependencies audited: [count]
- High-risk found: [count]
- Critical risks: [list top concerns]
- Recommendations: [replace/pin/vendor/monitor for each]
- Unresolved: [deps that couldn't be fully evaluated or "none"]
---
```
