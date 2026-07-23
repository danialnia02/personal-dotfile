require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local NS = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-D>", "<C-D>zz")
map("n", "<C-U>", "<C-U>zz")
map("n", "<C-O>", "<C-O>zz")
map("n", "<C-I>", "<C-I>zz")
map("n", "<S-G>", "<S-G>zz")
map("n", "<A-o>", "a<cr>", { desc = "Enter new line at cursork" })

map("x", "aa", function()
  require("align").align_to_char {
    length = 1,
  }
end, NS)

vim.keymap.set("x", "aw", function()
  require("align").align_to_string {
    preview = true,
    regex = false,
  }
end, NS)

-- tabufline mappings
map("n", "<leader>X", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "close all buffers" })

map("n", "<leader>.", function()
  require("nvchad.tabufline").move_buf(1)
end, { desc = "Move buffer to right" })

map("n", "<leader>,", function()
  require("nvchad.tabufline").move_buf(-1)
end, { desc = "Move buffer to left" })

-- jump between buffers using alt + number keys
for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end
