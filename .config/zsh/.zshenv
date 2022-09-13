. "$HOME/.profile"

# Only source this once
if [[ -z "$__ZSH_SESS_VARS_SOURCED" ]]; then
  export __ZSH_SESS_VARS_SOURCED=1
  
fi

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

ZSH_SELF_EXAPWD=true


HISTFILE="$HOME/.config/zsh/zsh_history"
HISTSIZE="500000"
SAVEHIST="500000"
