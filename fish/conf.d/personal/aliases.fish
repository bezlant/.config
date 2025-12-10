# --- Basic editor aliases ---
alias vim="nvim"
alias vi="nvim"

# --- eza ---
alias la="eza --icons -l -g -a"
alias ls="eza --icons -F --sort=name --oneline"
alias tree="ls -T"

# --- build and dev tools ---
alias gcl="git clone"
alias cd="z"
alias lg="lazygit"
alias nrc='vim $HOME/.config/nvim -c "cd $HOME/.config/nvim"'

# --- misc commands ---
alias fishrc='vim $HOME/.config/fish -c "cd $HOME/.config/fish"' 
alias libgen="libgen-downloader"

# --- yt-dlp helpers ---
alias ytd='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias ytt='yt-dlp --write-thumbnail --skip-download'
alias yts='yt-dlp --write-auto-sub --sub-format "srt" --sub-langs "ru" --skip-download'
