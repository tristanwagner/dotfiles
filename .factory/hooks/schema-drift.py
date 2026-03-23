#!/usr/bin/env python3
"""
Schema drift detector hook for Droid (PostToolUse on Edit).
When a Drizzle schema file is edited, checks if drizzle-kit generate
has been run in the current session. If not, reminds the agent.
"""
import json
import sys
import os
import tempfile

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

file_path = data.get("tool_input", {}).get("file_path", "")
session_id = data.get("session_id", "unknown")

if not file_path:
    sys.exit(0)

basename = os.path.basename(file_path)
is_schema = basename == "schema.ts" and "db" in file_path

if not is_schema:
    sys.exit(0)

marker = os.path.join(tempfile.gettempdir(), f"droid-migration-generated-{session_id}")

if os.path.exists(marker):
    sys.exit(0)

# Mark that schema was edited (so we can track across edits)
flag = os.path.join(tempfile.gettempdir(), f"droid-schema-edited-{session_id}")
with open(flag, "w") as f:
    f.write(file_path)

output = {
    "hookSpecificOutput": {
        "hookEventName": "PostToolUse",
        "additionalContext": (
            "[SCHEMA DRIFT] You edited the Drizzle schema but haven't generated "
            "a migration yet. Run `pnpm db:generate` before finishing. "
            "If this was an intentional schema-only change (e.g., adding a Zod "
            "schema or a type), you can ignore this warning."
        )
    }
}
print(json.dumps(output))
sys.exit(0)
