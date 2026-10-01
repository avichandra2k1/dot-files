-- activityCounter.lua
local M = {}

-- Configuration
local config = {
    dataFile = os.getenv("HOME") .. "/.hammerspoon/activity_counters.json",
    dayStartHour = 8, -- 8 AM
    defaultActivities = {
        {
            name = "vape",
            hotkey = { mods = {"alt", "cmd"}, key = "1" },
            displayName = "Vape 🪫"
        },
        {
            name = "coffee",
            hotkey = { mods = {"alt", "cmd"}, key = "2" },
            displayName = "Coffee ☕"
        }
    }
}

-- State
local counters = {}

-- Helper functions
local function loadCounters()
    if hs.fs.attributes(config.dataFile) then
        local file = io.open(config.dataFile, "r")
        local content = file:read("*a")
        file:close()
        return hs.json.decode(content)
    else
        local initial = {}
        for _, activity in ipairs(config.defaultActivities) do
            initial[activity.name] = {
                entries = {},
                untimedEntries = {}
            }
        end
        return initial
    end
end

local function saveCounters()
    local file = io.open(config.dataFile, "w")
    file:write(hs.json.encode(counters))
    file:close()
end

local function getTodayStart()
    local now = os.date("*t")
    local today = os.time({
        year = now.year,
        month = now.month,
        day = now.day,
        hour = config.dayStartHour,
        min = 0,
        sec = 0
    })
    
    if now.hour < config.dayStartHour then
        today = today - 24 * 60 * 60
    end
    
    return today
end

local function getActivityStats(activityName)
    local activity = counters[activityName]
    if not activity then return 0, 0 end

    local currentTime = os.time()
    local oneHourAgo = currentTime - 3600
    local todayStart = getTodayStart()
    
    local todayCount = 0
    local hourCount = 0

    for _, timestamp in ipairs(activity.entries) do
        if timestamp >= todayStart then
            todayCount = todayCount + 1
        end
        
        if timestamp >= oneHourAgo then
            hourCount = hourCount + 1
        end
    end

    local todayDate = os.date("%Y-%m-%d")
    if activity.untimedEntries[todayDate] then
        todayCount = todayCount + activity.untimedEntries[todayDate]
    end

    return todayCount, hourCount
end

local function formatAlert(activityName)
    local today, lastHour = getActivityStats(activityName)
    local displayName = ""
    
    for _, activity in ipairs(config.defaultActivities) do
        if activity.name == activityName then
            displayName = activity.displayName
            break
        end
    end
    
    return displayName .. "\nToday: " .. today .. "\nLast hour: " .. lastHour
end

function M.addEntry(activityName, untimed)
    if not counters[activityName] then
        counters[activityName] = {
            entries = {},
            untimedEntries = {}
        }
    end

    if untimed then
        local todayDate = os.date("%Y-%m-%d")
        counters[activityName].untimedEntries[todayDate] = 
            (counters[activityName].untimedEntries[todayDate] or 0) + 1
    else
        table.insert(counters[activityName].entries, os.time())
    end
    
    saveCounters()
    hs.alert.show(formatAlert(activityName))
end

function M.undoLastEntry()
    local todayDate = os.date("%Y-%m-%d")
    local lastTimestamp = 0
    local lastActivity = nil
    local isUntimed = false
    
    for activityName, data in pairs(counters) do
        if #data.entries > 0 then
            local lastTime = data.entries[#data.entries]
            if lastTime > lastTimestamp then
                lastTimestamp = lastTime
                lastActivity = activityName
                isUntimed = false
            end
        end
        
        if data.untimedEntries[todayDate] and data.untimedEntries[todayDate] > 0 then
            local currentTime = os.time()
            if currentTime > lastTimestamp then
                lastTimestamp = currentTime
                lastActivity = activityName
                isUntimed = true
            end
        end
    end
    
    if lastActivity then
        if isUntimed then
            counters[lastActivity].untimedEntries[todayDate] = 
                counters[lastActivity].untimedEntries[todayDate] - 1
            hs.alert.show("Removed last untimed " .. lastActivity .. " entry")
        else
            table.remove(counters[lastActivity].entries)
            hs.alert.show("Removed last " .. lastActivity .. " entry")
        end
        saveCounters()
    else
        hs.alert.show("No entries to remove")
    end
end

function M.setup(customConfig)
    if customConfig then
        for k, v in pairs(customConfig) do
            config[k] = v
        end
    end

    counters = loadCounters()

    -- Function to list all activity counts
    local function showAllCounts()
        local stats = {}
        for _, activity in ipairs(config.defaultActivities) do
            local today, lastHour = getActivityStats(activity.name)
            local line = activity.displayName .. "\nToday: " .. today .. "\nLast hour: " .. lastHour
            table.insert(stats, line)
        end
        hs.alert.show(table.concat(stats, "\n\n"))
    end

    -- List all counts hotkey (Alt + Cmd + L)
    hs.hotkey.bind({"alt", "cmd"}, "l", showAllCounts)

    -- Set up hotkeys for each activity
    for _, activity in ipairs(config.defaultActivities) do
        hs.hotkey.bind(
            activity.hotkey.mods,
            activity.hotkey.key,
            function() M.addEntry(activity.name, false) end
        )
        
        local untimedMods = {}
        for _, mod in ipairs(activity.hotkey.mods) do
            table.insert(untimedMods, mod)
        end
        table.insert(untimedMods, "shift")
        
        hs.hotkey.bind(
            untimedMods,
            activity.hotkey.key,
            function() M.addEntry(activity.name, true) end
        )
    end

    -- Undo hotkey (Alt + Cmd + U)
    hs.hotkey.bind(
        {"alt", "cmd"},
        "u",
        M.undoLastEntry
    )

    hs.alert.show("Activity Counter Ready!")
end

return M
