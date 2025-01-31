local colors = require("colors")

--print("Calendar script started")

-- Left side of notch (hours)
local hours_display = sbar.add("item", {
    position = "center",
    width = 50,
    label = {
        string = "00",
        color = colors.dirty_white,
        font = {
            size = 14.5,
        },
    },
})

local space_display = sbar.add("item", {
    position = "center",
    width = 155,
    label = {
        string = "",
        color = "regular",
        font = {
            size = 15.0,
        },
    },
})

-- Right side of notch (minutes)
local minutes_display = sbar.add("item", {
    position = "center",
    width = 85,
    label = {
        string = "00",
        color = colors.dirty_white,
        font = {
            size = 15.0,
        },
    },
})

-- Set x_offset to position items on either side of the notch
hours_display:set({ x_offset = -150 })   -- 150/2 = 75 to the left
minutes_display:set({ x_offset = 150 })  -- 150/2 = 75 to the right

--print("Time display items created")

local function updateTime()
    local hours = os.date("%H")
    local minutes = os.date("%M")
    hours_display:set({ label = { string = hours } })
    minutes_display:set({ label = { string = minutes } })
end

-- Create a timer to update every minute
local timer = sbar.add("item", {
    position = "left",
    width = 0,
    update_freq = 30,
})

-- Subscribe to events
timer:subscribe({ "routine", "forced", "system_woke" }, updateTime)
hours_display:subscribe("mouse.clicked", updateTime)
minutes_display:subscribe("mouse.clicked", updateTime)

-- Initial update
updateTime()

print("Calendar script finished loading")
