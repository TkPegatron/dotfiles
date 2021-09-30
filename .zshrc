## Source aliases, scriptlets and configuration
for FN in $HOME/.config/shell.d/*.sh ; do
  source "$FN"
done
for FN in $HOME/.config/zshrc.d/*.sh ; do
  source "$FN"
done


autoload -U compinit && compinit -u

HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=1000
WORDCHARS=${WORDCHARS//\/[&.;]}

zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

typeset -A __WINCENT

__WINCENT[ITALIC_ON]=$'\e[3m'
__WINCENT[ITALIC_OFF]=$'\e[23m'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__WINCENT[ITALIC_ON]%}--- %d ---%{$__WINCENT[ITALIC_OFF]%}%b%f

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'