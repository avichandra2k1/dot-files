-- vimwiki maps <Tab>/<S-Tab> to next/prev link, which shadows NvChad's
-- buffer cycling (lua/core/mappings.lua:82). Restore them per-buffer on
-- FileType, which runs after vimwiki has set its own mappings.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vimwiki",
  callback = function(ev)
    vim.keymap.set("n", "<Tab>", function()
      require("nvchad.tabufline").tabuflineNext()
    end, { buffer = ev.buf, desc = "Goto next buffer" })

    vim.keymap.set("n", "<S-Tab>", function()
      require("nvchad.tabufline").tabuflinePrev()
    end, { buffer = ev.buf, desc = "Goto prev buffer" })

    -- Link navigation, displaced off <Tab>
    vim.keymap.set("n", "<leader>wn", "<cmd>VimwikiNextLink<CR>", { buffer = ev.buf, desc = "wiki next link" })
    vim.keymap.set("n", "<leader>wp", "<cmd>VimwikiPrevLink<CR>", { buffer = ev.buf, desc = "wiki prev link" })
  end,
})
