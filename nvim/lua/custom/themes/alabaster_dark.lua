-- Port of tonsky's Alabaster (dark) to a base46 theme.
-- Source palette lifted from https://github.com/dchinmay2/alabaster.nvim
--
-- See the note in alabaster_light.lua: the uncolored base_16 slots are deliberate.
-- Alabaster colors only strings, constants, comments and definitions; keywords,
-- types and variables stay at the plain foreground.

local M = {}

M.base_30 = {
  white = "#cecece", -- main fg
  darker_black = "#0a0f10",
  black = "#0e1415", --  nvim bg
  black2 = "#141b1c",
  one_bg = "#182325", -- alabaster pmenu_bg
  one_bg2 = "#212f31",
  one_bg3 = "#293334",
  grey = "#354c50",
  grey_fg = "#47666b",
  grey_fg2 = "#5c5c5c",
  light_grey = "#708b8d", -- alabaster punct_fg, line numbers
  red = "#c33c33",
  baby_pink = "#d2322d",
  pink = "#e07b76",
  line = "#2b3d40", -- for lines like vertsplit
  green = "#95cb82",
  vibrant_green = "#6abf40",
  blue = "#71aed7",
  nord_blue = "#217ebc",
  yellow = "#cd974b",
  sun = "#dfdf8e",
  purple = "#cc8bc9",
  dark_purple = "#9b3596",
  teal = "#178f79",
  orange = "#ec8013",
  cyan = "#47bea9",
  statusline_bg = "#162022",
  lightbg = "#182325",
  pmenu_bg = "#71aed7",
  folder_bg = "#71aed7",
}

M.base_16 = {
  base00 = "#0e1415", -- bg
  base01 = "#182325",
  base02 = "#293334", -- visual / cursorline
  base03 = "#708b8d", -- alabaster punct_fg, used for invisibles
  base04 = "#8fa4a6",
  base05 = "#cecece", -- default fg
  base06 = "#dedede",
  base07 = "#eeeeee",
  base08 = "#cecece", -- variables: intentionally uncolored
  base09 = "#cc8bc9", -- constants / numbers
  base0A = "#cecece", -- types: intentionally uncolored
  base0B = "#95cb82", -- strings
  base0C = "#cecece", -- intentionally uncolored
  base0D = "#71ade7", -- functions / definitions
  base0E = "#cecece", -- keywords: intentionally uncolored
  base0F = "#708b8d", -- punctuation
}

M.polish_hl = {
  -- base46 draws Comment from base_30.grey_fg, which is a real grey used
  -- elsewhere in the UI; alabaster wants comments yellow, so override Comment.
  Comment = { fg = "#dfdf8e" },
  ["@comment"] = { fg = "#dfdf8e" },

  ["@punctuation.delimiter"] = { fg = M.base_16.base0F },
  ["@punctuation.bracket"] = { fg = M.base_16.base0F },
  ["@operator"] = { fg = M.base_16.base05 },

  ["@constant"] = { fg = M.base_16.base09 },
  ["@constant.builtin"] = { fg = M.base_16.base09 },
  ["@number"] = { fg = M.base_16.base09 },
  ["@boolean"] = { fg = M.base_16.base09 },

  PmenuSel = { fg = M.base_30.black, bg = M.base_30.pmenu_bg },
}

M = require("base46").override_theme(M, "alabaster_dark")

M.type = "dark"

return M
