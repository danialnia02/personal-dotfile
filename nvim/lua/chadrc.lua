-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "vscode_dark",
  changed_themes = {
    vscode_dark = {
      base_16 = {
        base00 = "#1E1E1E", -- background colour
        base01 = "#26262f",
        base02 = "#686766", -- selection background
        -- base02 = "#303030", -- selection background
        base03 = "#3C3C3C",
        base04 = "#464646",
        base05 = "#D4D4D4", -- equal sign and shit
        base06 = "#E9E9E9",
        base07 = "#FFFFFF",
        base08 = "#9CDCFE", -- variable colours
        base09 = "#B5CEA8",
        base0A = "#4EC9B0", -- object type colour
        base0B = "#BD8D78", -- string colour
        base0C = "#18a2fe", -- curly bracket color
        base0D = "#DCDCAA", -- function, methods, attribute Ids, headings
        base0E = "#C586C0", -- keywords, storage, selector, markup italic
        base0F = "#18a2fe", -- square bracket color
      },
      base_30 = {
        white = "#dee1e6", -- focused tab colour
        darker_black = "#1a1a1a", -- floating tab colour
        black = "#1E1E1E", --  nvim bg
        black2 = "#252525", -- highlight line colour
        one_bg = "#282828",
        one_bg2 = "#313131",
        one_bg3 = "#3a3a3a",
        grey = "#FFFFFF", -- change line number colour
        grey_fg = "#6A9955", -- change comment colour
        grey_fg2 = "#585858",
        light_grey = "#626262", -- non-focused tab colour
        red = "#D16969",
        baby_pink = "#ea696f",
        pink = "#bb7cb6",
        line = "#2e2e2e", -- for lines like vertsplit
        green = "#B5CEA8",
        green1 = "#4EC994",
        vibrant_green = "#bfd8b2",
        blue = "#569CD6", -- icon colour
        nord_blue = "#60a6e0",
        yellow = "#D7BA7D", -- warning colour
        sun = "#e1c487",
        purple = "#c68aee",
        dark_purple = "#b77bdf",
        teal = "#4294D6",
        orange = "#d3967d",
        cyan = "#9CDCFE",
        statusline_bg = "#242424", -- status line background colour
        lightbg = "#303030", -- status line colour
        pmenu_bg = "#60a6e0",
        folder_bg = "#7A8A92", -- folder colour
      },
    },
  },
  hl_override = {
    CursorLine = {
      bg = "#353836",
    },
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  theme = "vscode_dark",
  transparency = true,
  options = {
    theme = "vscode_dark",
    section_separators = { "", "" },
    component_separators = { "", "" },
    disable_background = true,
  },
  lualine = {
    theme = "vscode_dark",
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = { "fugitive", "nvim-tree" },
  },
}

return M
