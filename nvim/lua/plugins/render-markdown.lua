return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  enabled = false,
  opts = {
    heading = { sign = false },
    code = { sign = false },
    sign = { enabled = false },
  },
}
