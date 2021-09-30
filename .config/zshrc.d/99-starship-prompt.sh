if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- \
      --bin-dir "$HOME/.local/bin" \
      --yes \
    && eval "$(starship init zsh)"
fi