#!/usr/bin/env python3
"""
Conventional commit enforcer (PreToolUse on Bash).
Validates git commit messages follow conventional commits format.
Blocks malformed messages and tells the agent to fix them.
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

command = data.get("tool_input", {}).get("command", "")

if "git commit" not in command:
    sys.exit(0)

match = re.search(r'-m\s+["\'](.+?)["\']', command)
if not match:
    # HEREDOC-style: extract from cat <<'EOF' ... EOF block
    heredoc = re.search(r'<<[\']?EOF[\']?\s*\n(.+?)\n\s*EOF', command, re.DOTALL)
    if heredoc:
        message = heredoc.group(1).strip().split('\n')[0]
    elif "--amend" in command and "-m" not in command:
        sys.exit(0)
    else:
        sys.exit(0)
else:
    message = match.group(1)

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
