# tmux-claude:session-name
function claude --wraps=claude --description "Claude Code with auto-patches and optimized env"
    # Env vars for reduced overhead
    set -lx DISABLE_TELEMETRY 1
    set -lx CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC 1

    # Session tagging for crash recovery (from tmux-claude plugin).
    # Must run BEFORE patching block since early returns skip later code.
    set -l extra_args
    if functions -q __tmux_claude_session_args
        set extra_args (__tmux_claude_session_args $argv)
    end

    set -l real_bin (command -s claude)
    if test -z "$real_bin"
        echo "[cc-patch] claude binary not found in PATH" >&2
        return 1
    end

    # Resolve symlink to actual version binary
    set -l target (realpath $real_bin)
    set -l marker "$target.cc-patched"

    # Patch if this version hasn't been patched yet
    if not test -f $marker
        set -l patch_script "$HOME/.claude/patches/cache-1h.py"
        if not test -f $patch_script
            echo "[cc-patch] patch script missing: $patch_script" >&2
            command claude $extra_args $argv
            return $status
        end

        echo "[cc-patch] new version detected, patching..." >&2
        python3 $patch_script $target >&2
        set -l patch_status $status

        if test $patch_status -ne 0
            echo "[cc-patch] patch FAILED — running unpatched" >&2
            command claude $extra_args $argv
            return $status
        end

        # Verify the binary still runs
        set -l version_output (command claude --version 2>&1)
        if test $status -ne 0
            echo "[cc-patch] patched binary broken — reinstall with: claude update" >&2
            return 1
        end

        echo $version_output >$marker
        echo "[cc-patch] done ($version_output)" >&2
    end

    command claude $extra_args $argv
end
