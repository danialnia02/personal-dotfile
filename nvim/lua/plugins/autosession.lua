return {
  "rmagatti/auto-session",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>ww", "<cmd>SessionSearch<CR>", desc = "Session search" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Session [s]ave" },
    { "<leader>wd", "<cmd>SessionDelete<CR>", desc = "Session [d]elete" },
  },
  config = function()
    require("auto-session").setup {
      continue_restore_on_error = false,
      session_lens = {
        load_on_setup = true,
        previewer = false,
        theme_conf = {
          border = true,
        },
      },
      -- silent_restore = false,
    }
  end,
}
