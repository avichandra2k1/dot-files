local colors = require("colors_catpuccin")
local settings = require("settings")

-- Create event for aerospace workspace changes
sbar.add("event", "aerospace_workspace_changed")

local workspace = sbar.add("item", "aerospace_workspace", {
    position = "right",
    icon = { drawing = false },
    label = {
        string = "?",
        font = {
            style = settings.font.style_map["Bold"],
            size = 11.0,
        },
        color = colors.dirty_white,
        padding_left = 6,
        padding_right = 6,
    },
    background = {
        color = colors.bg2,
        corner_radius = 5,
        height = 20,
    },
    padding_left = 0,
    padding_right = 10,
})

-- Update function
local function update_workspace()
    sbar.exec("aerospace list-workspaces --focused", function(focused)
        workspace:set({ label = { string = focused:gsub("%s+", "") } })
    end)
end

-- Subscribe to aerospace event (triggered by aerospace.toml)
workspace:subscribe("aerospace_workspace_changed", update_workspace)

-- Initial update
update_workspace()
