# --- Language (recommended) ---
set -gx LANG en_US.UTF-8

# --- GPG ---
set -gx GPG_TTY (tty)

# --- XDG base dirs ---
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share

# --- Homebrew (must be first to use brew command) ---
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# --- Python (Homebrew Python 3.10 shim) ---
if command -q brew
    set -l python_prefix (brew --prefix python@3.10 2>/dev/null)
    and test -d "$python_prefix/libexec/bin"
    and set -gx PATH $python_prefix/libexec/bin $PATH
end

# --- Neovim Mason binaries ---
set -gx PATH $HOME/.local/share/nvim/mason/bin $PATH

# --- pipx / local scripts ---
set -gx PATH $HOME/.local/bin $PATH

# --- FNM (Node version manager) ---
set -gx PATH "$HOME/Library/Application Support/fnm" $PATH
if command -q fnm
    fnm env --use-on-cd --shell=fish | source
end

# --- Go ---
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# --- FZF: default search command ---
set -gx FZF_DEFAULT_COMMAND 'fd --type f --follow --hidden --max-depth 8 --color=never'

set -gx LESSHISTFILE "$HOME/.cache/.less_history"
