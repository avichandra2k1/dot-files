
local colors = require("theme")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
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
    padding_left = 10,
    icon = {
        font = {
            family = "sketchybar-app-font",
            style = "Regular",
            size = 16.0
        },
        padding_right = 8,
        color = colors.icon,
    },
    label = {
        font = {
            style = settings.font.style_map["Regular"],
            size = 14.5,
        },
    },
    updates = true,
})
local function update_front_app(env)
    local app_name = env.INFO
    local icon = app_icons[app_name] or app_icons["default"] or ""
    local label = app_labels[app_name] or app_name

    print("Updating front app - Name: " .. app_name .. ", Icon: " .. icon)
    front_app:set({
        icon = { string = icon },
        label = { string = label }
    })
end
front_app:subscribe("front_app_switched", update_front_app)
--front_app:subscribe("window_focus", update_front_app)
--front_app:subscribe("title_change", update_front_app)
-- Initial update
sbar.exec("sketchybar --query front_app.label", function(result)
    update_front_app({INFO = result})
end)
--print("front_app.lua loaded and initialized")
