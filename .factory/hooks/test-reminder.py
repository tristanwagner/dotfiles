#!/usr/bin/env python3
"""
Soft test coverage reminder hook for Droid (Stop).
When the agent finishes, checks if modified .ts/.tsx files have corresponding
test files. Provides a gentle reminder (not a block) for files that lack tests.

Skips files that rarely need tests:
  - Type-only files (types.ts, *.d.ts)
  - Schema/config files
  - Index re-exports
  - Constants/enums
  - CSS/style files
"""
import json
import sys
import os
import subprocess

SKIP_PATTERNS = [
    "types.ts", "types.tsx", ".d.ts", "schema.ts", "config.ts",
    "constants.ts", "enums.ts", "index.ts", "index.tsx",
    "router.ts", "router.tsx", "main.ts", "main.tsx",
    "vite.config", "vitest.config", "tailwind.config",
    "env.ts", "env.d.ts", ".css", ".scss", ".json",
    "wrangler.toml", "alchemy.run.ts",
]

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

if data.get("stop_hook_active"):
    sys.exit(0)

project_dir = os.environ.get("FACTORY_PROJECT_DIR", data.get("cwd", ""))
if not project_dir:
    sys.exit(0)

# Get modified files in this session via git
try:
    result = subprocess.run(
        ["git", "diff", "--name-only", "HEAD"],
        cwd=project_dir,
        capture_output=True,
        text=True,
        timeout=5,
    )
    modified = [l.strip() for l in result.stdout.splitlines() if l.strip()]

    result2 = subprocess.run(
        ["git", "diff", "--cached", "--name-only"],
        cwd=project_dir,
        capture_output=True,
        text=True,
        timeout=5,
    )
    modified.extend([l.strip() for l in result2.stdout.splitlines() if l.strip()])
    modified = list(set(modified))
except (subprocess.TimeoutExpired, FileNotFoundError):
    sys.exit(0)

# Filter to code files that should have tests
untested = []
for f in modified:
    if not f.endswith((".ts", ".tsx")):
        continue
    if ".test." in f or "__tests__" in f or ".spec." in f:
        continue
    basename = os.path.basename(f)
    if any(skip in basename or skip in f for skip in SKIP_PATTERNS):
        continue

    # Check if a test file exists
    base, ext = os.path.splitext(f)
    test_candidates = [
        f"{base}.test{ext}",
        f"{base}.spec{ext}",
        f"{os.path.dirname(f)}/__tests__/{os.path.basename(base)}.test{ext}",
        f"{os.path.dirname(f)}/__tests__/{os.path.basename(base)}{ext}",
    ]
    has_test = any(os.path.exists(os.path.join(project_dir, t)) for t in test_candidates)
    if not has_test:
        untested.append(f)

if untested and len(untested) <= 5:
    files_list = "\n".join(f"  - {f}" for f in untested)
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PostToolUse",
            "additionalContext": (
                f"[TEST REMINDER] These modified files have no test files:\n{files_list}\n"
                "Consider adding tests if the changes include logic worth covering. "
                "Skip if the changes are purely cosmetic, type-only, or config."
            )
        }
    }
    # Use Stop hook output format
    output = {
        "decision": None,
        "reason": (
            f"[TEST REMINDER] These modified files have no test files:\n{files_list}\n"
            "Consider adding tests if the changes include logic worth covering."
        )
    }
    # Soft: don't block, just print to stderr for visibility
    print(f"[TEST REMINDER] {len(untested)} modified file(s) lack tests: {', '.join(os.path.basename(f) for f in untested)}", file=sys.stderr)

sys.exit(1)  # non-zero, non-2: shows stderr to user, doesn't block
