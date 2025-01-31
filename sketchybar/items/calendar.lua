local settings = require("settings")
local colors = require("theme")
-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })
local cal = sbar.add("item", {
    icon = {
        color = colors.icon,
        padding_left = 0,
        font = {
            style = settings.font.style_map["Bold"],
            size = 15.0,
        },
        padding_right = 15,
    },
    label = {
        color = colors.label,
        padding_left = 8,
        padding_right = 10,
        width = 70,
        align = "right",
        font = {
           style = settings.font.style_map["Regular"],
            --size = 15.5,
            size = 14.5,
        },
    },
    position = "right",
    update_freq = 30,
    padding_left = 0,
    padding_right = 0,
    y_offset = 1,
})
-- german Date
cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
    local weekdayNames = {
        "Sun ", "Mon ", "Tue ", "Wed ", "Thu ", "Fri ", "Sat "
    }
    local monthNames = {
        "Jan ", "Feb ", "Mar ", "Apr ", "May ", "Jun ", "Jul ", "Aug ", "Sep ", "Okt ", "Nov ", "Dec "
    }
    cal:set({
        --icon = weekdayNames[tonumber(os.date("%w")) + 1] ..
        --    os.date("%d") .. " " .. monthNames[tonumber(os.date("%m"))] .. "｜",
        label = os.date("%H:%M")
    })
end)
cal:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Clock.app'")
end)
-- english date
-- cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
--   cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
-- end)
