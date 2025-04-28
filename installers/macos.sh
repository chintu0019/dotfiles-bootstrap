#!/usr/bin/env bash
set -e

# --------------------------------
# macOS installer for dotfiles-bootstrap
# --------------------------------

# 1. Install Homebrew if missing
type brew >/dev/null 2>&1 || \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install required packages
brew install fzf starship kitty gnu-stow hammerspoon

# 3. Initialize fzf
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish

# 4. Symlink dotfiles via stow
# Move into repo root (one level up from installers/)
cd "$(dirname "$0")/.."
stow -v --restow --target="$HOME" dotfiles

# 5. Setup Hammerspoon config and toggle script
# Ensure local bin exists
mkdir -p "$HOME/.local/bin"

# Stow toggle script into ~/.local/bin
stow --dir="./scripts" --target="$HOME/.local/bin" .

# Ensure ~/.hammerspoon exists and stow config
mkdir -p "$HOME/.hammerspoon"
stow --dir="./dotfiles/hammerspoon" --target="$HOME/.hammerspoon" .

# Reload Hammerspoon if running
if pgrep "Hammerspoon" >/dev/null; then
  osascript -e 'tell application "Hammerspoon" to reload' || true
fi

# 6. Set default shell to zsh
type zsh >/dev/null && chsh -s "$(which zsh)"