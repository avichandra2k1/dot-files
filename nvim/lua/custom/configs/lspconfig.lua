local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities
-- Pyright setup for Python
vim.lsp.config("pyright", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
})
vim.lsp.enable("pyright")

-- JavaScript/TypeScript related servers
local servers = {"ts_ls", "tailwindcss", "eslint"}
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact"}
  })
  vim.lsp.enable(lsp)
end
