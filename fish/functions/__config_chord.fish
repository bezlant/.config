function __config_chord
    # Display hint (will be on the same line as the prompt)
    echo -n '[n=nvim, f=fish, t=tmux, g=ghostty] '

    # Read a single character
    read -n 1 -P '' key

    # Clear the hint
    commandline -f repaint

    # Execute based on the key pressed
    switch $key
        case n
            commandline -r ''
            nvim -c "cd $HOME/.config/nvim" -c "lua require('oil').open()"
        case f
            commandline -r ''
            nvim -c "cd $HOME/.config/fish" -c "lua require('oil').open()"
        case t
            commandline -r ''
            nvim -c "cd $HOME/.config/tmux" -c "lua require('oil').open()"
        case g
            commandline -r ''
            nvim -c "cd $HOME/.config/ghostty" -c "lua require('oil').open()"
        case '*'
            # Invalid key, just repaint
            commandline -f repaint
    end
end
