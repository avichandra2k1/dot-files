local colors = require("colors")
local settings = require("settings")

-- Events driven from Hammerspoon (alt-t) via `sketchybar --trigger ...`
sbar.add("event", "timer_start")
sbar.add("event", "timer_pause")
sbar.add("event", "timer_play")
sbar.add("event", "timer_kill")

local BAR_WIDTH = 54

-- Added before the time item so it ends up to its right: "04:54 ▬▬▬▬".
-- A thin track that fills as the timer elapses, like timr's bar.
local bar = sbar.add("slider", "timer.bar", BAR_WIDTH, {
    position = "right",
    drawing = false,
    updates = true,
    y_offset = 1,
    padding_left = 2,
    padding_right = 10,
    label = { drawing = false },
    icon = { drawing = false },
    background = { drawing = false },
    slider = {
        highlight_color = colors.orange,
        background = {
            height = 3,
            corner_radius = 2,
            color = colors.with_alpha(colors.grey, 0.3),
            border_width = 0,
        },
        knob = { drawing = false },
    },
})

local timer = sbar.add("item", "timer.time", {
    position = "right",
    drawing = false,
    -- `updates = true` so events still reach the item while it is hidden;
    -- update_freq is toggled on only while a timer exists.
    updates = true,
    update_freq = 0,
    background = { drawing = false },
    icon = { drawing = false },
    label = {
        color = colors.orange,
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 12.0,
        },
        padding_left = 6,
        padding_right = 2,
    },
    y_offset = 1,
})

-- State: `ends_at` is authoritative while running (survives sleep), `remaining`
-- takes over while paused.
local state = {
    active = false,
    running = false,
    total = 0,
    remaining = 0,
    ends_at = 0,
    blink = false,
}

local function format(secs)
    if secs < 0 then secs = 0 end
    secs = math.floor(secs + 0.5)
    local h = math.floor(secs / 3600)
    local m = math.floor(secs / 60) % 60
    local s = secs % 60
    if h > 0 then
        return string.format("%d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

local function left()
    if state.running then
        return state.ends_at - os.time()
    end
    return state.remaining
end

local function render()
    if not state.active then
        timer:set({ drawing = false, update_freq = 0 })
        bar:set({ drawing = false })
        return
    end

    local secs = left()
    local color = colors.orange

    if secs <= 0 then
        -- Finished: blink so it's hard to miss until it's dismissed.
        color = state.blink and colors.pink or colors.grey
        secs = 0
    elseif not state.running then
        color = colors.grey
    end

    local elapsed = 100
    if state.total > 0 then
        elapsed = math.floor(((state.total - secs) / state.total) * 100 + 0.5)
        elapsed = math.max(0, math.min(100, elapsed))
    end

    timer:set({
        drawing = true,
        update_freq = 1,
        label = { string = format(secs), color = color },
    })
    bar:set({
        drawing = true,
        slider = { percentage = elapsed, highlight_color = color },
    })
end

local function finish()
    state.running = false
    state.remaining = 0
    sbar.exec("afplay /System/Library/Sounds/Glass.aiff")
    sbar.exec([[osascript -e 'display notification "Time is up" with title "Timer"']])
end

timer:subscribe("routine", function()
    if not state.active then return end
    if state.running and left() <= 0 then
        finish()
    end
    if not state.running and state.remaining <= 0 then
        state.blink = not state.blink
    end
    render()
end)

timer:subscribe("timer_start", function(env)
    local secs = tonumber(env.duration or "") or 0
    if secs <= 0 then return end
    state.active = true
    state.running = true
    state.total = secs
    state.remaining = secs
    state.ends_at = os.time() + secs
    render()
end)

timer:subscribe("timer_pause", function()
    if not state.active or not state.running then return end
    state.remaining = left()
    if state.remaining <= 0 then return end
    state.running = false
    render()
end)

timer:subscribe("timer_play", function()
    if not state.active or state.running or state.remaining <= 0 then return end
    state.running = true
    state.ends_at = os.time() + state.remaining
    render()
end)

timer:subscribe("timer_kill", function()
    state.active = false
    state.running = false
    state.remaining = 0
    render()
end)

-- Click toggles pause/play (or dismisses a finished timer); right-click kills.
local function on_click(env)
    if env.BUTTON == "right" or env.MODIFIER == "alt" then
        sbar.trigger("timer_kill")
    elseif state.remaining <= 0 and not state.running then
        sbar.trigger("timer_kill")
    elseif state.running then
        sbar.trigger("timer_pause")
    else
        sbar.trigger("timer_play")
    end
end

timer:subscribe("mouse.clicked", on_click)
bar:subscribe("mouse.clicked", on_click)
