-- Allow Neovim to find luarocks packages installed for Lua 5.1 (LuaJIT)
local lr = vim.fn.expand "$APPDATA/luarocks"
package.path  = package.path  .. ";" .. lr .. "/share/lua/5.1/?.lua"
package.path  = package.path  .. ";" .. lr .. "/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";" .. lr .. "/lib/lua/5.1/?.dll"

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.cmd "TSEnable highlight"
vim.cmd "set nowrap"

vim.o.cursorlineopt = "number,line" --show cursorline
require("base46").toggle_transparency()

-- set power shell as default command prompt
vim.o.shell = "pwsh.exe"
vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellquote = ""
vim.o.shellxquote = ""

-- set commentstring for arduino
vim.api.nvim_create_autocmd("FileType", {
  pattern = "arduino",
  command = "setlocal commentstring=//\\ %s",
})

-- Telescope: show placeholder text for image files instead of a blank pane.
-- image.nvim is not used (unsupported on Windows), so this is the fallback.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      local ok, conf = pcall(require, "telescope.config")
      if not ok then return end
      local previewers = require "telescope.previewers"
      local image_exts = {
        jpg=1, jpeg=1, png=1, gif=1, bmp=1, webp=1,
        ico=1, tiff=1, tif=1, heic=1, avif=1, svg=1,
      }
      local orig = conf.values.buffer_previewer_maker or previewers.buffer_previewer_maker
      conf.values.buffer_previewer_maker = function(filepath, bufnr, opts)
        local ext = filepath:match "%.([^%.]+)$"
        if ext and image_exts[ext:lower()] then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              local name = vim.fn.fnamemodify(filepath, ":t")
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false,
                { "", "  [" .. ext:upper() .. "]  " .. name })
            end
          end)
        else
          orig(filepath, bufnr, opts)
        end
      end
    end, 300)
  end,
})

