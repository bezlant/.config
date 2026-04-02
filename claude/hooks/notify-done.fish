#!/opt/homebrew/bin/fish
# Claude finished — switch if outside Ghostty, highlight if inside, play chime

# afplay ~/.claude/sounds/done-chime.aiff -v 0.5 &

test -z "$TMUX"; and exit 0

set frontmost (osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null | string lower)

if test "$frontmost" != ghostty
    osascript -e 'tell application "Ghostty" to activate' 2>/dev/null
    /opt/homebrew/bin/tmux select-window -t "$TMUX_PANE" 2>/dev/null
    /opt/homebrew/bin/tmux select-pane -t "$TMUX_PANE" 2>/dev/null
else
    set pane_tty (/opt/homebrew/bin/tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
    test -n "$pane_tty"; and printf '\a' > "$pane_tty" 2>/dev/null
end
