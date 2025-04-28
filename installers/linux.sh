#!/usr/bin/env bash
set -e
# Update & install packages
if command -v apt-get &>/dev/null; then
  sudo apt-get update && sudo apt-get install -y fzf starship stow kitty
elif command -v pacman &>/dev/null; then
  sudo pacman -Sy --noconfirm fzf starship stow kitty
else
  echo "Unsupported package manager. Install fzf, starship, stow and kitty manually."
  exit 1
fi

# Initialize fzf
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi
if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
  source /usr/share/doc/fzf/examples/completion.bash
fi

# Symlink dotfiles
cd "$(dirname "$0")/.."
stow -v --restow --target="$HOME" dotfiles

# Set default shell to zsh
type zsh >/dev/null && sudo chsh -s "$(which zsh)" "$USER"