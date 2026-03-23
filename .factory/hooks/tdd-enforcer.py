#!/usr/bin/env python3
"""
TDD enforcer hook for Droid (PreToolUse on Edit|Create).
Tracks file edit order within a session and warns when production code
is created/edited before its corresponding test file.

Logic:
  - Maintains a session state file tracking which files have been touched
  - When a production .ts/.tsx file is about to be edited/created:
    - Check if its test counterpart (.test.ts, .spec.ts) was touched first
    - If not, warn the agent (soft nudge, not a hard block)
  - When a test file is touched, record it so subsequent prod edits are allowed
  - Skips: types, schemas, configs, index files, migrations, and non-code files

This hook provides advisory guidance, not hard blocks, because:
  - Sometimes you need to read/modify existing code to understand what to test
  - Refactoring may touch many files where tests already exist
  - Config and type changes don't need test-first
"""
import json
import sys
import os
import tempfile

SKIP_BASENAMES = {
    "types.ts", "types.tsx", "index.ts", "index.tsx",
    "constants.ts", "enums.ts", "config.ts", "env.ts",
    "router.ts", "router.tsx", "main.ts", "main.tsx",
    "schema.ts", "vite.config.ts", "vitest.config.ts",
    "tailwind.config.ts", "tsconfig.json", "alchemy.run.ts",
}

SKIP_PATH_PARTS = {
    "migrations", "dist", "node_modules", ".d.ts",
    "generated", "__mocks__", "fixtures",
}

def is_test_file(path):
    base = os.path.basename(path)
    return ".test." in base or ".spec." in base or "/__tests__/" in path

def get_test_counterparts(file_path):
    """Return possible test file paths for a given production file."""
    base, ext = os.path.splitext(file_path)
    dirname = os.path.dirname(file_path)
    basename_no_ext = os.path.basename(base)
    return [
        f"{base}.test{ext}",
        f"{base}.spec{ext}",
        os.path.join(dirname, "__tests__", f"{basename_no_ext}.test{ext}"),
        os.path.join(dirname, "__tests__", f"{basename_no_ext}{ext}"),
    ]

def load_state(session_id):
    path = os.path.join(tempfile.gettempdir(), f"droid-tdd-state-{session_id}.json")
    try:
        with open(path, "r") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"touched_tests": [], "warned_files": [], "prod_edits": 0}

def save_state(session_id, state):
    path = os.path.join(tempfile.gettempdir(), f"droid-tdd-state-{session_id}.json")
    with open(path, "w") as f:
        json.dump(state, f)

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

file_path = data.get("tool_input", {}).get("file_path", "")
session_id = data.get("session_id", "unknown")

if not file_path:
    sys.exit(0)

ext = os.path.splitext(file_path)[1].lower()
if ext not in (".ts", ".tsx", ".js", ".jsx"):
    sys.exit(0)

basename = os.path.basename(file_path)

# Skip files that don't need test-first
if basename in SKIP_BASENAMES:
    sys.exit(0)
if any(skip in file_path for skip in SKIP_PATH_PARTS):
    sys.exit(0)

state = load_state(session_id)

# If this IS a test file, record it and allow
if is_test_file(file_path):
    if file_path not in state["touched_tests"]:
        state["touched_tests"].append(file_path)
    save_state(session_id, state)
    sys.exit(0)

# This is a production file. Check if its test was touched first.
state["prod_edits"] = state.get("prod_edits", 0) + 1

# Check if any test counterpart exists on disk OR was touched this session
counterparts = get_test_counterparts(file_path)
test_touched = any(t in state["touched_tests"] for t in counterparts)
test_exists = any(os.path.exists(t) for t in counterparts)

# Don't warn for files that already have tests (likely refactoring existing code)
if test_exists:
    save_state(session_id, state)
    sys.exit(0)

# Don't warn for the same file twice in one session
if file_path in state.get("warned_files", []):
    save_state(session_id, state)
    sys.exit(0)

if not test_touched:
    state.setdefault("warned_files", []).append(file_path)
    save_state(session_id, state)

    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
            "permissionDecisionReason": (
                f"[TDD] Writing production code ({basename}) without a test file first. "
                f"Consider writing a test at one of: {', '.join(os.path.basename(t) for t in counterparts[:2])} "
                f"before implementing. If this is a refactor of existing tested code or a "
                f"non-logic file, you can proceed."
            )
        }
    }
    print(json.dumps(output))
else:
    save_state(session_id, state)

sys.exit(0)
