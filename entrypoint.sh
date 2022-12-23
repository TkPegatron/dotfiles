#!/usr/bin/env zsh

export HOME="/home/$(whoami)"
export GNUPGHOME="$HOME/.config/gnupg"

_exists() { (( $+commands[$1] )) }

echo "#---{ Ensuring that the needed directories are present }---#"
mkdir --parents ${HOME}/.local/{bin,share/zsh}
mkdir --parents ${HOME}/{Documents,Downloads}
mkdir --parents ${GNUPGHOME} && chmod 700 ${GNUPGHOME} # Ensure correct permissions

if ! _exists starship; then
  echo "#----{ Install Starship.rs }----#"
  wget https://github.com/starship/starship/releases/download/v1.11.0/starship-x86_64-unknown-linux-musl.tar.gz
  tar -xvf starship-x86_64-unknown-linux-musl.tar.gz --directory .local/bin/
  rm starship-x86_64-unknown-linux-musl.tar.gz
fi

if ! _exists exa; then
  echo "#----{ Install exa }----#"
  wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-musl-v0.10.1.zip
  unzip exa-linux-x86_64-musl-v0.10.1.zip -d exa-linux-x86_64-musl-v0.10.1
  mv exa-linux-x86_64-musl-v0.10.1/bin/exa .local/bin/
  rm -rf exa-linux-x86_64-musl-v0.10.1  exa-linux-x86_64-musl-v0.10.1.zip
fi

if ! _exists sk; then
  echo "#----{ Install Skim }----#"
  wget https://github.com/lotabout/skim/releases/download/v0.9.4/skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz
  tar -xvf skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz --directory .local/bin/
  rm skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz
fi

if ! _exists bat; then
  echo "#----{ Install bat }----#"
  wget https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-x86_64-unknown-linux-musl.tar.gz
  tar -xvf bat-v0.22.1-x86_64-unknown-linux-musl.tar.gz
  mv bat-v0.22.1-x86_64-unknown-linux-musl/bat .local/bin/
  rm -rf bat-v0.22.1-x86_64-unknown-linux-musl bat-v0.22.1-x86_64-unknown-linux-musl.tar.gz
fi

echo "#----{ Cloning and Stowing Dotfiles}----#"
git clone \
  git@github.com:TkPegatron/dotfiles.git \
  --depth=1 --branch ${DOTFILES_BRANCH:=main} ${HOME}/.dotfiles
stow --verbose --restow \
  --target ${HOME} \
  --dir ${HOME}/.dotfiles \
  home

echo "#----{ Creating user gpg trustdb and keyring  }----#"
gpg-agent --daemon \
  --pinentry-program /usr/bin/pinentry \
  --disable-scdaemon
gpg --list-keys

exec zsh
