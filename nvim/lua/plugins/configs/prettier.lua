local M = {
  filetype = {
    markdown = {
      require("formatter.filetypes.markdown").prettier,
    },
    lua = {
      require("formatter.filetypes.lua").prettier,
    },
    -- javascript = {
    --   require("formatter.filetypes.javascript").prettier,
    -- },
    typescript = {
      require("formatter.filetypes.typescript").prettier,
    },
    java = {
      require("formatter.filetypes.java").prettier,
    },
  },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  command = "FormatWriteLock",
})

return M
