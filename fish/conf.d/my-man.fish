# --- Dracula manpage colors (SGR mode, Ghostty compatible) ---

# wrap to 120 chars
set -gx MANWIDTH 120

# use less with raw ANSI support
set -gx MANPAGER "less -R"
set -gx LESS "-R"

set -gx LESS_TERMCAP_mb (printf "\e[1;31m")
set -gx LESS_TERMCAP_md (printf "\e[1;34m")
set -gx LESS_TERMCAP_so (printf "\e[01;45;37m")
set -gx LESS_TERMCAP_us (printf "\e[01;36m")
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_ue (printf "\e[0m")
