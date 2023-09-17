local plugins = {
  {
    "nvim-orgmode/orgmode",
    -- ft= so opening an .org file from the shell loads the plugin;
    -- VeryLazy alone leaves the first buffer without org mappings.
    ft = { "org" },
    event = "VeryLazy",
    config = function()
      require("orgmode").setup {
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",

        -- NEXT = the one thing actually in flight on a given path.
        -- Left of the | is open, right of it is closed.
        org_todo_keywords = { "TODO", "NEXT", "WAITING", "|", "DONE", "DROPPED" },

        -- 14 (the default) means every deadline for the next two weeks
        -- piles onto today. 5 keeps today's view honest.
        org_deadline_warning_days = 5,


        org_capture_templates = {
          t = {
            description = "Task -> inbox",
            template = "* TODO %?\n  %u",
            target = "~/orgfiles/refile.org",
          },
          s = {
            description = "Someday / maybe",
            template = "* TODO %?\n  %u",
            target = "~/orgfiles/someday.org",
          },
        },

        org_agenda_custom_commands = {
          -- <Space>oa n -- everything currently in flight, any area
          n = {
            description = "In flight (NEXT only)",
            types = {
              {
                type = "todo",
                match = "TODO=\"NEXT\"",
                org_agenda_overriding_header = "In flight",
              },
            },
          },
        },
      }
      -- Experimental LSP support
      if vim.lsp.enable then
        vim.lsp.enable "org"
      end
    end,
  },
  {
    "vimwiki/vimwiki",
    -- Not lazy: vimwiki is vimscript and must be loaded when the buffer is
    -- created, or opening a wiki file from the shell gets a plain md buffer.
    lazy = false,
    init = function()
      -- Must be set BEFORE the plugin loads; these are read at load time,
      -- so putting them in `config` would silently do nothing.
      vim.g.vimwiki_list = {
        {
          path = "~/vimwiki",
          syntax = "markdown",
          ext = ".md",
        },
      }
      -- 1 = treat .md files anywhere on disk as wiki pages, not just those
      -- under ~/vimwiki. Note this makes <CR> in normal mode create links in
      -- ANY markdown file, including READMEs in git repos.
      vim.g.vimwiki_global_ext = 1
      -- <leader>w* is vimwiki's; the NvChad LSP-workspace and which-key
      -- mappings that used to live there are commented out in mappings.lua.
      vim.g.vimwiki_map_prefix = "<leader>w"
      -- Folding is off ('') by default. 'list' folds list subitems as well as
      -- sections; docs warn it's the slow one on large files -- drop to
      -- 'expr' (sections + code blocks only) if it starts dragging.
      vim.g.vimwiki_folding = "list"
    end,
  },

  {
    "CRAG666/code_runner.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
    init = function()
      require("core.utils").load_mappings "coderunner"
    end,
    opts = {
      mode = "term",
      -- Only these markers promote a file to "project" mode. package.json is
      -- omitted: a stray ~/package.json makes the upward search claim every
      -- file under $HOME as an npm project.
      root_markers = {
        { "Cargo.toml", "cargo run" },
        { "go.mod", "go run ." },
        { "Makefile", "make" },
        { "CMakeLists.txt", "cmake -B build && cmake --build build" },
      },
      focus = true,
      startinsert = false,
      term = { position = "bot", size = 12 },
      filetype = {
        c = {
          "cd $dir &&",
          "gcc -Wall -std=c17 $fileName -o /tmp/$fileNameWithoutExt &&",
          "/tmp/$fileNameWithoutExt",
        },
        cpp = {
          "cd $dir &&",
          "g++ -Wall -std=c++17 $fileName -o /tmp/$fileNameWithoutExt &&",
          "/tmp/$fileNameWithoutExt",
        },
        python = "python3 -u",
        lua = "lua",
        javascript = "node",
        typescript = "npx tsx",
        sh = "bash",
        go = "go run",
        rust = {
          "cd $dir &&",
          "rustc $fileName -o /tmp/$fileNameWithoutExt &&",
          "/tmp/$fileNameWithoutExt",
        },
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
      },
    },
    config = function(_, opts)
      require("code_runner").setup(opts)
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function ()
      return require "custom.configs.null-ls"
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "tailwindcss-language-server",
        "eslint-lsp",
        "prettierd",
        "pyright",
        "mypy",
        "ruff",
        "black",
      }
    }
  },
--  {
--    'MeanderingProgrammer/render-markdown.nvim',
--    ft = { "markdown" },  -- Load when a markdown file is opened
--    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
--    opts = {},
--  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mfussenegger/nvim-dap-python",
    ft="python",
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    config = function (_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },
  {
   "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 1,
      width = 120,
      height = 1,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
      },
      twilight = { enabled = true },
      gitsigns = { enabled = false },
      tmux = { enabled = false },
      kitty = {
        enabled = false,
        font = "+4",
      },
    },
    on_open = function(win)
      vim.cmd("set laststatus=0")
      vim.cmd("set showtabline=0")
      vim.cmd("set cmdheight=0")
    end,
    on_close = function()
      vim.cmd("set laststatus=2")
      vim.cmd("set showtabline=2")
      vim.cmd("set cmdheight=1")
    end,
  },
  config = function(_, opts)
    require("zen-mode").setup(opts)
  end,
  },
  {
  "MunifTanjim/prettier.nvim",
  cmd = "Prettier",
  opts = {
    bin = "prettier",
    filetypes = {
      "css",
      "graphql",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "less",
      "markdown",
      "markdown_inline" ,
      "scss",
      "typescript",
      "typescriptreact",
      "yaml",
      "python",
    },
  },
  },
  {
      "windwp/nvim-ts-autotag",
      ft = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescript",
        "html",
      },
      config = function ()
        require("nvim-ts-autotag").setup()
      end
  },
  {
      "nvim-treesitter/nvim-treesitter",
      opts = function ()
        opts = require "plugins.configs.treesitter"
        opts.ensure_installed = {
          "lua",
          "javascript",
          "typescript",
          "tsx",
          "go",
          "markdown",
          "markdown_inline" ,
        }
        return opts
      end
  },
    {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      require 'custom.cmp' -- Changed require path
    end
  },

}
return plugins
