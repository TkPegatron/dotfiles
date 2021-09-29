## Keybindings section
bindkey -e
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
else
  bindkey '^[[7~' beginning-of-line
  bindkey '^[[H' beginning-of-line
fi

if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line
else
  bindkey '^[[8~' end-of-line
  bindkey '^[[F' end-of-line
fi

bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word