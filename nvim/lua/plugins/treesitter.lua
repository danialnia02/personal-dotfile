return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    { "windwp/nvim-ts-autotag", opts = {} },
  },
  lazy = true,
  opts = {
    indent = { enable = true },
    highlight = {
      enable = true,
      disable = { "markdown" },
    },
  },
  config = function()
    require("nvim-treesitter").setup {}
  end,
}
