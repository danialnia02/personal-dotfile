require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.scrolloff = 10
o.fsync = false
o.backupcopy = "yes"
o.writebackup = false
o.number = true
o.relativenumber = true
vim.opt.shortmess:append "A"

-- Folding via treesitter — works for code and markdown headings
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- ShaDa: only save command history (:) and search history (/), nothing else
vim.opt.shada = "'0,:100,/100,h"

-- Restore exact scroll position (not just cursor) when switching buffers
local view_cache = {}
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function() view_cache[vim.api.nvim_get_current_buf()] = vim.fn.winsaveview() end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local view = view_cache[vim.api.nvim_get_current_buf()]
    if view then vim.fn.winrestview(view) end
  end,
})
