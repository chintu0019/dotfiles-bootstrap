local hotkey = require "hs.hotkey"
hs.hotkey.bind({"alt","cmd"}, "T", function()
  hs.execute("~/.local/bin/toggle_kitty.sh")
end)