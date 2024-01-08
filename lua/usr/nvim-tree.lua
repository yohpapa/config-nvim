local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("nvim-tree not found.")
  return
end

--[[ local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config") ]]
--[[ if not config_status_ok then ]]
--[[   vim.notify("nvim-tree.config not found.") ]]
--[[   return ]]
--[[ end ]]

--[[ local tree_cb = nvim_tree_config.nvim_tree_callback ]]

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>',   api.tree.change_root_to_parent,      opts('Up'))
  vim.keymap.set('n', '?',       api.tree.toggle_help,                opts('Help'))
  vim.keymap.set('n', 'h',       api.node.navigate.parent_close,      opts('Close Directory'))
  vim.keymap.set('n', '-',       api.node.navigate.parent,            opts('Parent Directory'))
  vim.keymap.set('n', '<CR>',    api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', 'l',       api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', 'o',       api.node.open.edit,                  opts('Open'))
  vim.keymap.set('n', 'v',       api.node.open.vertical,              opts('Open: Vertical Split'))
  vim.keymap.set('n', 't',       api.node.open.tab,                   opts('Open: New Tab'))
  vim.keymap.set('n', '<Tab>',   api.node.open.preview,               opts('Open Preview'))
--  vim.keymap.set('n', '-',       api.tree.change_root_to_parent,      opts('Up'))
  vim.keymap.set('n', 'a',       api.fs.create,                       opts('Create File Or Directory'))
  vim.keymap.set('n', 'r',       api.fs.rename,                       opts('Rename'))
  vim.keymap.set('n', 'd',       api.fs.remove,                       opts('Delete'))
  vim.keymap.set('n', 'D',       api.fs.trash,                        opts('Trash'))
  vim.keymap.set('n', 'q',       api.tree.close,                      opts('Close'))
  vim.keymap.set('n', 'y',       api.fs.copy.filename,                opts('Copy Name'))
end

nvim_tree.setup {
  on_attach = my_on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  --[[ open_on_setup = false, ]]
  --[[ ignore_ft_on_setup = { ]]
  --[[   "startify", ]]
  --[[   "dashboard", ]]
  --[[   "alpha", ]]
  --[[ }, ]]
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  --[[ auto_close = true, ]]
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 40,
    --[[ height = 30, ]]
    --[[ hide_root_folder = false, ]]
    side = "left",
    --[[ auto_resize = true, ]]
    --[[ mappings = { ]]
    --[[   custom_only = false, ]]
    --[[   list = { ]]
    --[[   { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" }, ]]
    --[[   { key = "h", cb = tree_cb "close_node" }, ]]
    --[[   { key = "v", cb = tree_cb "vsplit" }, ]]
    --[[   }, ]]
    --[[ }, ]]
    number = false,
    relativenumber = false,
    cursorline = true,
  },
  actions = {
    --[[ quit_on_open = true, ]]
    --[[ window_picker = { enable = true }, ]]
  },
  renderer = {
    highlight_git = true,
    root_folder_modifier = ":t",
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = " ",
          staged = " S",
          unmerged = " ",
          renamed = " ➜",
          deleted = " ",
          untracked = " U",
          ignored = " ◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      }
    }
  }
}

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
local function open_nvim_tree(data)
  local real_file = vim.fn.filereadable(data.file) == 1
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
  if not real_file and not no_name then
    return
  end
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

--[[ vim.api.nvim_create_autocmd("QuitPre", { ]]
--[[   callback = function() ]]
--[[     local invalid_win = {} ]]
--[[     local wins = vim.api.nvim_list_wins() ]]
--[[     for _, w in ipairs(wins) do ]]
--[[       local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)) ]]
--[[       if bufname:match("NvimTree_") ~= nil then ]]
--[[         table.insert(invalid_win, w) ]]
--[[       end ]]
--[[     end ]]
--[[     if #invalid_win == #wins - 1 then ]]
--[[       -- Should quit, so we close all invalid windows. ]]
--[[       for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end ]]
--[[     end ]]
--[[   end ]]
--[[ }) ]]

--[[ vim.api.nvim_create_autocmd({"QuitPre"}, { ]]
--[[     callback = function() vim.cmd("NvimTreeClose") end, ]]
--[[ }) ]]

--[[ local function tab_win_closed(winnr) ]]
--[[   local api = require"nvim-tree.api" ]]
--[[   local tabnr = vim.api.nvim_win_get_tabpage(winnr) ]]
--[[   local bufnr = vim.api.nvim_win_get_buf(winnr) ]]
--[[   local buf_info = vim.fn.getbufinfo(bufnr)[1] ]]
--[[   local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr)) ]]
--[[   local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins) ]]
--[[   if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree ]]
--[[     -- Close all nvim tree on :q ]]
--[[     if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below) ]]
--[[       api.tree.close() ]]
--[[     end ]]
--[[   else                                                      -- else closed buffer was normal buffer ]]
--[[     if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab ]]
--[[       local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1] ]]
--[[       if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree ]]
--[[         vim.schedule(function () ]]
--[[           if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim ]]
--[[             vim.cmd "quit"                                        -- then close all of vim ]]
--[[           else                                                  -- else there are more tabs open ]]
--[[             vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab ]]
--[[           end ]]
--[[         end) ]]
--[[       end ]]
--[[     end ]]
--[[   end ]]
--[[ end ]]
--[[]]
--[[ vim.api.nvim_create_autocmd("WinClosed", { ]]
--[[   callback = function () ]]
--[[     local winnr = tonumber(vim.fn.expand("<amatch>")) ]]
--[[     vim.schedule_wrap(tab_win_closed(winnr)) ]]
--[[   end, ]]
--[[   nested = true ]]
--[[ }) ]]

--[[ vim.api.nvim_create_autocmd("BufEnter", { ]]
--[[   group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}), ]]
--[[   pattern = "NvimTree_*", ]]
--[[   callback = function() ]]
--[[     local layout = vim.api.nvim_call_function("winlayout", {}) ]]
--[[     if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end ]]
--[[   end ]]
--[[ }) ]]
