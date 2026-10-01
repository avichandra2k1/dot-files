-- Use right Command as Return; holding Shift produces Shift+Return.
local event = hs.eventtap.event
local types = event.types
local masks = event.rawFlagMasks
local rightCommandKeyCode = 54
local returnIsDown = false

local function withoutRightCommand(rawFlags)
    rawFlags = rawFlags & ~masks.deviceRightCommand
    if (rawFlags & masks.deviceLeftCommand) == 0 then
        rawFlags = rawFlags & ~masks.command
    end
    return rawFlags
end

-- Keep a reference to the tap so Lua's garbage collector cannot stop it.
local rsi = {}
rsi.tap = hs.eventtap.new({types.flagsChanged, types.keyDown, types.keyUp}, function(e)
    local rawFlags = e:rawFlags()
    local rightCommandIsDown = (rawFlags & masks.deviceRightCommand) ~= 0

    if e:getType() == types.flagsChanged and e:getKeyCode() == rightCommandKeyCode then
        if rightCommandIsDown == returnIsDown then
            return true
        end

        returnIsDown = rightCommandIsDown
        local returnEvent = event.newKeyEvent({}, "return", returnIsDown)
        returnEvent:rawFlags(withoutRightCommand(rawFlags))
        return true, {returnEvent}
    end

    -- macOS still includes the physical Command flag on other key events.
    -- Remove it while the remapped key is held, preserving left Command.
    if rightCommandIsDown then
        e:rawFlags(withoutRightCommand(rawFlags))
    end
    return false
end)

rsi.tap:start()

-- Alternative Return shortcuts, including key repeat when held.
local function pressReturn()
    hs.eventtap.keyStroke({}, "return", 0)
end

local function pressShiftReturn()
    hs.eventtap.keyStroke({"shift"}, "return", 0)
end

rsi.ctrlM = hs.hotkey.bind({"ctrl"}, "m", pressReturn, nil, pressReturn)
rsi.ctrlShiftM = hs.hotkey.bind({"ctrl", "shift"}, "m", pressShiftReturn, nil, pressShiftReturn)

return rsi
