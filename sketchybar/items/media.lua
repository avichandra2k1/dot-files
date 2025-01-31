local colors = require("colors")
local icons  = require("icons")

local media = sbar.add("item", "media.nowplaying", {
  position = "right",
  drawing = true,

  icon = {
    font = { size = 14 },
    padding_left = 6,
    padding_right = 6,
    color = colors.white,
  },

  label = {
    font = { size = 12 },
    padding_right = 20, -- move it near notch
    max_chars = 50,
    y_offset = -1,
  },
})

-- Update from stream
media:subscribe("media_stream_changed", function(env)
  local title   = env.title or ""
  local artist  = env.artist or ""
  local playing = env.playing == "true"

  if title == "" and artist == "" then
    media:set({ icon = { string = "" }, label = { string = "" } })
    return
  end

  local text = (artist ~= "") and (title .. " — " .. artist) or title
  --local icon = playing and "🎧" or "▶"
  local icon = playing and "" or "▶"

  media:set({
    icon  = { string = icon },
    label = { string = text },
  })
end)

-- Toggle play on click
media:subscribe("mouse.clicked", function()
  sbar.exec("media-control toggle-play-pause")
end)

