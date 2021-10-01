if [[ ! -f /usr/local/bin/antibody ]] || [[ ! -f "$HOME/.local/bin/antibody" ]]; then
    curl -sfL git.io/antibody | sh -s - -b "$HOME/.local/bin/"
fi

antibody bundle << PLUGINEOF > ~/.zsh_plugins.sh
zsh-users/zsh-history-substring-search
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-autosuggestions 
zsh-users/zsh-completions
greymd/docker-zsh-completion
jeanpantoja/dotpyvenv
ohmyzsh/ohmyzsh path:plugins/colorize
ohmyzsh/ohmyzsh path:plugins/sudo
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/fzf
ohmyzsh/ohmyzsh path:plugins/dirhistory
ohmyzsh/ohmyzsh path:plugins/zsh_reload
PLUGINEOF


ZSH_COLORIZE_STYLE="colorful"

source ~/.zsh_plugins.sh