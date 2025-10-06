local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

vim.lsp.config('terraformls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    terraform = {
      validate = true
    }
  }
})

vim.lsp.enable('terraformls')
