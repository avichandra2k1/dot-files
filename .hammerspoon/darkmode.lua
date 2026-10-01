-- ctrl+alt+0: toggle macOS appearance, swap the wallpaper, and reload sketchybar.
--
-- Wallpapers are applied by ~/.config/wallpaper/apply.sh, which swaps a saved
-- snapshot of macOS's wallpaper store. That indirection exists because the
-- light wallpaper is an aerial (live) one, and aerials can't be set through
-- NSWorkspace / hs.screen:desktopImageURL -- only static images can.
--
-- Gaps are no longer tied to appearance: ctrl-alt-g in
-- ~/.config/aerospace/aerospace.toml toggles them on/off independently via
-- ~/.config/aerospace/set-gaps.sh.

local WALLPAPER = os.getenv("HOME") .. "/.config/wallpaper/apply.sh"
local SKETCHYBAR = "/opt/homebrew/bin/sketchybar"

local function isDark()
    local out = hs.execute("defaults read -g AppleInterfaceStyle 2>/dev/null")
    return (out or ""):match("Dark") ~= nil
end

local function toggle()
    hs.osascript.applescript([[
        tell application "System Events"
            tell appearance preferences to set dark mode to not dark mode
        end tell
    ]])

    -- Give the appearance change a moment to land before anything reads it.
    hs.timer.doAfter(0.4, function()
        local dark = isDark()
        local mode = dark and " dark" or " light"
        hs.execute(WALLPAPER .. mode)
        hs.execute(SKETCHYBAR .. " --reload")
        hs.alert.show(dark and "Dark" or "Light", 0.5)
    end)
end

hs.hotkey.bind({"ctrl", "alt"}, "0", toggle)
