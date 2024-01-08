-- local colorscheme = "tokyonight"
-- local colorscheme = "tokyonight-night"
local colorscheme = "catppuccin-frappe"
-- local colorscheme = "catppuccin-mocha"
-- local colorscheme = "default"
-- local colorscheme = "darkplus"
-- local colorscheme = "darkblue"
-- local colorscheme = "murphy"
-- local colorscheme = "sorbet"
-- local colorscheme = "spacedark"
-- local colorscheme = "gruvbox"

vim.o.background = "dark"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
