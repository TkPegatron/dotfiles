
mkdir -pv /tmp/static_home_test

podman run --userns=keep-id -it \
  -v /tmp/static_home_test:/home/elliana \
  -v ~/.ssh/id_ed25519:/home/elliana/.ssh/id_ed25519 \
  -v ~/.ssh/known_hosts:/home/elliana/.ssh/known_hosts \
  -v ~/elliana-pgp-keys.asc:/home/elliana/elliana-pgp-keys.asc \
  -v /tmp/gnupghome/:/home/elliana/output \
  -e DOTFILES_BRANCH="${1:-devel}" \
localhost/aplhome:latest

rm -rf /tmp/static_home_test
