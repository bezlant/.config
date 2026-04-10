# --- Basic editor aliases ---
alias vim="nvim"
alias vi="nvim"

# --- eza ---
alias la="eza --icons -l -g -a"
alias ls="eza --icons -F --sort=name --oneline"
alias tree="ls -T"

# --- build and dev tools ---
alias gcl="git clone"
function cd --wraps z --description "zoxide with builtin cd fallback"
    z $argv 2>/dev/null; or builtin cd $argv
end
alias lg="lazygit"
alias nrc='vim -c "cd $HOME/.config/nvim" -c "lua require(\'oil\').open()"'

# --- tmux ---
alias tn='tmux new-session -s'
function tp
    set -l name (basename (pwd) | string replace -a '.' '-')
    tmux new-session -As $name
end

# --- claude ---
alias ccy='claude --dangerously-skip-permissions --teammate-mode tmux'

# --- misc commands ---
alias fishrc='vim -c "cd $HOME/.config/fish" -c "lua require(\'oil\').open()"'

# --- yt-dlp helpers ---
alias ytd='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias ytt='yt-dlp --write-thumbnail --skip-download'
alias yts='yt-dlp --write-auto-sub --sub-format "srt" --sub-langs "ru" --skip-download'
