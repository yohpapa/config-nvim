local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lspconfig not found!")
  return
end

require("usr.lsp.mason")
require("usr.lsp.handlers").setup()
require("usr.lsp.null-ls")
