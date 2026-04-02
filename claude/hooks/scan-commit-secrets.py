#!/usr/bin/env python3
"""
Pre-commit Security Hook: Scan for secrets in git commits
Runs before git commit to check for API keys, passwords, tokens
"""
import json
import sys
import re
import subprocess

# Patterns that indicate potential secrets
SECRET_PATTERNS = [
    # API Keys
    (r'api[_-]?key[\s]*[=:]\s*["\']?[a-zA-Z0-9]{20,}', 'API Key'),
    (r'apikey[\s]*[=:]\s*["\']?[a-zA-Z0-9]{20,}', 'API Key'),

    # AWS
    (r'AKIA[0-9A-Z]{16}', 'AWS Access Key'),
    (r'aws[_-]?secret[_-]?access[_-]?key[\s]*[=:]\s*["\']?[a-zA-Z0-9/+=]{40}', 'AWS Secret Key'),

    # Generic secrets
    (r'secret[\s]*[=:]\s*["\']?[a-zA-Z0-9]{20,}', 'Generic Secret'),
    (r'password[\s]*[=:]\s*["\']?[^\s]{8,}', 'Password'),
    (r'token[\s]*[=:]\s*["\']?[a-zA-Z0-9]{20,}', 'Token'),

    # Anthropic/OpenAI
    (r'sk-ant-[a-zA-Z0-9\-]{95}', 'Anthropic API Key'),
    (r'sk-[a-zA-Z0-9]{48}', 'OpenAI API Key'),

    # GitHub
    (r'gh[pousr]_[a-zA-Z0-9]{36,}', 'GitHub Token'),

    # Private keys
    (r'-----BEGIN (RSA |EC |DSA )?PRIVATE KEY-----', 'Private Key'),
]

def scan_diff_for_secrets():
    """Scan staged git diff for potential secrets"""
    try:
        # Get the diff of staged changes
        result = subprocess.run(
            ['git', 'diff', '--cached'],
            capture_output=True,
            text=True,
            timeout=5
        )

        if result.returncode != 0:
            return []

        diff_content = result.stdout
        findings = []

        # Scan for secret patterns
        for pattern, secret_type in SECRET_PATTERNS:
            matches = re.finditer(pattern, diff_content, re.IGNORECASE)
            for match in matches:
                # Only flag additions (lines starting with +)
                lines = diff_content[:match.start()].split('\n')
                last_line = lines[-1] if lines else ''

                if last_line.startswith('+'):
                    findings.append({
                        'type': secret_type,
                        'pattern': pattern[:50],  # Truncate for readability
                        'match': match.group()[:50]  # Show partial match
                    })

        return findings

    except subprocess.TimeoutExpired:
        print("Warning: git diff timed out", file=sys.stderr)
        return []
    except Exception as e:
        print(f"Warning: Could not scan diff: {e}", file=sys.stderr)
        return []

def main():
    try:
        # Read the tool input
        data = json.load(sys.stdin)
        tool_input = data.get('tool_input', {})
        command = tool_input.get('command', '')

        # Only check git commit commands
        if 'git commit' not in command:
            sys.exit(0)

        # Scan for secrets
        findings = scan_diff_for_secrets()

        if findings:
            print("⚠️  SECURITY WARNING: Potential secrets detected in commit!", file=sys.stderr)
            print("", file=sys.stderr)
            for finding in findings[:5]:  # Show first 5 findings
                print(f"  - {finding['type']}: {finding['match']}...", file=sys.stderr)
            print("", file=sys.stderr)
            print("Please review the changes and ensure no secrets are being committed.", file=sys.stderr)
            print("If these are false positives, you can proceed.", file=sys.stderr)
            # Don't block, just warn (exit 0)
            # If you want to block, change to: sys.exit(2)

        sys.exit(0)

    except Exception as e:
        print(f"Hook error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
