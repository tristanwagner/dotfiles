#!/usr/bin/env python3
"""
Dependency-aware anti-pattern detection hook for Droid (PostToolUse).
After Edit/Create on code files, checks if the edited file uses raw APIs
that an installed library should handle instead.

Configure patterns in ~/.factory/dep-antipatterns.json:
[
  {
    "dependency": "@tanstack/react-query",
    "banned": ["fetch(", "axios(", "axios.get(", "axios.post("],
    "message": "Use @tanstack/react-query hooks instead of raw fetch/axios"
  }
]

Falls back to sensible defaults if no config file exists.
"""
import json
import sys
import os

DEFAULTS = [
    {
        "dependency": "@tanstack/react-query",
        "banned": ["fetch("],
        "extensions": [".ts", ".tsx", ".js", ".jsx"],
        "exclude": ["query", "api", "fetcher", "client"],
        "message": "Use @tanstack/react-query hooks instead of raw fetch()"
    },
    {
        "dependency": "drizzle-orm",
        "banned": ["db.execute(", ".query(", "sql`"],
        "extensions": [".ts", ".js"],
        "exclude": ["migration", "schema", "drizzle"],
        "message": "Use Drizzle query builder instead of raw SQL"
    },
    {
        "dependency": "zod",
        "banned": ["JSON.parse("],
        "extensions": [".ts", ".tsx", ".js", ".jsx"],
        "exclude": ["parse", "schema", "config"],
        "message": "Validate with Zod instead of raw JSON.parse()"
    },
    {
        "dependency": "date-fns",
        "banned": ["new Date().toLocaleDateString(", "new Date().toLocaleString("],
        "extensions": [".ts", ".tsx", ".js", ".jsx"],
        "exclude": [],
        "message": "Use date-fns for date formatting instead of toLocaleString"
    },
]

def load_config():
    config_path = os.path.expanduser("~/.factory/dep-antipatterns.json")
    try:
        with open(config_path, "r") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return DEFAULTS

def find_package_json(project_dir):
    if not project_dir:
        return None
    pkg_path = os.path.join(project_dir, "package.json")
    if os.path.exists(pkg_path):
        try:
            with open(pkg_path, "r") as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            pass
    return None

def get_installed_deps(pkg):
    if not pkg:
        return set()
    deps = set()
    for key in ("dependencies", "devDependencies", "peerDependencies"):
        deps.update(pkg.get(key, {}).keys())
    return deps

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

tool_input = data.get("tool_input", {})
file_path = tool_input.get("file_path", "")

if not file_path:
    sys.exit(0)

patterns = load_config()
project_dir = os.environ.get("FACTORY_PROJECT_DIR", data.get("cwd", ""))
pkg = find_package_json(project_dir)
installed = get_installed_deps(pkg)

if not installed:
    sys.exit(0)

ext = os.path.splitext(file_path)[1]
basename = os.path.basename(file_path).lower()

warnings = []
for rule in patterns:
    dep = rule["dependency"]
    if dep not in installed:
        continue
    allowed_ext = rule.get("extensions", [".ts", ".tsx", ".js", ".jsx"])
    if ext not in allowed_ext:
        continue
    excludes = rule.get("exclude", [])
    if any(exc in basename for exc in excludes):
        continue

    try:
        with open(file_path, "r") as f:
            content = f.read()
    except (IOError, OSError):
        continue

    for banned in rule["banned"]:
        if banned in content:
            warnings.append(f"[DEP-LINT] {rule['message']} (found `{banned}` in {os.path.basename(file_path)}, but `{dep}` is installed)")
            break

if warnings:
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PostToolUse",
            "additionalContext": "\n".join(warnings)
        }
    }
    print(json.dumps(output))

sys.exit(0)
