FROM almalinux:latest

RUN dnf install -y epel-release

RUN dnf install -y \
  zsh git sudo mtr \
  ranger neovim

RUN useradd --create-home -s /bin/zsh elliana \
  --comment "Elliana Perry" --home-dir /home/elliana \
  && echo "elliana ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/elliana

WORKDIR /home/elliana
USER elliana
