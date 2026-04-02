#!/usr/bin/env bash
# PreToolUse hook: block bash search commands that would scan node_modules.
# Built-in Grep/Glob tools already respect .gitignore — this catches Bash fallbacks.
# Exit 0 = allow, exit 2 = block (stdout shown to Claude as reason).

set -euo pipefail

# Parse command from JSON stdin (jq is fast, ~3ms)
CMD=$(jq -r '.tool_input.command // ""' 2>/dev/null) || exit 0

# Only check search commands
case "$CMD" in
  *grep*|*find*|*rg*|*ack*|*ag\ *)
    ;;
  *)
    exit 0
    ;;
esac

# Allow if command already excludes node_modules
if [[ "$CMD" == *"--exclude-dir"*"node_modules"* ]] || \
   [[ "$CMD" == *"--glob"*"!node_modules"* ]] || \
   [[ "$CMD" == *"-not -path"*"node_modules"* ]] || \
   [[ "$CMD" == *"--ignore-dir"*"node_modules"* ]] || \
   [[ "$CMD" == *"-prune"*"node_modules"* ]]; then
  exit 0
fi

# Block recursive grep/find that would hit node_modules
# grep -r / grep -R / grep --include (implies recursive)
if echo "$CMD" | grep -qE 'grep\s+(-[a-zA-Z]*[rR]|--recursive|--include)'; then
  # Allow if searching a specific file/dir that isn't . or /
  # e.g. "grep -r foo src/" is fine, "grep -r foo ." is not
  if echo "$CMD" | grep -qE 'grep\s+.*\s+\.$|grep\s+.*\s+/$|grep\s+.*\s+\*$'; then
    echo "Use the built-in Grep tool instead — it respects .gitignore and skips node_modules. Or add --exclude-dir=node_modules."
    exit 2
  fi
fi

# Block find from project root without node_modules exclusion
if echo "$CMD" | grep -qE '^find\s+\.\s|^find\s+\./\s'; then
  echo "Use the built-in Glob tool instead — it respects .gitignore. Or add: -not -path '*/node_modules/*'"
  exit 2
fi

# Block rg --no-ignore (overrides .gitignore, scans node_modules)
if echo "$CMD" | grep -qE 'rg\s+.*--no-ignore'; then
  echo "rg --no-ignore will scan node_modules. Remove --no-ignore or add --glob '!node_modules/'."
  exit 2
fi

exit 0
