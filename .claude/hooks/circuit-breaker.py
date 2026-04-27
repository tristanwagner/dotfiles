#!/usr/bin/env python3
"""
Circuit breaker hook (PostToolUse on Bash/Edit/Write).
Tracks consecutive tool failures and escalates:
  - After 3: "Try a different approach"
  - After 5: "STOP and rethink entirely"
Resets on any success.
"""
import json
import sys
import os
import tempfile


def get_state_file():
    ppid = os.getppid()
    return os.path.join(tempfile.gettempdir(), f"claude-circuit-breaker-{ppid}.json")


def load_state(path):
    try:
        with open(path, "r") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"consecutive_failures": 0, "last_tools": []}


def save_state(path, state):
    with open(path, "w") as f:
        json.dump(state, f)


def is_failure(tool_name, tool_input, tool_response):
    resp_str = str(tool_response) if tool_response else ""

    if tool_name == "Bash":
        for marker in ["error", "Error", "ERROR", "FAILED", "failed",
                        "Cannot find", "not found", "command not found",
                        "No such file", "Permission denied"]:
            if marker in resp_str:
                return True
        if "exit code" in resp_str.lower() and "exit code 0" not in resp_str.lower():
            return True

    if tool_name in ("Edit", "Write"):
        for marker in ["error", "Error", "failed", "Failed", "not found",
                        "does not exist", "No match"]:
            if marker in resp_str:
                return True

    return False


try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})
tool_response = data.get("tool_response", {})

state_file = get_state_file()
state = load_state(state_file)

if is_failure(tool_name, tool_input, tool_response):
    state["consecutive_failures"] += 1
    state["last_tools"].append(tool_name)
    state["last_tools"] = state["last_tools"][-5:]
    save_state(state_file, state)

    n = state["consecutive_failures"]
    if n >= 5:
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PostToolUse",
                "additionalContext": (
                    f"CIRCUIT BREAKER: {n} consecutive tool failures "
                    f"(tools: {', '.join(state['last_tools'])}). "
                    "STOP what you are doing. Your current approach is not working. "
                    "Step back, re-read the error messages, and try a fundamentally "
                    "different approach. Do NOT retry the same strategy."
                )
            }
        }
        print(json.dumps(output))
    elif n >= 3:
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PostToolUse",
                "additionalContext": (
                    f"CIRCUIT BREAKER: {n} consecutive tool failures "
                    f"(tools: {', '.join(state['last_tools'])}). "
                    "Your current approach may not be working. Consider trying a "
                    "different strategy before continuing."
                )
            }
        }
        print(json.dumps(output))
else:
    if state["consecutive_failures"] > 0:
        state["consecutive_failures"] = 0
        state["last_tools"] = []
        save_state(state_file, state)

sys.exit(0)
