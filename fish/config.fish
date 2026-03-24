# Android SDK
set -gx ANDROID_HOME /opt/homebrew/share/android-commandlinetools
set -gx ANDROID_SDK_ROOT /opt/homebrew/share/android-commandlinetools
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools

starship init fish | source
zoxide init fish | source
pyenv init - | source

alias notes='nvim "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/"'
alias cdo='cd "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/"'
