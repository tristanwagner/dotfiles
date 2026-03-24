#!/usr/bin/env python3
"""
Circuit breaker hook for Droid (PostToolUse).
Tracks consecutive tool failures and escalates feedback:
  - After 3 failures: "Try a different approach"
  - After 5 failures: "STOP and rethink entirely"
Resets on any success.
"""
import json
import sys
import os
import tempfile

def get_state_file(session_id):
    return os.path.join(tempfile.gettempdir(), f"droid-circuit-breaker-{session_id}.json")

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
    if tool_name == "Execute":
        resp = tool_response if isinstance(tool_response, dict) else {}
        stdout = resp.get("stdout", "") or ""
        exit_code = resp.get("exitCode", resp.get("exit_code", 0))
        if exit_code != 0:
            return True
        for marker in ["error", "Error", "ERROR", "FAILED", "failed", "Cannot find", "not found"]:
            if marker in stdout:
                return True
    if tool_name == "Edit":
        resp = tool_response if isinstance(tool_response, dict) else {}
        if resp.get("success") is False or resp.get("error"):
            return True
    return False

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

session_id = data.get("session_id", "unknown")
tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})
tool_response = data.get("tool_response", {})

state_file = get_state_file(session_id)
state = load_state(state_file)

if is_failure(tool_name, tool_input, tool_response):
    state["consecutive_failures"] += 1
    state["last_tools"].append(tool_name)
    state["last_tools"] = state["last_tools"][-5:]
    save_state(state_file, state)

    n = state["consecutive_failures"]
    if n >= 5:
        output = {
            "decision": "block",
            "reason": (
                f"CIRCUIT BREAKER: {n} consecutive tool failures "
                f"(tools: {', '.join(state['last_tools'])}). "
                "STOP what you are doing. Your current approach is not working. "
                "Step back, re-read the error messages, and try a fundamentally "
                "different approach. Do NOT retry the same strategy."
            )
        }
        print(json.dumps(output))
    elif n >= 3:
        output = {
            "decision": "block",
            "reason": (
                f"CIRCUIT BREAKER: {n} consecutive tool failures "
                f"(tools: {', '.join(state['last_tools'])}). "
                "Your current approach may not be working. Consider trying a "
                "different strategy before continuing."
            )
        }
        print(json.dumps(output))
else:
    if state["consecutive_failures"] > 0:
        state["consecutive_failures"] = 0
        state["last_tools"] = []
        save_state(state_file, state)

sys.exit(0)
