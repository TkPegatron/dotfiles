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
export KUBECONFIG="$XDG_CONFIG_HOME/kubeconfig"
export LESSHISTFILE="-"
export FZF_DEFAULT_OPTS='
--color fg:242,hl:65,fg+:15,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'

if [ -f "$HOME/.gnupg/gpg.conf" ]; then
  export GPG_TTY="$(tty)"
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
  gpg-connect-agent updatestartuptty /bye > /dev/null
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
        ssh-add > /dev/null
   fi
   eval `cat $HOME/.ssh/ssh-agent`
fi

#=============

if command -v nvim >/dev/null; then
    
    if [[ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ]]; then
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi

    alias vim="nvim"
    alias vi="nvim"
    alias vimdiff="nvim -d"
    
    export EDITOR=nvim
elif command -v vi >/dev/null && [[ $(vi --version | head -n 1 | awk '{print $1}') == "VIM" ]]\
  || command -v vim >/dev/null ; then

    if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    command -v vi >/dev/null && export EDITOR=vim \
    || command -v vim >/dev/null && export EDITOR=vim

elif command -v vi >/dev/null; then
    export EDITOR=vi
fi
