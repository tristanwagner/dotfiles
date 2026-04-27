# Soulforge base

This directory is the portable part of my Soulforge setup.

## What is saved

- `prompts/`: reusable role prompts that replace the old Factory droid idea
- `checks.md`: thin post-edit verification policy
- `circuit-breaker.md`: lightweight stop/retry/escalation guidance

## What was migrated from Factory

Only durable ideas were carried over:

- compact reviewer, researcher, and quick-coder prompts
- lightweight verification guidance inspired by `post-edit-check`
- lightweight failure-handling guidance inspired by `circuit-breaker`

## What was intentionally excluded

These stay out of the portable setup:

- Factory runtime/session machinery
- heavy enforcement hooks
- Factory-specific orchestration and handoff formats
- proxy/model glue already covered by Soulforge's built-in CLIProxyAPI
- secrets, API keys, and local runtime databases

## Runtime state

Soulforge runtime state lives in `.soulforge/` and is intentionally ignored by git.

## Reinstall / bootstrap

1. Clone the dotfiles repo onto a new machine.
2. Install Soulforge separately.
3. Keep using the committed files in `.config/soulforge/` as the portable base.
4. Reference prompts from `.config/soulforge/prompts/` when you want a reviewer, researcher, or quick-coder style workflow.
5. Use `checks.md` and `circuit-breaker.md` as lightweight guidance rather than hard automation.

## Notes

- Soulforge's built-in CLIProxyAPI replaces the need to port Factory proxy/model glue.
- `.soulforge/` is runtime state only and should stay ignored.
- These files are the only intended migrated artifacts; no Factory secrets should be copied here.
