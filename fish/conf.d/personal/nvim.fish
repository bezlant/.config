# --- Neovim / NVR integration ---
if set -q NVIM_LISTEN_ADDRESS
    # When inside an existing Neovim session
    set -gx VISUAL "nvr -cc split --remote-wait +'set bufhidden=wipe'"
    set -gx EDITOR $VISUAL

    function nvim
        nvr -cc split --remote-wait +'set bufhidden=wipe' $argv
    end
else
    # Normal terminal usage
    set -gx VISUAL nvim
    set -gx EDITOR nvim
end
