#!/usr/bin/env python3
"""
Conventional commit enforcer hook for Droid (PreToolUse on Execute).
Validates that git commit messages follow the conventional commits format.
Blocks malformed commit messages and tells the agent to fix them.

Accepted prefixes: feat, fix, refactor, docs, test, chore, style, perf, ci, build, revert
"""
import json
import sys
import re

VALID_PREFIXES = [
    "feat", "fix", "refactor", "docs", "test", "chore",
    "style", "perf", "ci", "build", "revert",
]

PREFIX_PATTERN = re.compile(
    r'^(' + '|'.join(VALID_PREFIXES) + r')(\(.+?\))?!?:\s+.+'
)

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

tool_name = data.get("tool_name", "")
command = data.get("tool_input", {}).get("command", "")

if tool_name != "Execute":
    sys.exit(0)

# Only check git commit commands
if "git commit" not in command:
    sys.exit(0)

# Extract the commit message from -m flag
match = re.search(r'-m\s+["\'](.+?)["\']', command)
if not match:
    # Could be using -m without quotes or --amend without -m
    if "--amend" in command and "-m" not in command:
        sys.exit(0)  # amend without new message is fine
    sys.exit(0)

message = match.group(1)

# Check if it follows conventional commits
if not PREFIX_PATTERN.match(message):
    valid = ", ".join(VALID_PREFIXES)
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": (
                f"[COMMIT FORMAT] Message doesn't follow conventional commits.\n"
                f"Got: \"{message}\"\n"
                f"Expected: <type>[(scope)]: <description>\n"
                f"Valid types: {valid}\n"
                f"Examples: \"feat: add user auth\", \"fix(api): handle null response\""
            )
        }
    }
    print(json.dumps(output))

sys.exit(0)
