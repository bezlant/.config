#!/usr/bin/env python3
"""
Security Hook: Block access to sensitive files
Prevents Claude from reading or modifying files that typically contain secrets
"""
import json
import sys
from pathlib import Path

# Files that should NEVER be accessed without explicit permission
SENSITIVE_FILES = {
    '.env', '.env.local', '.env.production', '.env.development',
    'secrets.json', 'credentials.json', 'config.local.json',
    'id_rsa', 'id_ed25519', 'id_ecdsa', 'id_dsa',
    '.aws/credentials', '.ssh/id_rsa', '.ssh/id_ed25519',
    'service-account.json', 'gcp-credentials.json'
}

# File extensions that are typically sensitive
SENSITIVE_EXTENSIONS = {'.pem', '.key', '.p12', '.pfx', '.keystore'}

def is_sensitive(file_path: str) -> bool:
    """Check if a file path is sensitive"""
    path = Path(file_path)

    # Check filename
    if path.name in SENSITIVE_FILES:
        return True

    # Check extension
    if path.suffix in SENSITIVE_EXTENSIONS:
        return True

    # Check if it's in .ssh or .aws directory
    if '.ssh' in path.parts or '.aws' in path.parts:
        return True

    return False

def main():
    try:
        # Read the tool input from stdin
        data = json.load(sys.stdin)
        tool_input = data.get('tool_input', {})

        # Get the file path being accessed (tool inputs vary by tool)
        file_path = (
            tool_input.get('file_path')
            or tool_input.get('path')
            or tool_input.get('source')
            or tool_input.get('target')
            or ''
        )

        if not file_path:
            # No file path, allow operation
            sys.exit(0)

        # Check if file is sensitive
        if is_sensitive(file_path):
            print(f"BLOCKED: Access to sensitive file '{file_path}' denied.", file=sys.stderr)
            print("This file typically contains secrets and should not be accessed.", file=sys.stderr)
            print("If you need to work with this file, ask the user for explicit permission.", file=sys.stderr)
            sys.exit(2)  # Exit 2 = block operation and feed stderr to Claude

        # Allow operation
        sys.exit(0)

    except Exception as e:
        print(f"Hook error: {e}", file=sys.stderr)
        sys.exit(1)  # Exit 1 = error shown to user

if __name__ == '__main__':
    main()
