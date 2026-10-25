local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sql = { "sqlfluff" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    sqlfluff = {
      -- pip --user puts the exe outside PATH on this machine
      command = vim.fn.executable "sqlfluff" == 1 and "sqlfluff"
        or vim.fn.expand "~/AppData/Roaming/Python/Python312/Scripts/sqlfluff.exe",
      -- dialect: mysql by default; `:let g:sql_dialect = "tsql"` for MSSQL
      args = function()
        return { "format", "--dialect", vim.g.sql_dialect or "mysql", "-" }
      end,
      stdin = true,
      require_cwd = false,
    },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
