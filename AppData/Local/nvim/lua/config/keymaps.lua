-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- This file is automatically loaded by lazyvim.plugins.config

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Move Lines
-- map("n", "J", ":m .+1<cr>==", { desc = "Move down" })
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("i", "J", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
-- map("n", "K", ":m .-2<cr>==", { desc = "Move up" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up" })
-- map("i", "K", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })

-- lazy
map("n", "<leader>L", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- save file
map("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Paste over currently selected text without yanking it
map("v", "p", '"_dP', { desc = "Paste over currently selected text without yanking it" })

--use <space>h to go beggining of line
map("n", "<leader>h", "^", { desc = "go to beggining of the line" })
map("v", "<leader>h", "^", { desc = "go to beggining of the line" })

--use <space>l to go end of line
map("n", "<leader>l", "$", { desc = "go  to end of the line" })
map("v", "<leader>l", "$", { desc = "go  to end of the line" })

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- map("n", "zR", require("ufo").openAllFolds, { desc = "open all folds (ufo)" })
-- map("n", "zM", require("ufo").closeAllFolds, { desc = "close all folds (ufo)" })
