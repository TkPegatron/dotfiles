## Source aliases, scriptlets and configuration
for FN in $HOME/.config/shell.d/*.sh ; do
  source "$FN"
done
for FN in $HOME/.config/zshrc.d/*.sh ; do
  source "$FN"
done

autoload -U +X compinit && compinit

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
