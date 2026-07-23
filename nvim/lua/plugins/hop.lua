return {
  "smoka7/hop.nvim",
  opts = {
    multi_windows = true,
    uppercase_labels = true,
  },
  keys = {
    {
      "<leader><leader>j",
      function()
        require("hop").hint_words()
      end,
      desc = "Jump to first Letter",
    },
    {
      "<leader><leader>w",
      function()
        require("hop").hint_words { direction = require("hop.hint").HintDirection.AFTER_CURSOR }
      end,
      desc = "Hop After Cursor",
    },
    {
      "<leader><leader>b",
      function()
        require("hop").hint_words { direction = require("hop.hint").HintDirection.BEFORE_CURSOR }
      end,
      desc = "Hop Before Cursor",
    },
  },
  config = function()
    require("hop").setup()
  end,
}
