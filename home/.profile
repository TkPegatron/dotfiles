# Only source this once.
if [ -n "$__SESS_VARS_SOURCED" ]; then return; fi
export __SESS_VARS_SOURCED=1

typeset -U path  # No duplicates
_prepath() {
    for dir in "$@"; do
        dir=${dir:A}
        [[ ! -d "$dir" ]] && return
        path=("$dir" $path[@])
    done
}
_postpath() {
    for dir in "$@"; do
        dir=${dir:A}
        [[ ! -d "$dir" ]] && return
        path=($path[@] "$dir")
    done
}

_postpath "$HOME/.local/bin"

# Set Locales
#export LANG="en_US.UTF-8"
#export LC_ALL="en_US.UTF-8"
#export LC_CTYPE="en_US.UTF-8"

export GNUPGHOME="$HOME/.config/gnupg"
export PAGER="less -FirSwX"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"
export TMUX_TMPDIR="${XDG_RUNTIME_DIR:-"/run/user/\$(id -u)"}"
export MANPAGER="sh -c 'col -bx | $(which bat) -l man -p'"
export MANROFFOPT="-c"

export SKIM_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."

# Default editor to vi-improved
export EDITOR="vim"
export VISUAL="vim"

# XDG Specs
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export SHELL_NERD_FONT_AVAILABLE=false

if $SHELL_NERD_FONT_AVAILABLE; then
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/nf-singleline.toml"
    export STARSHIP_OS_ICON=""
else
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/bf-singleline.toml"
fi

# The GnuPG Agent man pages say to add these

export GPG_TTY=$(tty)
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    gpgconf_ssh_sock=$(gpgconf --list-dirs agent-ssh-socket)
    if [[ -S $gpgconf_ssh_sock ]]; then
        export SSH_AUTH_SOCK=$gpgconf_ssh_sock
    elif [[ -S /run/user/1000/gnupg/S.gpg-agent.ssh ]]; then
        export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh
    fi
fi
