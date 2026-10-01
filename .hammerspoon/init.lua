-- Helper function for key strokes
local function keyStroke(modifiers, key)
    hs.eventtap.keyStroke(modifiers, key, 0)
end

-- Map Ctrl+HJKL to arrow keys
local arrowMap = {
    h = 'left',
    j = 'down',
    k = 'up',
    l = 'right'
}

for key, arrow in pairs(arrowMap) do
    -- Ctrl+HJKL to arrow keys
    hs.hotkey.bind({'ctrl'}, key, function()
        keyStroke({}, arrow)
    end, nil, function()
        keyStroke({}, arrow)
    end)
end



hs.hotkey.bind({}, ';', function()
    hs.eventtap.keyStrokes(':')
end)

hs.hotkey.bind({"cmd", "shift"}, ';', function()
    hs.eventtap.keyStrokes(';')
end)



-- Open WezTerm
-- hs.hotkey.bind({"alt", "shift"}, "return", function()
--     local wezterm = hs.application.get("Wezterm")
--     if wezterm then
--         wezterm:selectMenuItem({"Shell", "New Window"})
--     else
--         hs.application.launchOrFocus("Wezterm")
--     end
-- end)



-- Open Ghostty
hs.hotkey.bind({"alt"}, "return", function()
    local ghostty = hs.application.get("Ghostty")

    if ghostty then
        -- IMPORTANT: Do NOT activate Ghostty (this causes Space jumping)
        -- Directly click the menu item on the existing process
        ghostty:selectMenuItem({"File", "New Window"})
        return
    end

    -- If not running: launch, then click New Window after menus load
    hs.application.launchOrFocus("Ghostty")
    hs.timer.doAfter(0.30, function()
        local g = hs.application.get("Ghostty")
        if g then
            g:selectMenuItem({"File", "New Window"})
        end
    end)
end)

--Open Helium
--hs.hotkey.bind({"alt", "shift"}, "return", function()
--    hs.application.launchOrFocus("Helium")
--end)


-- Open Warp
--hs.hotkey.bind({"alt", "shift"}, "return", function()
--    local warp = hs.application.get("Warp")
--
--    if warp then
--        -- IMPORTANT: Do NOT activate Warp (this causes Space jumping)
--        -- Directly click the menu item on the existing process
--        warp:selectMenuItem({"File", "New Window"})
--        return
--    end
--
--    -- If not running: launch, then click New Window after menus load
--    hs.application.launchOrFocus("Warp")
--    hs.timer.doAfter(0.30, function()
--        local w = hs.application.get("Warp")
--        if w then
--            w:selectMenuItem({"File", "New Window"})
--        end
--    end)
--end)


-- Set a hotkey to launch Finder with ctrl + f
hs.hotkey.bind({"ctrl"}, "F", function()
    hs.application.launchOrFocus("Finder")
end)





-- Sketchybar timer input (alt-t)
--require("timer")

-- Dark mode toggle (alt-0)
require("darkmode")

-- Right Command as Return (Shift + right Command as Shift+Return)
require("rsi")

-- Keyboard backlight toggle, off <-> 13% (ctrl-0)
require("kbdlight")

-- Screenshot OCR to clipboard (cmd-shift-2)
require("ocr")


-- Open Eloquent JavaScript with ctrl + shift + b
hs.hotkey.bind({"ctrl", "shift"}, "B", function()
    hs.execute('open "$HOME/Code/books/Eloquent Javascript A Modern Introduction to Programming 2.pdf"')
end)


-- Toggle sketchybar service with ctrl + alt + s
hs.hotkey.bind({"ctrl", "alt"}, "S", function()
    local brew = "/opt/homebrew/bin/brew"
    local out = hs.execute(brew .. " services info sketchybar --json 2>/dev/null")
    local running = (out or ""):match('"running"%s*:%s*true') ~= nil
    local action = running and "stop" or "start"
    hs.execute(brew .. " services " .. action .. " sketchybar")
    hs.alert.show("sketchybar " .. (running and "stopped" or "started"))
end)
