-- Raycast-style HUD: a small dark pill at the bottom-centre of the active
-- screen that fades in, lingers briefly, then fades out.
--
-- Usage: require("hud").show("Copied Text", "✓")
--        require("hud").show("Copied Text", "✓", { iconColor = hud.GREEN, duration = 2 })

local hud = {}

local FONT = ".AppleSystemUIFont"
-- SF Pro carries the SF Symbols glyphs; other icons fall back automatically.
local ICON_FONT = "SF Pro"
local FONT_SIZE = 14
local ICON_SIZE = 15
local HEIGHT = 40
local PAD_X = 18
local GAP = 8
local BOTTOM_OFFSET = 140
local DURATION = 1.2
local FADE = 0.15

-- macOS systemGreen (dark appearance), readable on the dark pill.
hud.GREEN = { red = 0.19, green = 0.82, blue = 0.35, alpha = 1 }

local current, hideTimer, deleteTimer

local function clear()
    if hideTimer then hideTimer:stop(); hideTimer = nil end
    if deleteTimer then deleteTimer:stop(); deleteTimer = nil end
    if current then current:delete(); current = nil end
end

function hud.show(text, icon, opts)
    opts = opts or {}
    clear()

    local textStyle = {
        font = { name = FONT, size = FONT_SIZE },
        color = { white = 1, alpha = 0.95 },
        paragraphStyle = { alignment = "left" },
    }
    local iconStyle = {
        font = { name = ICON_FONT, size = ICON_SIZE },
        color = opts.iconColor or { white = 1, alpha = 0.95 },
        paragraphStyle = { alignment = "center" },
    }

    local textSize = hs.drawing.getTextDrawingSize(hs.styledtext.new(text, textStyle))
    local iconSize = icon and hs.drawing.getTextDrawingSize(hs.styledtext.new(icon, iconStyle))
        or { w = 0, h = 0 }
    local iconW = icon and math.ceil(iconSize.w) or 0
    local textW = math.ceil(textSize.w) + 2

    local width = PAD_X * 2 + textW + (icon and (iconW + GAP) or 0)
    local frame = hs.screen.mainScreen():frame()
    local x = frame.x + (frame.w - width) / 2
    local y = frame.y + frame.h - BOTTOM_OFFSET - HEIGHT

    local c = hs.canvas.new({ x = x, y = y, w = width, h = HEIGHT })
    c:level(hs.canvas.windowLevels.overlay)
    c:behavior({ "canJoinAllSpaces", "stationary", "ignoresCycle" })
    c:clickActivating(false)

    c:appendElements({
        type = "rectangle",
        action = "fill",
        roundedRectRadii = { xRadius = HEIGHT / 2, yRadius = HEIGHT / 2 },
        fillColor = { red = 0.11, green = 0.11, blue = 0.12, alpha = 0.92 },
        withShadow = true,
        shadow = { blurRadius = 12, color = { alpha = 0.35 }, offset = { h = -2, w = 0 } },
    }, {
        type = "rectangle",
        action = "stroke",
        roundedRectRadii = { xRadius = HEIGHT / 2, yRadius = HEIGHT / 2 },
        strokeColor = { white = 1, alpha = 0.08 },
        strokeWidth = 1,
    })

    local cursor = PAD_X
    if icon then
        c:appendElements({
            type = "text",
            text = hs.styledtext.new(icon, iconStyle),
            frame = { x = cursor, y = (HEIGHT - iconSize.h) / 2, w = iconW, h = iconSize.h },
        })
        cursor = cursor + iconW + GAP
    end
    c:appendElements({
        type = "text",
        text = hs.styledtext.new(text, textStyle),
        frame = { x = cursor, y = (HEIGHT - textSize.h) / 2, w = textW, h = textSize.h },
    })

    current = c
    c:show(FADE)

    hideTimer = hs.timer.doAfter(opts.duration or DURATION, function()
        hideTimer = nil
        if current ~= c then return end
        c:hide(FADE)
        deleteTimer = hs.timer.doAfter(FADE + 0.05, function()
            deleteTimer = nil
            if current == c then clear() end
        end)
    end)
end

return hud
