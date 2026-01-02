# Initialize Homebrew first (needed for brew commands in other configs)
/opt/homebrew/bin/brew shellenv | source

starship init fish | source
zoxide init fish | source
