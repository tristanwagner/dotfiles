#!/usr/bin/env python3
"""
Session context loader hook for Droid (SessionStart).
Injects useful context at the start of every session:
  - Current branch and status relative to master
  - Recent git activity (last 24h commits)
  - TODO/FIXME/HACK comments in recently modified files
"""
import json
import sys
import os
import subprocess

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

project_dir = os.environ.get("FACTORY_PROJECT_DIR", data.get("cwd", ""))
if not project_dir:
    sys.exit(0)

parts = []

# Current branch info
try:
    branch = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        cwd=project_dir, capture_output=True, text=True, timeout=5
    ).stdout.strip()

    if branch and branch != "master":
        ahead_behind = subprocess.run(
            ["git", "rev-list", "--left-right", "--count", f"master...{branch}"],
            cwd=project_dir, capture_output=True, text=True, timeout=5
        ).stdout.strip()
        if ahead_behind:
            behind, ahead = ahead_behind.split()
            status = []
            if int(ahead) > 0:
                status.append(f"{ahead} commits ahead")
            if int(behind) > 0:
                status.append(f"{behind} commits behind")
            if status:
                parts.append(f"Branch: {branch} ({', '.join(status)} of master)")
            else:
                parts.append(f"Branch: {branch} (up to date with master)")
        else:
            parts.append(f"Branch: {branch}")
    elif branch:
        parts.append(f"Branch: {branch}")
except (subprocess.TimeoutExpired, FileNotFoundError, ValueError):
    pass

# Uncommitted changes summary
try:
    status = subprocess.run(
        ["git", "diff", "--stat", "HEAD"],
        cwd=project_dir, capture_output=True, text=True, timeout=5
    ).stdout.strip()
    if status:
        lines = status.splitlines()
        if lines:
            parts.append(f"Uncommitted changes: {lines[-1].strip()}")
except (subprocess.TimeoutExpired, FileNotFoundError):
    pass

# Recent commits (last 24h)
try:
    recent = subprocess.run(
        ["git", "log", "--oneline", "--since=24.hours.ago", "--max-count=10"],
        cwd=project_dir, capture_output=True, text=True, timeout=5
    ).stdout.strip()
    if recent:
        parts.append(f"Recent commits (24h):\n{recent}")
except (subprocess.TimeoutExpired, FileNotFoundError):
    pass

# TODO/FIXME/HACK in recently modified files
try:
    modified = subprocess.run(
        ["git", "diff", "--name-only", "HEAD"],
        cwd=project_dir, capture_output=True, text=True, timeout=5
    ).stdout.strip().splitlines()

    todos = []
    for f in modified[:15]:
        fp = os.path.join(project_dir, f)
        if not os.path.exists(fp) or not f.endswith((".ts", ".tsx", ".js", ".jsx", ".py")):
            continue
        try:
            with open(fp, "r") as fh:
                for i, line in enumerate(fh, 1):
                    for marker in ["TODO", "FIXME", "HACK", "XXX"]:
                        if marker in line and not line.strip().startswith("//!"):
                            todos.append(f"  {f}:{i}: {line.strip()[:100]}")
                            break
        except (IOError, UnicodeDecodeError):
            continue

    if todos:
        parts.append("Action markers in modified files:\n" + "\n".join(todos[:10]))
except (subprocess.TimeoutExpired, FileNotFoundError):
    pass

if parts:
    context = "[SESSION CONTEXT]\n" + "\n\n".join(parts)
    output = {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": context
        }
    }
    print(json.dumps(output))

sys.exit(0)
