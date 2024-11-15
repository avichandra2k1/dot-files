
local settings = require("settings")
local app_labels = {
    ["Google Chrome"] = "Chrome",
    ["Google Chorme"] = "Chrome",
    ["ChatGPT"] = "Codex",
}
-- Events registration
sbar.add("event", "front_app_switched")
sbar.add("event", "window_focus")
sbar.add("event", "title_change")
local front_app = sbar.add("item", "front_app", {
    position = "left",
    display = "active",
    padding_left = 0,
    icon = { drawing = false },
    label = {
        font = {
            style = settings.font.style_map["Regular"],
            size = 14.5,
        },
    },
    updates = true,
})
local app_name = ""

local function set_front_app_label()
    sbar.exec("aerospace list-workspaces --focused", function(workspace)
        workspace = workspace:gsub("%s+$", "")
        local label = app_labels[app_name] or app_name
        front_app:set({
            label = { string = workspace .. " " .. label }
        })
    end)
end

local function update_front_app(env)
    app_name = env.INFO or app_name
    set_front_app_label()
end

front_app:subscribe("front_app_switched", update_front_app)
front_app:subscribe("aerospace_workspace_change", set_front_app_label)
--front_app:subscribe("window_focus", update_front_app)
--front_app:subscribe("title_change", update_front_app)
-- Initial update
sbar.exec("sketchybar --query front_app.label", function(result)
    update_front_app({INFO = result})
end)
--print("front_app_no_logo.lua loaded and initialized")
