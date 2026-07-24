local nvlsp = require "nvchad.configs.lspconfig"

-- Apply common config to every server
vim.lsp.config("*", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Per-server overrides
vim.lsp.config("marksman", {
  filetypes = { "markdown" },
})

vim.lsp.config("lua_ls", {
  filetypes = { "lua" },
})

vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "E501" },
          maxLineLength = 200,
        },
      },
    },
  },
})

vim.lsp.config("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp", "arduino", "ino" },
  settings = {
    clangd = {
      clangdFileStatus = true,
      formatting = {
        style = { ColumnLimit = 200 },
      },
    },
  },
})

vim.lsp.config("jdtls", {
  filetypes = { "java" },
  cmd = {
    "C:/Users/daani/AppData/Local/nvim-data/mason/bin/jdtls.cmd",
    "-configuration",
    "/home/user/.cache/jdtls/config",
    "-data",
    "/home/user/.cache/jdtls/workspace",
  },
})

vim.lsp.enable {
  "html",
  "cssls",
  "vtsls",
  "marksman",
  "lua_ls",
  "pylsp",
  "kotlin_language_server",
  "clangd",
  "jdtls",
}
