export LANG=en_US.UTF-8
export LC_TIME=en_AU.UTF-8
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# Adds `~/.local/bin` to $PATH
#export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"

export GTK_USE_PORTAL=1

# Set the default GPG recipient
export DEFAULT_RECIPIENT="elliana.perry@gmail.com"

# configure Pager
export LESSPROMPT='?f%f .?ltLine %lt:?pt%pt\%:?btByte %bt:-...'

# i = case-insensitive searches, unless uppercase characters in search string
# F = exit immediately if output fits on one screen
# M = verbose prompt
# R = ANSI color support
# X = suppress alternate screen
# -#.25 = scroll horizontally by quarter of screen width (default is half)
export LESS="-iFMRX -#.25"

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LESSHISTFILE="-"
export FZF_DEFAULT_OPTS='
--color fg:242,hl:65,fg+:15,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'
