#!/usr/bin/env bash
PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"
exec 2>/dev/null

SOCKET="$HOME/.mpv-audio.sock"

if [ ! -S "$SOCKET" ]; then
  exit 0
fi

track=$(
  printf '{ "command": ["get_property", "path"] }\n' \
  | socat - UNIX-CONNECT:"$SOCKET" \
  | sed -n 's/.*"data":"\([^"]*\)".*/\1/p'
)

# Hide if no track is playing
[ -z "$track" ] && exit 0

title=$(basename "$track")

paused=$(
  printf '{ "command": ["get_property", "pause"] }\n' \
  | socat - UNIX-CONNECT:"$SOCKET" \
  | grep -q '"data":true' && printf "yes" || printf "no"
)

icon="▶︎"
[ "$paused" = "no" ] && icon="⏸"

printf "♫ %s %s\n" "$icon" "$title"
printf "---\n"
printf "Play / Pause | bash=%s terminal=false\n" "$HOME/.local/bin/mpv-play"
printf "Stop | bash=%s terminal=false\n" "$HOME/.local/bin/mpv-stop"
