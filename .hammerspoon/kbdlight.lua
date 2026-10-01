-- ctrl+0: toggle the keyboard backlight between off and 13%.
-- Any non-zero level counts as "on" and gets switched off.

local hud = require("hud")

local BRIGHTNESSCTL = "/opt/homebrew/bin/mac-brightnessctl"
local ON_LEVEL = 0.13

-- SF Symbols glyphs (rendered with the SF Pro font in hud.lua).
local ICON_OFF = utf8.char(0x1001ED) -- light.min
local ICON_ON = utf8.char(0x1001EE)  -- light.max

local function currentLevel()
    -- Output looks like: "Current brightness: 0.12"
    local out = hs.execute(BRIGHTNESSCTL)
    return tonumber((out or ""):match("([%d%.]+)")) or 0
end

local function toggle()
    if currentLevel() > 0 then
        hs.execute(BRIGHTNESSCTL .. " 0")
        hud.show("Keyboard Backlight Off", ICON_OFF)
    else
        hs.execute(BRIGHTNESSCTL .. " " .. ON_LEVEL)
        hud.show(string.format("Keyboard Backlight On · %d%%", math.floor(ON_LEVEL * 100 + 0.5)), ICON_ON)
    end
end

hs.hotkey.bind({"ctrl"}, "0", toggle)
