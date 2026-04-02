#!/usr/bin/env python3
"""Pre-push hook: run typecheck and lint before any git push.

Exit codes:
  0 = checks passed, allow push
  2 = checks failed, block push and feed errors to Claude
"""
import json
import sys
import subprocess
import os


def find_project_root():
    """Find the git project root from current directory."""
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except Exception:
        pass
    return os.getcwd()


def main():
    try:
        data = json.load(sys.stdin)
        tool_input = data.get("tool_input", {})
        command = tool_input.get("command", "")

        if "git push" not in command:
            sys.exit(0)

        project_root = find_project_root()
        makefile = os.path.join(project_root, "Makefile")

        if not os.path.isfile(makefile):
            sys.exit(0)

        # Only run targets that exist in the Makefile
        with open(makefile, "r") as f:
            makefile_content = f.read()

        typecheck = None
        if "typecheck:" in makefile_content:
            typecheck = subprocess.run(
                ["make", "typecheck"],
                capture_output=True, text=True, timeout=120,
                cwd=project_root
            )

        lint = None
        if "lint:" in makefile_content:
            lint = subprocess.run(
                ["make", "lint"],
                capture_output=True, text=True, timeout=60,
                cwd=project_root
            )

        errors = []
        if typecheck and typecheck.returncode != 0:
            output = (typecheck.stdout + typecheck.stderr).strip()
            errors.append(f"=== make typecheck FAILED ===\n{output}")
        if lint and lint.returncode != 0:
            output = (lint.stdout + lint.stderr).strip()
            errors.append(f"=== make lint FAILED ===\n{output}")

        if errors:
            print(
                "Pre-push checks failed. Fix these errors before pushing:\n\n"
                + "\n\n".join(errors),
                file=sys.stderr
            )
            sys.exit(2)

        sys.exit(0)

    except Exception as e:
        print(f"Hook error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
