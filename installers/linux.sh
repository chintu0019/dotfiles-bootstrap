#!/usr/bin/env bash
set -e

# --------------------------------
# Linux installer for dotfiles-bootstrap
# --------------------------------

# 1. Update & install packages
if command -v apt-get &>/dev/null; then
  sudo apt-get update && sudo apt-get install -y fzf starship kitty gnu-stow xbindkeys wmctrl
elif command -v pacman &>/dev/null; then
  sudo pacman -Sy --noconfirm fzf starship kitty gnu-stow xbindkeys wmctrl
else
  echo "Unsupported package manager. Install fzf, starship, kitty, stow, xbindkeys, wmctrl manually."
  exit 1
fi

# 2. Initialize fzf
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
elif command -v fzf &>/dev/null && [ -f "$(fzf --version >/dev/null; echo $(dirname $(command -v fzf))/../share/fzf/key-bindings.bash)" ]; then
  source "$(dirname $(command -v fzf))/../share/fzf/key-bindings.bash"
fi

if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
  source /usr/share/doc/fzf/examples/completion.bash
elif command -v fzf &>/dev/null && [ -f "$(dirname $(command -v fzf))/../share/fzf/completion.bash" ]; then
  source "$(dirname $(command -v fzf))/../share/fzf/completion.bash"
fi

# 3. Symlink dotfiles via stow
cd "$(dirname "$0")/.."
stow -v --restow --target="$HOME" dotfiles

# 4. Deploy toggle script
# Ensure local bin exists
mkdir -p "$HOME/.local/bin"
# Stow scripts into ~/.local/bin
stow --dir="./scripts" --target="$HOME/.local/bin" .

# 5. Deploy xbindkeys config
# Stow xbindkeys config into home
stow --dir="./dotfiles/xbindkeys" --target="$HOME" .

# 6. Reload or start xbindkeys
test -z "$(pgrep xbindkeys)" || pkill xbindkeys
dbus-launch xbindkeys || xbindkeys

# 7. Set default shell to zsh
type zsh >/dev/null && chsh -s "$(which zsh)" "$USER"
