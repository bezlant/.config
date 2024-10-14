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
alias ll="eza -l -g --icons"
alias la="ll -a"
alias ls="eza --icons -F --sort=name --oneline"
alias tree="ls -T"
alias bmake='bear -- make'
alias clang-dump="clang-format -style=llvm -dump-config > .clang-format"
alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=valgrind_result.txt'
alias gcl='git clone'
alias lg='lazygit'
alias nrc='nvim $HOME/.config/nvim/ -c "cd $HOME/.config/nvim/"'
alias zshrc='vim $HOME/.zshrc'
alias ytd='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias ytt='yt-dlp --write-thumbnail --skip-download'
alias yts='yt-dlp --write-auto-sub --sub-format "srt" --sub-langs "ru" --skip-download'
alias wtj='for i in *.webp; do ffmpeg -i "${i}" -q:v 1 -bsf:v mjpeg2jpeg "${i%.webp}.jpg"; done && rm *.webp'
alias cleanup='rm -rf *.jpg && rm -rf -- *.mp4 && rm -rf -- *.mp3 && rm -rf -- *.png && rm -rf done/*'
alias libgen='libgen-downloader'
alias -g -- -h='-h 2>&1 | bat --language=help --style=grid'
alias -g -- --help='--help 2>&1 | bat --language=help --style=grid'
export FZF_DEFAULT_COMMAND="fd --type f --follow --hidden --max-depth 8 --color=never"

# Exports
export XDG_CONFIG_HOME="$HOME/.config"
export GPG_TTY=$(tty)
export HISTFILE="$HOME/.cache/.zsh_history"
export LESSHISTFILE="$HOME/.cache/.less_history"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$(brew --prefix python@3.10)/libexec/bin:$PATH"
export PATH="$PATH:$HOME/.spoof-dpi/bin"
export NVM_DIR="$HOME/.nvm"

export VAULT="/opt/homebrew/bin/vault"
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
fi

# Functions
ytdl() {
    local url="$1"
    local output_template="$2"

    # vot-cli --output "$output_template" "$url" &
    ytd "$url" -o "$output_template"  
    ytt "$url" -o "$output_template"  
    wtj
    overlay "$output_template"
}

concat() {
    ffmpeg -f concat -safe 0 -i "$1" -c copy "$1_concat.mp4"
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

# Created by `pipx` on 2023-11-01 11:03:05
export PATH="$PATH:/Users/abezlyudniy/.local/bin"
