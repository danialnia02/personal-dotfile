-- Image / binary preview for Telescope.
-- Shows a placeholder for image and binary files instead of binary garbage.
-- For ACTUAL image rendering, install magick first:
--   winget install ImageMagick.ImageMagick
--   then inside nvim run: :Lazy build image.nvim

local image_exts = {
  jpg=1, jpeg=1, png=1, gif=1, bmp=1, webp=1,
  ico=1, tiff=1, tif=1, heic=1, avif=1, raw=1,
}
local binary_exts = {
  pdf=1, zip=1, tar=1, gz=1, mp4=1, mp3=1,
  wav=1, exe=1, dll=1, obj=1, pyc=1,
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
  local ok3 = pcall(img.render, img)
  return ok3
end

return {
  -- Requires: winget install ImageMagick.ImageMagick + :Lazy build image.nvim
  {
    "3rd/image.nvim",
    lazy = true,
    build = false,
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
      opts.defaults = opts.defaults or {}
      opts.defaults.buffer_previewer_maker = function(filepath, bufnr, o)
        local ext = filepath:match("%.([^%.]+)$")
        if not ext then
          require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, o)
          return
        end
        ext = ext:lower()

        if image_exts[ext] then
          if not try_image(filepath, bufnr, o) then
            placeholder(bufnr, "[" .. ext:upper() .. "]  " .. vim.fn.fnamemodify(filepath, ":t"))
          end
        elseif binary_exts[ext] then
          placeholder(bufnr, "[" .. ext:upper() .. " file — no preview]")
        else
          require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, o)
        end
      end
      return opts
    end,
  },
}
