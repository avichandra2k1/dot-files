local cmp = require 'cmp'

cmp.setup {
  filetypes = { 'markdown', 'md' },
  sources = {} -- Completely disable all sources for Markdown
}
