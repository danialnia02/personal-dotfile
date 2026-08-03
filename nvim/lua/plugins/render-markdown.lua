return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  enabled = true,
  opts = {
    heading = { sign = false },
    code = { sign = false },
    sign = { enabled = false },
    render_modes = { "n", "v", "i", "c" },
  },
}
