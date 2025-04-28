#!/usr/bin/env bash
set -e
# Install Homebrew if missing
type brew >/dev/null 2>&1 || \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew install fzf starship stow kitty

# Initialize fzf
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish

# Symlink dotfiles via stow
cd "$(dirname "$0")/.."
stow -v --restow --target="$HOME" dotfiles

# Set default shell to zsh
type zsh >/dev/null && chsh -s "$(which zsh)"