source $ZDOTDIR/options
source $ZDOTDIR/keybinds
#source $HOME/.profile
source $HOME/.config/shellrc

HISTFILE="$ZDOTDIR/history"
HISTSIZE=1000
SAVEHIST=1000
WORDCHARS=${WORDCHARS//\/[&.;]}

#       SHELL HOOKS
#=====================================

autoload -U add-zsh-hook

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    command -v exa > /dev/null && exa --icons --group-directories-first || ls
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd

#       SETUP COMPLETION
#=====================================

autoload -U compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

typeset -A __STYLE

__STYLE[ITALIC_ON]=$'\e[3m'
__STYLE[ITALIC_OFF]=$'\e[23m'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__STYLE[ITALIC_ON]%}--- %d ---%{$__STYLE[ITALIC_OFF]%}%b%f

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#       PLUGIN INIT
#=====================================

export ZSH="$ZDOTDIR/omz"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyzsh"
export ZSH_CUSTOM="$ZSH/custom"

# Install ohmyzsh if not present.
if [[ ! -f "$ZSH/oh-my-zsh.sh" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]]; then
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

ZSH_THEME="gentoo"
ZSH_COLORIZE_STYLE="colorful"


# Define Plugins
plugins=(
  zsh-completions
  zsh-syntax-highlighting
  history-substring-search
  command-not-found
  colored-man-pages
  colorize
  systemd
  sudo
  git
)

if command -v rsync >/dev/null; then plugins+=(cp); fi
if command -v fzf >/dev/null; then plugins+=(fzf); fi
if command -v tmux >/dev/null; then plugins+=(tmux); fi
if command -v docker >/dev/null; then plugins+=(docker); fi
if command -v mosh >/dev/null; then plugins+=(mosh); fi
if command -v kubectl >/dev/null; then plugins+=(kubectl); fi
if command -v helm >/dev/null; then plugins+=(helm); fi
if command -v namap >/dev/null; then plugins+=(nmap); fi

source $ZSH/oh-my-zsh.sh

#       STARSHIP PROMPT
#=====================================

if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- \
      --bin-dir "$HOME/.local/bin" \
      --yes \
    && eval "$(starship init zsh)"
fi
