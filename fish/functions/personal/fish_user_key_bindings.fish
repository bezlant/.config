function fish_user_key_bindings
    fish_vi_key_bindings

    # Bind "p" in normal mode to paste from system clipboard
    bind -M default p 'commandline -i (pbpaste)'

    # Bind Ctrl+F to open nvim with Snacks picker files
    bind -M insert \cf 'commandline -r ""; nvim -c "lua Snacks.picker.files()"'
    bind -M default \cf 'commandline -r ""; nvim -c "lua Snacks.picker.files()"'
end
