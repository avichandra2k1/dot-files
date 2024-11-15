local colors = require("theme")
local settings = require("settings")

-- Create event for aerospace workspace changes
sbar.add("event", "aerospace_workspace_changed")

local workspace = sbar.add("item", "aerospace_workspace", {
    position = "right",
    icon = { drawing = false },
    label = {
        string = "?",
        font = {
            style = settings.font.style_map["Regular"],
            size = 13.5,
        },
        color = colors.label,
    },
    padding_left = 0,
    padding_right = 10,
})

-- Update function
local function update_workspace()
    sbar.exec("aerospace list-workspaces --focused", function(focused)
        local num = focused:gsub("%s+", "")
        --workspace:set({ label = { string = "| " .. num .. " |" } })
        --workspace:set({ label = { string = "" .. num .. "  | " } })
        workspace:set({ label = { string = " [ " .. num .. " ]] " } })
        --workspace:set({ label = { string = "" .. num .. "" } })
    end)
end

-- Subscribe to aerospace event (triggered by aerospace.toml)
workspace:subscribe("aerospace_workspace_changed", update_workspace)

-- Initial update
update_workspace()
