#!/usr/bin/env bash
# Try to detect where the ditfiles have been cloned to
if [[ -d "${HOME}/.dotfiles" ]]; then
  DOTFILES="${HOME}/.dotfiles"
elif [[ -d "${HOME}/dotfiles" ]]; then
  DOTFILES="${HOME}/dotfiles"
else
  echo "Could not locate dotfile clone directory"
  exit 1
fi
# Stow dotfiles if stow is available
if which stow 2>/dev/null; then
  stow --dir="${DOTFILES}/" --target="${HOME}/" --restow --verbose --ignore=".gitconfig" home
else
  echo "GNU/Stow was not found in path or is otherwise not available"
  exit 1
fi
if [[ "${TERM_PROGRAM}" == 'vscode' ]] && [[ "$REMOTE_CONTAINERS" ]]; then
  echo "vscode detected, linking gpg"
  stow --dir="${HOME}/.gnupg/" --target="${HOME}/.config/gnupg" --restow --verbose .
fi
