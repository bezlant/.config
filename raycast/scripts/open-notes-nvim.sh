#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Notes (Neovim)
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ✏️
# @raycast.packageName Notes

VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/"

if tmux info &>/dev/null; then
  # tmux is running — open in a new window
  tmux new-window -n notes -c "$VAULT" nvim
  open -a Ghostty
else
  # No tmux — just open Ghostty with nvim
  open -a Ghostty --args -e bash -c "cd '$VAULT' && nvim"
fi
