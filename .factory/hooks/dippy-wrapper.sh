#!/usr/bin/env bash
# Wrapper for Dippy that translates Droid's "Execute" tool name to
# Claude Code's "Bash" tool name, since Dippy only recognizes "Bash".
set -euo pipefail

if ! command -v dippy &>/dev/null; then
  exit 0
fi

if ! command -v jq &>/dev/null; then
  exit 0
fi

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

if [ "$TOOL" != "Execute" ]; then
  exit 0
fi

echo "$INPUT" | jq '.tool_name = "Bash"' | dippy --claude
