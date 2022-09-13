FROM almalinux:latest

RUN dnf install -y epel-release

RUN dnf install -y \
  zsh git mtr \
  ranger neovim
