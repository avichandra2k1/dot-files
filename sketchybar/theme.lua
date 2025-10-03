-- Semantic color layer.
-- Item files should require this, not the raw palettes, so a color only ever
-- changes in one place. Each entry is { light = ..., dark = ... } and is
-- resolved once at load time based on the current macOS appearance.

local palette = require("colors_catpuccin")

-- macOS sets AppleInterfaceStyle=Dark only in dark mode; unset means light.
local function is_dark()
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if not handle then return true end
    local out = handle:read("*a") or ""
    handle:close()
    return out:match("Dark") ~= nil
end

local dark = is_dark()

local function pick(v)
    if type(v) == "table" and (v.light ~= nil or v.dark ~= nil) then
        return dark and v.dark or v.light
    end
    return v
end

-- Semantic definitions: left = light mode, right = dark mode.
local semantic = {
    label       = { light = palette.white,       dark = palette.dirty_white },
    label_dim   = { light = palette.grey,        dark = palette.grey },
    icon        = { light = palette.white,       dark = palette.dirty_white },
    icon_dim    = { light = palette.dirty_white, dark = palette.grey },
    accent      = { light = palette.blue,        dark = palette.blue },
}

local theme = { is_dark = dark, palette = palette }
for k, v in pairs(semantic) do theme[k] = pick(v) end

-- Fall through to the raw palette for anything not given a semantic name yet
-- (colors.white, colors.bar.bg, colors.with_alpha, ...).
setmetatable(theme, { __index = palette })

return theme
