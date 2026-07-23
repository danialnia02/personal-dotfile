-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.vtsls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

lspconfig.marksman.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "markdown" },
}

lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "lua" },
}

lspconfig.pylsp.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
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
}

lspconfig.kotlin_language_server.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

lspconfig.clangd.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "c", "cpp", "objc", "objcpp", "arduino", "ino" },
  settings = {
    clangd = {
      clangdFileStatus = true,
      formatting = {
        style = {
          ColumnLimit = 200,
        },
      },
    },
  },
}


lspconfig.jdtls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "java" },
  -- cmd = {
  --   "jdtls",
  --   "-configuration",
  --   "C:/Users/daani/AppData/Local/nvim-data/mason/bin",
  --   "-data",
  --   "C:/Users/daani/.cache/jdtls/config",
  -- },
  cmd = {
    "C:/Users/daani/AppData/Local/nvim-data/mason/bin/jdtls.cmd",
    "-configuration",
    "/home/user/.cache/jdtls/config",
    "-data",
    "/home/user/.cache/jdtls/workspace",
  },
}
