-- Port of tonsky's Alabaster (light) to a base46 theme.
-- Source palette lifted from https://github.com/dchinmay2/alabaster.nvim
--
-- Alabaster's whole point is minimal highlighting: it colors only strings,
-- constants, comments and definitions, and leaves keywords/types/variables at
-- the plain foreground. base46 has no notion of "leave it uncolored", so the
-- slots that would normally get a syntax color (base08/0A/0C/0E) are
-- deliberately set to the default fg. Don't "fix" them to real colors -- that
-- turns this back into an ordinary theme.

local M = {}

M.base_30 = {
  white = "#000000", -- main fg
  darker_black = "#f0f0f0",
  black = "#f7f7f7", --  nvim bg
  black2 = "#efefef",
  one_bg = "#e7e7e7", -- alabaster pmenu_bg
  one_bg2 = "#dedede",
  one_bg3 = "#d4d4d4",
  grey = "#c9c9c9",
  grey_fg = "#b0b0b0",
  grey_fg2 = "#a3a3a3",
  light_grey = "#969696", -- line numbers
  red = "#aa3731",
  baby_pink = "#c33c33",
  pink = "#f05050",
  line = "#dedede", -- for lines like vertsplit
  green = "#448c27",
  vibrant_green = "#60cb00",
  blue = "#325cc0",
  nord_blue = "#007acc",
  yellow = "#cb9000",
  sun = "#ffbc5d",
  purple = "#7a3e9d",
  dark_purple = "#63307e",
  teal = "#0083b2",
  orange = "#ec8013",
  cyan = "#00aacb",
  statusline_bg = "#efefef",
  lightbg = "#e7e7e7",
  pmenu_bg = "#007acc",
  folder_bg = "#325cc0",
}

M.base_16 = {
  base00 = "#f7f7f7", -- bg
  base01 = "#efefef",
  base02 = "#e2eeee", -- visual / cursorline
  base03 = "#777777", -- alabaster punct_fg, used for invisibles
  base04 = "#8c8c8c",
  base05 = "#000000", -- default fg
  base06 = "#0a0a0a",
  base07 = "#141414",
  base08 = "#000000", -- variables: intentionally uncolored
  base09 = "#7a3e9d", -- constants / numbers
  base0A = "#000000", -- types: intentionally uncolored
  base0B = "#448c27", -- strings
  base0C = "#000000", -- intentionally uncolored
  base0D = "#325cc0", -- functions / definitions
  base0E = "#000000", -- keywords: intentionally uncolored
  base0F = "#777777", -- punctuation
}

M.polish_hl = {
  -- base46 draws Comment from base_30.grey_fg, which is a real grey used
  -- elsewhere in the UI; alabaster wants comments red, so override just Comment.
  Comment = { fg = "#aa3731" },
  ["@comment"] = { fg = "#aa3731" },

  ["@punctuation.delimiter"] = { fg = M.base_16.base0F },
  ["@punctuation.bracket"] = { fg = M.base_16.base0F },
  ["@operator"] = { fg = M.base_16.base05 },

  ["@constant"] = { fg = M.base_16.base09 },
  ["@constant.builtin"] = { fg = M.base_16.base09 },
  ["@number"] = { fg = M.base_16.base09 },
  ["@boolean"] = { fg = M.base_16.base09 },

  PmenuSel = { fg = M.base_30.black, bg = M.base_30.pmenu_bg },
}

M = require("base46").override_theme(M, "alabaster_light")

M.type = "light"

return M
