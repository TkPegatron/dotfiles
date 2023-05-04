#!/usr/bin/env bash
# Install favored shell utilities
if [[ $RHEL_DEPS == true ]]; then
  #? This hasn't been tested fully
  sudo dnf install epel-release
  sudo dnf copr enable atim/starship
  sudo dnf install -y \
      starship \
      fd-find \
      bat \
      exa
  wget https://github.com/lotabout/skim/releases/download/v0.9.4/skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz \
      -O /tmp/skim.tar.gz
  sudo tar -xf /tmp/skim.tar.gz -C /usr/bin/
fi
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


# Footed to commit permissions change
