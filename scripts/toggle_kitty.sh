#!/usr/bin/env bash

OS="$(uname)"
SOCKET="/tmp/kitty.sock"

# Ensure the socket exists
if [ ! -S "$SOCKET" ]; then
  # Launch a new floating kitty if no instance/sock yet
  kitty --single-instance &
  sleep 0.2
fi

case "$OS" in
  Darwin)
    # On macOS: use AppleScript to hide/show the kitty.app
    STATE=$(osascript -e 'tell application "Kitty" to return visible of front window')
    if [ "$STATE" = "true" ]; then
      osascript -e 'tell application "Kitty" to hide'
    else
      osascript -e 'tell application "Kitty" to activate'
    fi
    ;;
  Linux)
    # On Linux: toggle float via Kitty remote kitten
    # (relies on default WM floating support)
    kitty @ --to=$SOCKET kitten float
    ;;
esac
