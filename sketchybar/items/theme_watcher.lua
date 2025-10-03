-- Invisible item that watches the macOS appearance and reloads the config when
-- it flips, so theme.lua re-resolves its light/dark colors.
local colors = require("theme")

local watcher = sbar.add("item", "theme_watcher", {
    drawing = false,
    updates = true,       -- keep ticking even though nothing is drawn
    update_freq = 5,
})

watcher:subscribe({ "routine", "forced", "system_woke" }, function(env)
    sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null", function(result)
        local dark = (result or ""):match("Dark") ~= nil
        if dark ~= colors.is_dark then
            sbar.exec("sketchybar --reload")
        end
    end)
end)
