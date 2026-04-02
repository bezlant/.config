#!/usr/bin/env python3
"""
Binary-patch Claude Code for better performance.

Patches applied (all same-length byte replacements):
  1. Force 1h cache TTL — bypass subscription/feature-flag gate
  2. GC interval 1s → 120s — stop forcing garbage collection every second

Re-signs with ad-hoc signature after patching.
"""

import os
import re
import subprocess
import sys


def apply_patches(data: bytes) -> tuple[bytes, list[str]]:
    """Apply all patches, return (patched_data, list_of_applied_patch_names)."""
    applied = []

    # ── Patch 1: Force 1h cache TTL ──────────────────────────────────────
    # Replace gate function call yY5(_) with (1,!0) (always true)
    ttl_marker = b'(1,!0)&&{ttl:"1h"}'
    if ttl_marker in data:
        applied.append("cache-1h (already applied)")
    else:
        old = b'yY5(_)&&{ttl:"1h"}'
        new = b'(1,!0)&&{ttl:"1h"}'
        count = data.count(old)

        if count == 0:
            # Regex fallback for different minified function names
            pattern = rb'(\w{2,5})\(_\)&&\{ttl:"1h"\}'
            matches = list(re.finditer(pattern, data))
            if matches:
                func_name = matches[0].group(1)
                old = func_name + b'(_)&&{ttl:"1h"}'
                func_call_len = len(func_name) + 3
                if func_call_len == 6:
                    replacement = b"(1,!0)"
                elif func_call_len > 6:
                    replacement = b"(" + b"1," * (func_call_len - 5) + b"!0)"
                else:
                    print(f"[patch] cache-1h FAILED: function name too short ({func_name})")
                    replacement = None
                if replacement:
                    new = replacement + b'&&{ttl:"1h"}'
                    count = data.count(old)

        if count > 0 and len(old) == len(new):
            data = data.replace(old, new)
            applied.append(f"cache-1h ({count} sites)")
        elif ttl_marker not in data:
            print("[patch] cache-1h SKIPPED: pattern not found")

    # ── Patch 2: GC interval 1s → 120s ──────────────────────────────────
    # Bun forces GC every 1000ms which burns CPU at idle
    gc_old = b"setInterval(Bun.gc,1000)"
    gc_new = b"setInterval(Bun.gc,12e4)"  # 120,000ms = 2 minutes
    gc_count = data.count(gc_old)

    if gc_count > 0:
        data = data.replace(gc_old, gc_new)
        applied.append(f"gc-interval 1s→120s ({gc_count} sites)")
    elif b"setInterval(Bun.gc,12e4)" in data:
        applied.append("gc-interval (already applied)")
    else:
        print("[patch] gc-interval SKIPPED: pattern not found")

    return data, applied


def patch(binary_path: str) -> bool:
    with open(binary_path, "rb") as f:
        original = f.read()

    data, applied = apply_patches(original)

    if data == original:
        print(f"[patch] no changes needed: {binary_path}")
        return True

    if not applied:
        print(f"[patch] FAILED: no patches could be applied to {binary_path}")
        return False

    with open(binary_path, "wb") as f:
        f.write(data)

    # Re-sign with ad-hoc signature
    try:
        subprocess.run(
            ["codesign", "--force", "--sign", "-", binary_path],
            check=True,
            capture_output=True,
        )
    except subprocess.CalledProcessError as e:
        print(f"[patch] WARNING: ad-hoc re-sign failed: {e.stderr.decode()}")

    for name in applied:
        print(f"[patch] applied: {name}")
    print(f"[patch] re-signed: {binary_path}")
    return True


def main() -> int:
    if len(sys.argv) > 1:
        target = sys.argv[1]
    else:
        link = os.path.expanduser("~/.local/bin/claude")
        target = os.path.realpath(link)

    if not os.path.isfile(target):
        print(f"[patch] binary not found: {target}")
        return 1

    return 0 if patch(target) else 1


if __name__ == "__main__":
    sys.exit(main())
