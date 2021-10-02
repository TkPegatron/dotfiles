export LANG=en_US.UTF-8
export LC_TIME=en_AU.UTF-8
export KUBECONFIG=~/kubeconfig
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export GTK_USE_PORTAL=1
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

#TODO: Move ZSHrc
#if [[ -z "$XDG_CONFIG_HOME" ]]
#then
#        export XDG_CONFIG_HOME="$HOME/.config"
#fi
#
#if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
#then
#        export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
#fi
