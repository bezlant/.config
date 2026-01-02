# --- Neovim / NVR integration ---
if set -q NVIM
    # When inside an existing Neovim session
    set -gx VISUAL "nvr --servername $NVIM -cc split --remote-wait +'set bufhidden=wipe'"
    set -gx EDITOR $VISUAL

    function nvim
        nvr --servername $NVIM -cc split --remote-wait +'set bufhidden=wipe' $argv
    end
else
    # Normal terminal usage
    set -gx VISUAL nvim
    set -gx EDITOR nvim
end
