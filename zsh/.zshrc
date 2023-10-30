# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 14

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.config/zsh

# Plugins
plugins=(
  aliases
  brew
  colored-man-pages 
  copyfile
  copypath
  npm
  nvm
  sudo
  tmux
  vi-mode
  web-search
  yarn
  zsh-autosuggestions 
  zsh-fzf-history-search
  zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh

# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Keybindings
bindkey '^I' autosuggest-accept

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# Aliases
alias vim='nvim'
alias vi='nvim'
alias ll="exa -l -g --icons"
alias la="ll -a"
alias ls="exa --icons -F --sort=name --oneline"
alias tree="ls -T"
alias bmake='bear -- make'
alias clang-dump="clang-format -style=llvm -dump-config > .clang-format"
alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=valgrind_result.txt'
alias gcl='git clone'
alias lg='lazygit'
alias nrc='nvim $HOME/.config/nvim/lua/config/plugins.lua -c "cd $HOME/.config/nvim/"'
alias zshrc='vim $HOME/.zshrc'
alias ytd='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias ytt='yt-dlp --write-thumbnail --skip-download'
alias wtj='for i in *.webp; do ffmpeg -i "${i}" -q:v 1 -bsf:v mjpeg2jpeg "${i%.webp}.jpg"; done && rm *.webp'
alias cleanup='rm -rf *.jpg && rm -rf -- *.mp4 && rm -rf -- *.mp3 && rm -rf -- *.png && rm -rf done/*'

# Exports
export XDG_CONFIG_HOME="$HOME/.config"
export GPG_TTY=$(tty)
export EDITOR=nvim
export VISUAL=nvim
export HISTFILE="$HOME/.cache/.zsh_history"
export LESSHISTFILE="$HOME/.cache/.less_history"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export NVM_DIR="$HOME/.nvm"

export VAULT="/opt/homebrew/bin/vault"
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# Functions
ytdl() {
    local url="$1"
    local output_template="$2"
    
    ytd "$url" -o "$output_template"  
    ytt "$url" -o "$output_template"  
    wtj
    overlay "$output_template"
}

autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
