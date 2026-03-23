#!/usr/bin/env python3
"""
Pre-compact state preservation hook for Droid (PreCompact).
Saves a lightweight session state snapshot before context compaction
so important decisions and progress aren't lost.
"""
import json
import sys
import os
from datetime import datetime

SAVE_DIR = os.path.expanduser("~/.factory/compact-state")

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

session_id = data.get("session_id", "unknown")
transcript_path = data.get("transcript_path", "")
trigger = data.get("trigger", "auto")
cwd = data.get("cwd", "")

os.makedirs(SAVE_DIR, exist_ok=True)

state = {
    "session_id": session_id,
    "saved_at": datetime.now().isoformat(),
    "trigger": trigger,
    "cwd": cwd,
    "transcript_path": transcript_path,
}

# Extract recent context from transcript if available
if transcript_path and os.path.exists(transcript_path):
    try:
        messages = []
        with open(transcript_path, "r") as f:
            for line in f:
                line = line.strip()
                if line:
                    try:
                        messages.append(json.loads(line))
                    except json.JSONDecodeError:
                        continue

        # Collect recent assistant tool uses and user messages (last 20 entries)
        recent = messages[-20:] if len(messages) > 20 else messages
        summary_parts = []
        for msg in recent:
            role = msg.get("role", "")
            if role == "user":
                content = msg.get("content", "")
                if isinstance(content, str) and len(content) < 500:
                    summary_parts.append(f"User: {content[:200]}")
            elif role == "assistant":
                content = msg.get("content", "")
                if isinstance(content, str) and len(content) < 500:
                    summary_parts.append(f"Assistant: {content[:200]}")

        if summary_parts:
            state["recent_context"] = summary_parts[-10:]
    except (IOError, OSError):
        pass

save_path = os.path.join(SAVE_DIR, f"{session_id}.json")
with open(save_path, "w") as f:
    json.dump(state, f, indent=2)

sys.exit(0)
