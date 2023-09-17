
local M = {}

M.general = {
  i = {
    ["<C-b>"] = { "<ESC>^i", "move beginning of line" },
    ["<C-e>"] = { "<End>", "move end of line" },
    ["<C-h>"] = { "<Left>", "move left" },
    ["<C-l>"] = { "<Right>", "move right" },
    ["<C-j>"] = { "<Down>", "move down" },
    ["<C-k>"] = { "<Up>", "move up" },
  },
  n = {
   -- Test mapping
    -- ["<leader>tc"] = { "<cmd>echo 'Test mapping works!'<CR>", "Test mapping" },
    ["<left>"] = { "<C-w>h", "switch window left" },
    ["<right>"] = { "<C-w>l", "switch window right" },
    ["<down>"] = { "<C-w>j", "switch window down" },
    ["<up>"] = { "<C-w>k", "switch window up" },
    ["<Esc>"] = { "<cmd>noh<CR>", "clear highlights" },
    ["<C-s>"] = { "<cmd>w<CR>", "save file" },
    ["<C-c>"] = { "<cmd>%y+<CR>", "copy whole file" },
    ["<leader>n"] = { "<cmd>set nu!<CR>", "toggle line number" },
    ["<leader>rn"] = { "<cmd>set rnu!<CR>", "toggle relative number" },
    ["<leader>ch"] = { "<cmd>NvCheatsheet<CR>", "toggle nvcheatsheet" },
    ["<leader>fm"] = { 
      function()
        require("conform").format { lsp_fallback = true }
      end,
      "format file"
    },
    ["<leader>ds"] = { vim.diagnostic.setloclist, "LSP diagnostic loclist" },
    ["<leader>b"] = { "<cmd>enew<CR>", "new buffer" },
    -- ["<tab>"] = {
    --   function()
    --     require("nvchad.tabufline").next()
    --   end,
    --   "goto next buffer"
    -- }
    -- ["<S-tab>"] = {
    --   function()
    --     require("nvchad.tabufline").prev()
    --   end,
    --   "goto prev buffer"
    -- },
    ["<leader>x"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "close buffer"
    },
    ["<leader>tt"] = {
      "<cmd>lua require('base46').toggle_transparency()<CR>",
      "Toggle Background Transparency",
    },
    ["<leader>tl"] = {
      "<cmd>lua require('base46').toggle_theme()<CR>",
      "Toggle light/dark theme",
    },
  },
  v = {
    ["<leader>/"] = { "gc", "toggle comment", silent = true },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"}
  }
}

--M.dap_python = {
--  plugin = true,
--  n = {
--    ["<leader>dpr"] = {
--      function()
--        require('dap-python').test_method()
--      end
--    }
--  }
--}
M.comment = {
  plugin = true,
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },
}

M.custom = {
  n = {
    -- Scroll window while keeping cursor position
    ["<S-j>"] = { "<C-e>", "Scroll window down" },
    ["<S-k>"] = { "<C-y>", "Scroll window up" },

    -- Wrap word under cursor in normal mode
    ["<leader>\""] = { "bi\"<Esc>ea\"<Esc>", "Surround word with quotes" },
    ["<leader>'"] = { "bi'<Esc>ea'<Esc>", "Surround word with single quotes" },
    ["<leader>~"] = { "bi~<Esc>ea~<Esc>", "Surround word with tildes" },
    ["<leader>`"] = { "bi`<Esc>ea`<Esc>", "Surround word with backticks" },
  },
    
  
  v = {
    -- Scroll in visual mode too
    ["<S-j>"] = { "<C-e>", "Scroll window down" },
    ["<S-k>"] = { "<C-y>", "Scroll window up" },

     -- Wrap selected text
    ["<leader>\""] = { "c\"<C-r>\"\"<Esc>", "Surround selection with quotes" },
    ["<leader>'"] = { "c'<C-r>\"'<Esc>", "Surround selection with single quotes" },
    ["<leader>~"] = { "c~<C-r>\"~<Esc>", "Surround selection with tildes" },
    ["<leader>`"] = { "c`<C-r>\"`<Esc>", "Surround selection with backticks" },
    
  },
}




M.nvimtree = {
  plugin = true,

  n = {
    ["<C-n>"] = { "<cmd>NvimTreeToggle<CR>", "toggle nvimtree" },
    ["<leader>e"] = { "<cmd>NvimTreeFocus<CR>", "focus nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    ["<leader>fw"] = { "<cmd>Telescope live_grep<CR>", "live grep" },
    ["<leader>fb"] = { "<cmd>Telescope buffers<CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd>Telescope help_tags<CR>", "help page" },
    ["<leader>ma"] = { "<cmd>Telescope marks<CR>", "telescope marks" },
    ["<leader>fo"] = { "<cmd>Telescope oldfiles<CR>", "find oldfiles" },
    ["<leader>fz"] = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "find in current buffer" },
    ["<leader>cm"] = { "<cmd>Telescope git_commits<CR>", "git commits" },
    ["<leader>gt"] = { "<cmd>Telescope git_status<CR>", "git status" },
    ["<leader>pt"] = { "<cmd>Telescope terms<CR>", "pick hidden term" },
    ["<leader>th"] = { "<cmd>Telescope themes<CR>", "nvchad themes" },
    ["<leader>ff"] = { "<cmd>Telescope find_files<CR>", "find files" },
    ["<leader>fa"] = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", "find all files" },
  },
}

M.nvterm = {
  plugin = true,

  n = {
    -- toggle in terminal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<A-t>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },
  },
  t = {
    -- toggle in terminal mode
    ["<A-t>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },
  }
}

M.whichkey = {
  plugin = true,

  n = {
    -- Commented out: <leader>w* is now the vimwiki prefix.
--     ["<leader>wK"] = { "<cmd>WhichKey<CR>", "which-key all keymaps" },
--     ["<leader>wk"] = {
--       function()
--         vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
--       end,
--       "which-key query lookup",
--     },
  },
}

-- Add other plugin-specific mappings here (e.g., for blankline)

M.coderunner = {
  plugin = true,

  n = {
    ["<leader>rr"] = { "<cmd>w<CR><cmd>RunFile<CR>", "run current file" },
    ["<leader>rp"] = { "<cmd>RunProject<CR>", "run project" },
    ["<leader>rq"] = { "<cmd>RunClose<CR>", "close runner" },
  },
}

return M
