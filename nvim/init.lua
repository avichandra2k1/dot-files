-- NvChad's pinned UI still calls the deprecated vim.lsp.with().
-- Suppress only that warning until the UI plugin is updated.
do
  local deprecate = vim.deprecate
  vim.deprecate = function(name, ...)
    if not tostring(name):match("^vim%.lsp%.with") then
      return deprecate(name, ...)
    end
  end
end

require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"


-- vim keymappings
vim.api.nvim_set_keymap('n', 'gl', '$', { noremap = true })
vim.api.nvim_set_keymap('n', 'gh', '^', { noremap = true })

-- customised vim 
--vim.keymap.set('v', '<', '<gv', {noremap = true, silet = true})
--vim.keymap.set('v', '>', '>gv', {noremap = true, silet = true})

-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })




---- Paste yanked text with p
vim.api.nvim_set_keymap('n', 'P', '"0p', { noremap = true })
vim.api.nvim_set_keymap('v', 'P', '"0p', { noremap = true })

--
---- Paste cut text in the next line with P
--vim.api.nvim_set_keymap('n', 'P', '"1p', { noremap = true })
--vim.api.nvim_set_keymap('v', 'P', '"1p', { noremap = true })
--vim.api.nvim_set_keymap('n', 'P', 'o<Esc>"1p', { noremap = true })
--vim.api.nvim_set_keymap('v', 'P', 'o<Esc>"1p', { noremap = true })

-- Enter a new line below the current line and switch to normal mode with Shift+O
vim.api.nvim_set_keymap('n', '<S-O>', 'o<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-O>', 'o<Esc>', { noremap = true, silent = true })
