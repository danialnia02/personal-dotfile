return {
  "rmagatti/auto-session",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>ww", "<cmd>AutoSession search<CR>", desc = "Session search" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Session [s]ave" },
    { "<leader>wd", "<cmd>SessionDelete<CR>", desc = "Session [d]elete" },
  },
  config = function()
    require("auto-session").setup {
      continue_restore_on_error = false,
      -- silent_restore = false,
    }
  end,
}
