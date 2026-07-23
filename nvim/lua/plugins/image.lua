-- Image preview in Telescope.
-- Shows actual images when magick is installed; placeholder otherwise.
--
-- To enable real image rendering:
--   1. winget install ImageMagick.ImageMagick
--   2. scoop install luarocks          (scoop: https://scoop.sh)
--   3. luarocks install magick
--   4. In nvim: :Lazy build image.nvim

local image_exts = {
  jpg=1, jpeg=1, png=1, gif=1, bmp=1,
  webp=1, ico=1, tiff=1, tif=1, heic=1, avif=1, raw=1,
}

local function placeholder(bufnr, text)
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "", "  " .. text })
    end
  end)
end

local function try_image(filepath, bufnr, o)
  local ok, image = pcall(require, "image")
  if not ok then return false end
  local win = (o and o.winid) or vim.api.nvim_get_current_win()
  local ok2, img = pcall(image.from_file, filepath, { window = win, buffer = bufnr })
  if not ok2 or not img then return false end
  return pcall(img.render, img)
end

local function make_maker(orig)
  return function(filepath, bufnr, o)
    local ext = filepath:match("%.([^%.]+)$")
    if ext and image_exts[ext:lower()] then
      if not try_image(filepath, bufnr, o) then
        placeholder(bufnr, "[" .. ext:upper() .. "]  " .. vim.fn.fnamemodify(filepath, ":t"))
      end
    else
      orig(filepath, bufnr, o)
    end
  end
end

return {
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty",
      kitty_method = "normal",
      integrations = {},
      max_width = 80,
      max_height = 24,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      -- Patch conf.values directly after telescope.setup() runs,
      -- bypassing any NvChad config that might overwrite buffer_previewer_maker.
      vim.schedule(function()
        local ok, conf = pcall(require, "telescope.config")
        if not ok then return end
        local previewers = require("telescope.previewers")
        local orig = conf.values.buffer_previewer_maker or previewers.buffer_previewer_maker
        conf.values.buffer_previewer_maker = make_maker(orig)
      end)
      return opts
    end,
  },
}
