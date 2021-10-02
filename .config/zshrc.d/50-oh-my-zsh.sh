export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Install ohmyzsh if not present.
if [[ ! -f "$ZSH/oh-my-zsh.sh" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc --unattended"
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

#source $ZSH/oh-my-zsh.sh
