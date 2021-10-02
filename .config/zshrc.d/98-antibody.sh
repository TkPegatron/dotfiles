if [[ ! -f "$HOME/.local/bin/antibody" ]]; then
    curl -sfL git.io/antibody | sh -s - -b "$HOME/.local/bin"
fi

antibody bundle << PLUGINEOF > ~/.config/zsh_plugins.sh
ohmyzsh/ohmyzsh path:plugins/colorize
ohmyzsh/ohmyzsh path:plugins/sudo
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/fzf
ohmyzsh/ohmyzsh path:plugins/dirhistory
ohmyzsh/ohmyzsh path:plugins/zsh_reload
zsh-users/zsh-completions
zsh-users/zsh-history-substring-search
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-autosuggestions 
greymd/docker-zsh-completion
jeanpantoja/dotpyvenv
PLUGINEOF


ZSH_COLORIZE_STYLE="colorful"

#source ~/.config/zsh_plugins.sh