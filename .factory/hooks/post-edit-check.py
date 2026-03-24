#!/usr/bin/env python3
"""
Per-file typecheck + lint hook for Droid (PostToolUse on Edit|Create).
Runs language/project-aware checks on ONLY the edited file:
  - TypeScript/TSX/JS/JSX: tsc --noEmit scoped to the file's package, filtered to file
  - All supported files: biome check on just the file
  - Python: pyright/mypy on just the file (if available)
  - Go: go vet on just the file (if available)

Feeds errors back to the agent as PostToolUse additionalContext.
"""
import json
import sys
import os
import subprocess

def find_package_root(file_path, project_dir):
    """Walk up from file to find nearest package.json with a tsconfig.json sibling."""
    d = os.path.dirname(file_path)
    while d and d.startswith(project_dir) and d != project_dir:
        if os.path.exists(os.path.join(d, "tsconfig.json")):
            return d
        d = os.path.dirname(d)
    if os.path.exists(os.path.join(project_dir, "tsconfig.json")):
        return project_dir
    return None

def run_tsc(file_path, pkg_root):
    """Run tsc --noEmit in the package root, filter output to just this file."""
    try:
        result = subprocess.run(
            ["npx", "tsc", "--noEmit", "--pretty", "false"],
            cwd=pkg_root,
            capture_output=True,
            text=True,
            timeout=30,
        )
        if result.returncode != 0 and result.stdout:
            basename = os.path.basename(file_path)
            rel_from_pkg = os.path.relpath(file_path, pkg_root)
            lines = []
            for line in result.stdout.splitlines():
                if basename in line or rel_from_pkg in line:
                    lines.append(line)
            if lines:
                return lines
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return []

def run_biome(file_path, project_dir):
    """Run biome check on a single file."""
    try:
        result = subprocess.run(
            ["npx", "biome", "check", "--no-errors-on-unmatched", file_path],
            cwd=project_dir,
            capture_output=True,
            text=True,
            timeout=15,
        )
        if result.returncode != 0:
            output = (result.stdout or "") + (result.stderr or "")
            lines = [l for l in output.splitlines() if l.strip() and "Checked" not in l]
            if lines:
                return lines
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return []

def run_pyright(file_path):
    """Run pyright on a single Python file."""
    try:
        result = subprocess.run(
            ["pyright", file_path],
            capture_output=True,
            text=True,
            timeout=30,
        )
        if result.returncode != 0 and result.stdout:
            lines = [l for l in result.stdout.splitlines()
                     if "error" in l.lower() or "warning" in l.lower()]
            if lines:
                return lines
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return []

def run_go_vet(file_path):
    """Run go vet on a single Go file."""
    try:
        result = subprocess.run(
            ["go", "vet", file_path],
            capture_output=True,
            text=True,
            timeout=15,
        )
        if result.returncode != 0:
            output = (result.stdout or "") + (result.stderr or "")
            lines = [l for l in output.splitlines() if l.strip()]
            if lines:
                return lines
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return []

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

file_path = data.get("tool_input", {}).get("file_path", "")
if not file_path or not os.path.exists(file_path):
    sys.exit(0)

project_dir = os.environ.get("FACTORY_PROJECT_DIR", data.get("cwd", ""))
ext = os.path.splitext(file_path)[1].lower()
basename = os.path.basename(file_path)

# Skip non-code files, configs, and generated files
skip_patterns = [".d.ts", ".min.", "dist/", "node_modules/", ".generated.", "migrations/"]
if any(p in file_path for p in skip_patterns):
    sys.exit(0)

errors = []

# TypeScript / JavaScript
if ext in (".ts", ".tsx", ".js", ".jsx"):
    pkg_root = find_package_root(file_path, project_dir)
    if pkg_root:
        tsc_errors = run_tsc(file_path, pkg_root)
        if tsc_errors:
            errors.append(f"[TSC] Type errors in {basename}:")
            errors.extend(f"  {e}" for e in tsc_errors[:10])

    biome_errors = run_biome(file_path, project_dir)
    if biome_errors:
        errors.append(f"[BIOME] Lint/format issues in {basename}:")
        errors.extend(f"  {e}" for e in biome_errors[:10])

# Python
elif ext == ".py":
    py_errors = run_pyright(file_path)
    if py_errors:
        errors.append(f"[PYRIGHT] Type errors in {basename}:")
        errors.extend(f"  {e}" for e in py_errors[:10])

# Go
elif ext == ".go":
    go_errors = run_go_vet(file_path)
    if go_errors:
        errors.append(f"[GO VET] Issues in {basename}:")
        errors.extend(f"  {e}" for e in go_errors[:10])

else:
    sys.exit(0)

if errors:
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PostToolUse",
            "additionalContext": "\n".join(errors)
        }
    }
    print(json.dumps(output))

sys.exit(0)
