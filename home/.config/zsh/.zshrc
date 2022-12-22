# Z-Shell Setopt

setopt no_beep                            # Disable the shell from triggering the bell
setopt hist_reduce_blanks                 # Reduce whitespace from commands
setopt complete_aliases                   # Expand aliases before completion has finished
setopt autopushd pushdminus pushdsilent   # Use pushd when cd-ing around
setopt hist_ignore_all_dups               # Filter non-contiguous duplicates from history
setopt no_flow_control                    # disable start (C-s) and stop (C-q) characters
setopt rematch_pcre                       # Match regular expressions using PCRE if available
setopt pushd_ignore_dups                  # don't push multiple copies of same dir onto stack
setopt auto_param_slash                   # tab completing directory appends a slash
setopt share_history                      # share history between shell processes


# - { Helper Functions } ------------------------------------------------------------------- #
_exists() { (( $+commands[$1] )) }

# - { Antigen } ---------------------------------------------------------------------------- #
if [ -f "${ANTIGEN_ZSH_BIN}" ]; then
  typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc $ANTIGEN_ZSH_BIN)
  source "${ANTIGEN_ZSH_BIN}"

  # Use Oh-My-Zsh plugins
  antigen use oh-my-zsh

  # Oh-My-Zsh Bundles
  antigen bundle git
  antigen bundle pip
  antigen bundle sudo
  antigen bundle python
  antigen bundle virtualenv
  antigen bundle command-not-found

  # External Bundles
  antigen bundle chrissicool/zsh-256color
  antigen bundle z-shell/F-Sy-H --branch=main
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-completions
  antigen bundle Tarrasch/zsh-autoenv


  # Conditional Bundles
  if _exists sk; then
    antigen bundle casonadams/skim.zsh
  elif _exists fzf; then
    antigen bundle fzf
  else
    true
  fi

  antigen apply
fi

# -- { Shell Hooks } ----------------------------------------------------------------------- #

if [ x$ZSH_SELF_EXAPWD = xtrue ]; then
  # Define a function to list directories with exa and add it as a hook
  function -auto-ls-after-cd() {
    emulate -L zsh
    # Only in response to a user-initiated `cd`, not indirectly (eg. via another function).
    if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
      if $SHELL_NERD_FONT_AVAILABLE; then command -v exa > /dev/null && exa --icons --only-dirs || ls; fi
      if ! $SHELL_NERD_FONT_AVAILABLE; then command -v exa > /dev/null && exa --only-dirs || ls; fi
    fi
  }
  add-zsh-hook chpwd -auto-ls-after-cd
fi

# Initialize Starship Prompt if available
if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
  _exists starship && eval "$(starship init zsh)"
fi

# Hook direnv if available
_exists direnv && eval "$(direnv hook zsh)"

# - { Aliases } ---------------------------------------------------------------------------- #
alias ip='ip --color=auto'
alias mtr='mtr -n -o '\''LSRDNBAW'\'''

if _exists nvim; then
  export EDITOR='nvim'
  export VISUAL='nvim'
  alias vi='nvim'
  alias vim='nvim'
fi 

### Replace ls with exa if available
if _exists exa; then
  if $SHELL_NERD_FONT_AVAILABLE; then
    alias ls='exa --icons'
    alias ll='exa -l --icons'
    alias la='exa -a --icons'
    alias lla='exa -la --icons'
    alias lt='exa --tree --icons'
  else
    alias ls='exa'
    alias ll='exa -l'
    alias la='exa -a'
    alias lla='exa -la'
    alias lt='exa --tree'
  fi
fi

### Replace cat(1) with bat if available
if _exists bat; then
  alias cat='bat --plain --paging=never'
  batf() { tail -f "$1" | bat --plain --paging=never; }
  batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
  }
  help() {
    "$@" --help 2>&1 | bat --plain --language=help --paging=never
  }
fi

skpreview() {
  sk --ansi -i --preview "tui_preview.sh {}" "$@"
}

### Typoing sudo will still call sudo, preserving the user's path
alias sudo='sudo env PATH=$PATH '
alias sudu='sudo env PATH=$PATH '
alias sodo='sudo env PATH=$PATH '
alias sodu='sudo env PATH=$PATH '
alias sdoo='sudo env PATH=$PATH '
alias sduo='sudo env PATH=$PATH '

# - { Keybinds } ---------------------------------------------------------------------------- #
bindkey -e
#if [[ "${terminfo[khome]}" != "" ]]; then
#  bindkey "${terminfo[khome]}" beginning-of-line
#else
#  bindkey '^[[7~' beginning-of-line
#  bindkey '^[[H' beginning-of-line
#fi

#if [[ "${terminfo[kend]}" != "" ]]; then
#  bindkey "${terminfo[kend]}" end-of-line
#else
#  bindkey '^[[8~' end-of-line
#  bindkey '^[[F' end-of-line
#fi

# TEMPORARY
bindkey '^[[F' end-of-line
bindkey '^[[H' beginning-of-line

bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# Use "cbt" capability ("back_tab", as per `man terminfo`), if we have it:
if tput cbt &> /dev/null; then
  bindkey "$(tput cbt)" reverse-menu-complete # make Shift-tab go to previous completion
fi

# ctrl+<- | ctrl+->
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
# alt+<- | alt+->
bindkey "^[[1;3C" forward-word 
bindkey "^[[1;3D" backward-word
