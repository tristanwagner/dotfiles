# Lightweight circuit breaker

This is a small stop/retry policy inspired by Factory's `circuit-breaker`, documented as guidance instead of automation.

## Goal

Avoid wasting time repeating the same failing tactic.

## Retry policy

Retry once when the failure looks incidental:

- transient command failure
- flaky network or package registry issue
- obvious typo or malformed command
- edit mismatch caused by stale file context

## Change-tactics policy

Do not keep repeating the same approach.

After two similar failures:

1. re-read the error closely
2. check the relevant file or config again
3. change tactics

Examples of changing tactics:

- read the file instead of guessing
- run a narrower command
- inspect diagnostics before editing again
- simplify the change
- verify assumptions about paths, symbols, or tool behavior

## Stop-and-ask policy

Stop and ask the user when:

- requirements are ambiguous
- multiple valid directions exist with product or style tradeoffs
- the tool output contradicts your assumptions
- the repo appears to have pre-existing breakage unrelated to the task
- repeated failures suggest missing context or unsafe risk

## Good defaults

- Treat repeated identical failures as a signal, not a challenge.
- Prefer diagnosis before another attempt.
- Escalate earlier for destructive, security-sensitive, or broad-impact changes.
- If a safer smaller step exists, do that first.
