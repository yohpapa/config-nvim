local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	vim.notify("null-ls not found!")
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		formatting.stylua,
    formatting.rustfmt,
		--[[ diagnostics.selene, ]]
		--[[ formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }), ]]
		--[[ formatting.black.with({ extra_args = { "--fast" } }), ]]
		--[[ diagnostics.flake8 ]]
	},
})
