local status_ok, _ = pcall(require, "impatient")
if not status_ok then
  vim.notify("impatient not found.")
  return
end
