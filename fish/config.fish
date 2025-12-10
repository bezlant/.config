set -p fish_function_path "$HOME/.config/fish/functions/personal"

# Initialize Homebrew first (needed for brew commands in other configs)
/opt/homebrew/bin/brew shellenv | source

# Source all personal config files
for file in ~/.config/fish/conf.d/personal/*.fish
    source $file
end

starship init fish | source
zoxide init fish | source
