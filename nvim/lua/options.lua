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
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- ShaDa: only save command history (:) and search history (/), nothing else
vim.opt.shada = "'0,:100,/100,h"
vim.opt.timeoutlen = 200

-- Keep tabufline visible after terminal resize (e.g. WezTerm title bar toggle)
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.o.showtabline = 2
  end,
})

-- Force tabufline devicon groups to black so tab icons don't show filetype colors
vim.api.nvim_create_autocmd({ "BufEnter", "ColorScheme" }, {
  callback = function()
    for _, hl in ipairs(vim.fn.getcompletion("DevIcon", "highlight")) do
      if hl:match("BufO") then
        vim.api.nvim_set_hl(0, hl, { fg = 0xffffff })
      end
    end
  end,
})

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
