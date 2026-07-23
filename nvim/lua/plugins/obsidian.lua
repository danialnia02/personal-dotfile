return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy=true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "[[O]bsidian [O]pen" },
    { "<leader>gf", "<cmd>ObsidianFollowLink<CR>", desc = "Obsidian:[f]ollow link" },
    -- { "<leader>oc", "<cmd>ObsidianToggleCheckbox<CR>", desc = "[O]bsidian: Toggle [C]heckbox" },
    { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "[O]bsidian: New [N]ote" },
    { "<leader>ot", "<cmd>ObsidianNewFromTemplate<CR>", desc = "[O]bsidian: New note from [t]emplate" },
    { "<leader>oT", "<cmd>ObsidianTemplate<CR>", desc = "[b]bsidian: Copy from [T]emplate" },
    { "<leader>op", "<cmd>ObsidianPasteImg<CR>", desc = "[O]bsidian: [P]aste Image" },
    { "<leader>oc", "<cmd>ObsidianTOC<CR>", desc = "[O]bsidian: Table [o]f Contents" },
    {
      "<cr>",
      function()
        return require("obsidian").smart_action()
      end,
      desc = "Obsidian: Smart Action, depending on context",
    },
  },
  opts={

  },
  config = function()
    vim.opt.conceallevel = 1

    require("obsidian").setup {
      workspaces = {
        {
          name = "notes",
          path = "C:/Users/daani/Documents/notes",
        },
      },
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },
      preferred_link_style = "wiki",
      notes_subdir = "inbox",
      new_notes_location = "notes_subdir",
      wiki_link_func = "use_alias_only",

      -- naming new file
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix .. "-" .. tostring(os.date "%d-%m-%Y")
      end,

      --follow url link externally
      ---@param url string
      follow_url_func = function(url)
        vim.ui.open(url)
      end,

      -- not working for some reason
      ---@param img string
      follow_img_func = function(img)
        vim.cmd(':silent exec "!start' .. img .. '"')
      end,

      -- Specify where to keep images
      attachments = {
        img_folder = "C:/Users/daani/Documents/notes/assets/imgs",

        ---@return string
        img_name_func = function()
          -- Prefix image names with timestamp.
          return string.format("%s-", os.time())
        end,
      },
      -- New File Template
      templates = {
        folder = "templates",
        date_format = "%d-%m-%Y",
        time_format = "%H:%M",
        substitutions = {
          date = os.date "%d-%m-%Y",
          time = os.date "%H:%M",
        },
      },
    }
  end,
}
