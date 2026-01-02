function fish_user_key_bindings
    fish_vi_key_bindings

    # Bind "p" in normal mode to paste after cursor (vim behavior)
    bind -M default -s p 'set -g fish_cursor_end_mode exclusive' forward-char 'set -g fish_cursor_end_mode inclusive' fish_clipboard_paste
    # Bind "P" in normal mode to paste before cursor (vim behavior)
    bind -M default -s P fish_clipboard_paste


    # Cursor shapes (visual feedback for mode)
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_replace underscore
    set -g fish_cursor_visual block

    # Bind Ctrl+F to open nvim with Snacks picker files
    bind -M insert \cf 'commandline -r ""; nvim -c "lua Snacks.picker.files()"'
    bind -M default \cf 'commandline -r ""; nvim -c "lua Snacks.picker.files()"'
end
