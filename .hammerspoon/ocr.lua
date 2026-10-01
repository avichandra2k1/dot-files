local hud = require("hud")

local ICON_COPIED = utf8.char(0x100062) -- SF Symbols checkmark.circle

-- Cmd+Shift+2: screenshot OCR to clipboard
hs.hotkey.bind({ "cmd", "shift" }, "2", nil, function()
  -- Wait for the shortcut keys to be released, otherwise the selection
  -- crosshair ignores the first drag while Cmd and Shift are still held.
  hs.timer.doAfter(0.1, function()
    local out = hs.execute("/opt/homebrew/bin/socr -x -c -l en-US")
    -- socr prints the recognised text; nothing means cancelled or no text.
    if (out or ""):match("%S") then
      hud.show("Copied Text", ICON_COPIED, { iconColor = hud.GREEN })
    end
  end)
end)
