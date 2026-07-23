return {
  "mhartington/formatter.nvim",
  event = "VeryLazy",
  opts = function()
    return require "plugins.configs.prettier"
  end,
}
