---@type ChadrcConfig
local M = {}
-- Add this line at the top of the file
vim.api.nvim_create_autocmd("VimEnter", { callback = function() print("chadrc.lua loaded successfully") end })

-- Load your custom mappings
M.mappings = require "custom.mappings"

-- M.options = require "custom.options"

-- M.ui = { theme = 'jellybeans' }
M.ui = {
  ------------------------------- base46 -------------------------------------
  -- hl = highlights
  -- TabLineFill -> TabLine -> StatusLineNC, none of which base46 defines, so they
  -- fell back to Neovim's built-in grey and painted a band under the tabufline.
  -- These need hl_add, not hl_override: override only merges onto existing keys.
  hl_add = {
    TabLine     = { bg = "NONE" },
    TabLineFill = { bg = "NONE" },
    TabLineSel  = { bg = "NONE" },
  },
  -- hl_override = {},
  -- Transparent tabufline. base46's glassy.lua (transparency = true) clears bg on
  -- Normal/Pmenu/Telescope/NvimTree groups but no TbLine* group, so the tab bar
  -- stayed an opaque slab over the transparent editor. Delete this block and
  -- uncomment the line above to go back to the theme's solid tab bar.
  hl_override = {
    TblineFill            = { bg = "NONE" },
    TbLineBufOff          = { bg = "NONE" },
    TbLineBufOffClose     = { bg = "NONE" },
    TbLineBufOffModified  = { bg = "NONE" },
    TbLineBufOn           = { bg = "NONE", bold = true },
    TbLineBufOnClose      = { bg = "NONE" },
    TbLineBufOnModified   = { bg = "NONE" },
    TbLineThemeToggleBtn  = { bg = "NONE" },
    TbLineCloseAllBufsBtn = { bg = "NONE", fg = "red" },
  },
  --changed_themes = {},
  theme_toggle = { "jellybeans", "alabaster_light" },
  theme = "jellybeans", -- default theme
  transparency = true,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
 statusline = {
    separator_style = "round",
    overriden_modules = function(modules)
      modules[2] = (function()
        local config = require("core.utils").load_config().ui.statusline
        local sep_style = config.separator_style

        local default_sep_icons = {
          default = { left = "", right = " " },
          round = { left = "", right = "" },
          block = { left = "█", right = "█" },
          arrow = { left = "", right = "" },
        }

        local separators = (type(sep_style) == "table" and sep_style) or default_sep_icons[sep_style]

        local sep_r = separators["right"]
        local icon = " 󰈚 "
        local name = vim.fn.expand("%:.")

        if name ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and " " .. ft_icon) or ""
          end

          name = " " .. name .. " "
        end

        return "%#St_file_info#" .. icon .. name .. "%#St_file_sep#" .. sep_r
      end)()
    end,
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
  },

  nvdash = {
    load_on_startup = true,

    header = {
--      "           ▄ ▄                   ",
--      "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
--      "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
--      "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
--      "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
--      "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
--      "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
--      "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
--      "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
        "☆      ｡☆✼★━━━━━━━━━━━━★✼☆｡       ☆",
        "☆                                 ☆",
        "☆      ░█████╗░██╗░░░██╗██╗       ☆",
        "☆      ██╔══██╗██║░░░██║██║       ☆",
        "☆      ███████║╚██╗░██╔╝██║       ☆",
        "☆      ██╔══██║░╚████╔╝░██║       ☆",
        "☆      ██║░░██║░░╚██╔╝░░██║       ☆",
        "☆      ╚═╝░░╚═╝░░░╚═╝░░░╚═╝       ☆",
        "☆                                 ☆",
        "☆     ▂▃▅▇█▓▒░۩۞۩ ۩۞۩░▒▓█▇▅▃▂     ☆",
    },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },

  cheatsheet = { theme = "grid" }, -- simple/grid

--  lsp = { signature = true },

  term = {
    hl = "Normal:term,WinSeparator:WinSeparator",
    sizes = { sp = 0.3, vsp = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },
}
M.plugins = "custom.plugins"

return M
