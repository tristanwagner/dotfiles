#!/usr/bin/env python3
"""
Context-aware skill activation hook for Droid (PostToolUse on Edit|Create).
Detects the type/context of the file being edited and injects relevant
skill/workflow hints as additionalContext.

This doesn't load full skills (that's done via the Skill tool), but nudges
the agent to invoke the right skill or follow the right pattern.
"""
import json
import sys
import os

CONTEXT_RULES = [
    {
        "match_path": ["schema.ts"],
        "match_dir": ["db", "database"],
        "hint": (
            "[CONTEXT] You're editing a database schema. "
            "Consider using the `migrator` droid for end-to-end schema changes. "
            "Remember to run `pnpm db:generate` after schema modifications."
        )
    },
    {
        "match_ext": [".test.ts", ".test.tsx", ".spec.ts"],
        "hint": (
            "[CONTEXT] You're editing a test file. "
            "Follow TDD patterns: verify the test fails for the right reason before implementing."
        )
    },
    {
        "match_path": ["SKILL.md"],
        "hint": (
            "[CONTEXT] You're editing a skill definition. "
            "Follow the 5-section format: Identity, Orientation, Protocol, Quality Gates, Exit Protocol. "
            "Use the `skill-improver` droid to review quality."
        )
    },
    {
        "match_parent": ["droids"],
        "match_ext": [".md"],
        "hint": (
            "[CONTEXT] You're editing a droid definition. "
            "Ensure it has: clear single purpose, specific rules, correct tools list, HANDOFF block."
        )
    },
    {
        "match_dir": ["migrations"],
        "hint": (
            "[CONTEXT] You're editing a migration file. "
            "Be careful: migrations are append-only. Don't modify existing migrations "
            "that may have already been applied."
        )
    },
    {
        "match_parent": ["hooks"],
        "match_ext": [".py", ".sh"],
        "hint": (
            "[CONTEXT] You're editing a hook script. "
            "Ensure: graceful failure (exit 0 on unexpected input), <1s execution, "
            "no shell injection, proper JSON stdin parsing."
        )
    },
    {
        "match_path": ["router.ts", "router.tsx"],
        "hint": (
            "[CONTEXT] You're editing the router. "
            "Ensure new routes are lazy-loaded and follow existing patterns."
        )
    },
    {
        "match_dir": ["api", "queries"],
        "match_ext": [".ts"],
        "hint": (
            "[CONTEXT] You're editing API/query code. "
            "Ensure error handling, proper types, and that the shared package types "
            "stay in sync if you change response shapes."
        )
    },
]

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

file_path = data.get("tool_input", {}).get("file_path", "")
if not file_path:
    sys.exit(0)

basename = os.path.basename(file_path).lower()
ext = os.path.splitext(file_path)[1].lower()
dirs = file_path.lower().split(os.sep)
parent_dir = os.path.basename(os.path.dirname(file_path)).lower()

hints = []
for rule in CONTEXT_RULES:
    matched = False

    if "match_path" in rule:
        if any(p.lower() in basename for p in rule["match_path"]):
            matched = True
        else:
            continue

    if "match_ext" in rule:
        if ext not in [e.lower() for e in rule["match_ext"]] and not any(basename.endswith(e.lower()) for e in rule["match_ext"]):
            if "match_path" not in rule:
                continue
        elif "match_path" not in rule:
            matched = True

    if "match_parent" in rule:
        if parent_dir in [p.lower() for p in rule["match_parent"]]:
            matched = True
        else:
            continue

    if "match_dir" in rule:
        if any(d.lower() in dirs for d in rule["match_dir"]):
            matched = True
        elif "match_path" not in rule and "match_ext" not in rule:
            continue

    if matched:
        hints.append(rule["hint"])

if hints:
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PostToolUse",
            "additionalContext": "\n".join(hints[:2])  # max 2 hints per edit
        }
    }
    print(json.dumps(output))

sys.exit(0)
