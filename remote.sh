#!/usr/bin/env bash
set -e
# Remote ephemeral bootstrap
BASE_DIR="/tmp/dotfiles-$$"
mkdir -p "$BASE_DIR"
# Untar piped content into base dir
cat - | tar xz -C "$BASE_DIR"

# Prepare cleanup on exit
cleanup() {
  stow --delete --dir="$BASE_DIR" --target="$HOME" dotfiles
  rm -rf "$BASE_DIR"
}
trap cleanup EXIT

# Symlink for session
dotfiles_dir="$BASE_DIR/dotfiles"
stow --dir="$BASE_DIR" --target="$HOME" dotfiles

# Launch a login shell
exec zsh -l || exec bash --login