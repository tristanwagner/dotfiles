#!/usr/bin/env python3
"""
Import boundary enforcer hook for Droid (PostToolUse on Edit|Create).
In a monorepo, apps must not import from other apps -- only from packages.
Catches cross-app imports instantly.

Expected structure:
  apps/admin/   -- can import from packages/*, NOT from apps/pipeline/ or apps/web/
  apps/pipeline/ -- can import from packages/*, NOT from apps/admin/ or apps/web/
  apps/web/     -- can import from packages/*, NOT from apps/admin/ or apps/pipeline/
  packages/*    -- can import from other packages/*
"""
import json
import sys
import os
import re

APPS_DIR = "apps"

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

file_path = data.get("tool_input", {}).get("file_path", "")
project_dir = os.environ.get("FACTORY_PROJECT_DIR", data.get("cwd", ""))

if not file_path or not project_dir:
    sys.exit(0)

ext = os.path.splitext(file_path)[1].lower()
if ext not in (".ts", ".tsx", ".js", ".jsx"):
    sys.exit(0)

rel = os.path.relpath(file_path, project_dir)
parts = rel.split(os.sep)

# Only check files inside apps/
if len(parts) < 2 or parts[0] != APPS_DIR:
    sys.exit(0)

current_app = parts[1]

# Discover other app names
apps_path = os.path.join(project_dir, APPS_DIR)
try:
    other_apps = [d for d in os.listdir(apps_path)
                  if os.path.isdir(os.path.join(apps_path, d)) and d != current_app]
except OSError:
    sys.exit(0)

if not other_apps:
    sys.exit(0)

try:
    with open(file_path, "r") as f:
        content = f.read()
except (IOError, OSError):
    sys.exit(0)

violations = []
for line_num, line in enumerate(content.splitlines(), 1):
    if not re.match(r'\s*(import|from)\s', line):
        continue
    for app in other_apps:
        patterns = [
            f"apps/{app}",
            f"@crondigest/{app}",
            f"../{app}",
            f"../../{app}",
        ]
        for pat in patterns:
            if pat in line:
                violations.append(f"  Line {line_num}: imports from app '{app}' -> {line.strip()}")
                break

if violations:
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PostToolUse",
            "additionalContext": (
                f"[IMPORT BOUNDARY] Cross-app imports detected in {os.path.basename(file_path)}. "
                f"Apps must only import from packages/*, never from other apps.\n"
                + "\n".join(violations)
            )
        }
    }
    print(json.dumps(output))

sys.exit(0)
