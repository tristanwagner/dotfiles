#!/usr/bin/env python3
"""
Session-start restore hook for Droid (SessionStart:compact).
After context compaction, restores the saved state snapshot as additional
context so the agent doesn't lose track of what it was doing.
"""
import json
import sys
import os

SAVE_DIR = os.path.expanduser("~/.factory/compact-state")

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

source = data.get("source", "")
session_id = data.get("session_id", "unknown")

# Only activate on compact restores
if source != "compact":
    sys.exit(0)

save_path = os.path.join(SAVE_DIR, f"{session_id}.json")
if not os.path.exists(save_path):
    sys.exit(0)

try:
    with open(save_path, "r") as f:
        state = json.load(f)
except (json.JSONDecodeError, IOError):
    sys.exit(0)

parts = ["[SESSION STATE RESTORED AFTER COMPACTION]"]
parts.append(f"Working directory: {state.get('cwd', 'unknown')}")
parts.append(f"Compaction trigger: {state.get('trigger', 'unknown')}")
parts.append(f"State saved at: {state.get('saved_at', 'unknown')}")

recent = state.get("recent_context", [])
if recent:
    parts.append("\nRecent context before compaction:")
    for item in recent:
        parts.append(f"  - {item}")

context = "\n".join(parts)

output = {
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": context
    }
}
print(json.dumps(output))

# Clean up the state file
try:
    os.remove(save_path)
except OSError:
    pass

sys.exit(0)
