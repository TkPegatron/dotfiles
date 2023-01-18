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
  if [[ "$REMOTE_CONTAINERS" ]]; then
    #? For VSCode Remote Containers
    # The extension copies the local .gitconfig during startup
    stow --dir="${DOTFILES}/" --target="${HOME}/" --restow --verbose --ignore=".gitconfig" home
    # The extension copies local gnupg resources into the container during startup,
    #   this is a *shim* to link them into the inner ${GNUPGHOME}
    stow --dir="${HOME}/.gnupg/" --target="${HOME}/.config/gnupg" --restow --verbose .
  else
    stow --dir="${DOTFILES}/" --target="${HOME}/" --restow --verbose home
  fi
else
  echo "GNU/Stow was not found in path or is otherwise not available"
  exit 1
fi
