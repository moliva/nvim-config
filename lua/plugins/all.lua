return {
  -- theme & ui
  {
    "rose-pine/neovim",
    name = "rose-pine",
    event = "VeryLazy",
    config = function()
      -- scheme: "Harmonic16 Dark"
      -- author: "Jannik Siebert (https://github.com/janniks)"

      require("rose-pine").setup({
        dim_inactive_windows = true,

        palette = {
          -- https://rosepinetheme.com/palette/ingredients/

          -- Override the builtin palette per variant
          --     moon = {
          --       _nc = "#1f1d30",
          --       base = "#232136",
          --       surface = "#2a273f",
          --       overlay = "#393552",
          --       muted = "#6e6a86",
          --       subtle = "#908caa",
          --       text = "#e0def4",
          --       love = "#eb6f92",
          --       gold = "#f6c177",
          --       rose = "#ea9a97",
          --       pine = "#3e8fb0",
          --       foam = "#9ccfd8",
          --       iris = "#c4a7e7",
          --       leaf = "#95b1ac",
          --       highlight_low = "#2a283e",
          --       highlight_med = "#44415a",
          --       highlight_high = "#56526e",
          --       none = "NONE",
          --
          --       _nc = "#0b1c2c",
          --       base = "#223b54",
          --       surface = "#2a273f",
          --       overlay = "#405c79",
          --       muted = "#627e99",
          --       subtle = "#aabcce",
          --       text = "#cbd6e2",
          --       love = "#e5ebf1",
          --       gold = "#f7f9fb",
          --       rose = "#bf8b56",
          --       pine = "#bfbf56",
          --       foam = "#568bbf",
          --       iris = "#568bbf",
          --       leaf = "#8b56bf",
          --       highlight_low = "#bf568b",
          --       highlight_med = "#bf5656",
          --       highlight_high = "#56526e",
          --       none = "NONE",
          -- -- base00: "0b1c2c"
          -- -- base01: "223b54"
          -- -- base02: "405c79"
          -- -- base03: "627e99"
          -- -- base04: "aabcce"
          -- -- base05: "cbd6e2"
          -- -- base06: "e5ebf1"
          -- -- base07: "f7f9fb"
          -- -- base08: "bf8b56"
          -- -- base09: "bfbf56"
          -- -- base0A: "8bbf56"
          -- -- base0B: "56bf8b"
          -- -- base0C: "568bbf"
          -- -- base0D: "8b56bf"
          -- -- base0E: "bf568b"
          -- -- base0F: "bf5656"
          --     },
        },

        highlight_groups = {
          TelescopeBorder = { fg = "highlight_high", bg = "none" },
          TelescopeNormal = { bg = "none" },
          TelescopePromptNormal = { bg = "base" },
          TelescopeResultsNormal = { fg = "subtle", bg = "none" },
          TelescopeSelection = { fg = "text", bg = "base" },
          TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
        },
      })
    end,
  },

  -- issue here!
  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons', -- optional, for file icons
  --   },
  --
  -- tag = 'nightly' -- optional, updated every week. (see issue #1193)
  -- }

  -- edit
  {
    "tpope/vim-surround",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "windwp/nvim-autopairs",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    lazy = true,
    config = function()
      vim.api.nvim_exec(
        [[
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"]             = '<C-j>'
let g:VM_maps["Add Cursor Up"]               = '<C-k>'
]],
        false
      )
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    keys = {
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
      {
        "zK",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold",
      },
    },
    config = function()
      require("lsp-zero")
      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "lsp", "indent" }
        end,
      })
    end,
  },

  -- use('tpope/vim-repeat')

  -- git utils
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle },
    },
  },

  -- lua
  {
    "ckipp01/stylua-nvim",
    build = "cargo install stylua",
    event = { "BufReadPre *.lua" },
  },

  -- linters
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    config = function()
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        -- lua = { "luacheck" }, -- lua check not working with mason
        -- lua = { "selene" }, -- not adding lots of value currently
        json = { "jsonlint" },
      }
    end,
  },

  -- formatting
  {
    "stevearc/conform.nvim",
    lazy = true,
    config = function()
      local conform = require("conform")
      conform.setup({
        -- format_on_save = {
        --   -- I recommend these options. See :help conform.format for details.
        --   lsp_fallback = true,
        --   timeout_ms = 500,
        -- },
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          typescript = function(bufnr)
            -- if conform.get_formatter_info("biome", bufnr).available then
            --   return { "biome" }
            -- else
            return { "prettier" }
            -- end
          end,
          typescriptreact = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          -- typescript = { { "prettierd", "prettier" } },
          -- typescriptreact = { { "prettierd", "prettier" } },
          -- javascript = { { "prettierd", "prettier" } },
          -- javascriptreact = { { "prettierd", "prettier" } },
          -- json = { { "prettierd", "prettier" } },
          -- html = { { "prettierd", "prettier" } },
          -- css = { { "prettierd", "prettier" } },
          go = { "goimports", "gofmt" },
          toml = { "taplo" },
          sql = { "pg_format", "sqlfluff" },
          rust = { "rustfmt" },
          zig = { "zigfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          sh = { "shfmt" },
          xml = { "xmlformat" },
          java = { "clang-format" },
        },
      })

      require("conform").formatters.shfmt = {
        prepend_args = function(self, ctx)
          return { "-i", "2" }
        end,
      }
    end,
  },

  -- typescript
  -- use 'jose-elias-alvarez/typescript.nvim'

  -- maximize windows
  {
    "declancm/maximize.nvim",
    keys = {
      {
        "<leader>z",
        function()
          require("maximize").toggle()
        end,
        desc = "Maximize buffer",
      },
    },
    config = function()
      require("maximize").setup()
    end,
  },

  {
    "moliva/private.nvim",
    -- dir = "/Users/moliva/repos/private.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("private").setup()
    end,
    keys = {
      { "<leader>i", nil, desc = "Private" },
      { "<leader>ir", ":Lazy reload private.nvim<CR>" },
      { "<leader>ie", nil, desc = "Encrypt" },
      {
        "<leader>iep",
        function()
          require("private.predef_actions").encrypt_path()
        end,
        desc = "encrypt action",
      },
      {
        "<leader>iec",
        function()
          require("private.predef_actions").encrypt_current_file()
        end,
        desc = "encrypt current file",
      },
      { "<leader>id", nil, desc = "Decrypt" },
      {
        "<leader>idp",
        function()
          require("private.predef_actions").decrypt_path()
        end,
        desc = "decrypt action",
      },
      {
        "<leader>idc",
        function()
          require("private.predef_actions").decrypt_current_file()
        end,
        desc = "decrypt current file",
      },
      {
        "<leader>ic",
        function()
          print(vim.inspect(require("private").cache))
        end,
        desc = "inspect cache",
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    "filipdutescu/renamer.nvim",
    branch = "master",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local mappings_utils = require("renamer.mappings.utils")

      require("renamer").setup({
        -- The popup title, shown if `border` is true
        title = "Rename",
        -- The padding around the popup content
        padding = {
          top = 0,
          left = 0,
          bottom = 0,
          right = 0,
        },
        -- The minimum width of the popup
        min_width = 15,
        -- The maximum width of the popup
        max_width = 100,
        -- Whether or not to shown a border around the popup
        border = true,
        -- The characters which make up the border
        border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        -- Whether or not to highlight the current word references through LSP
        show_refs = true,
        -- Whether or not to add resulting changes to the quickfix list
        with_qf_list = true,
        -- Whether or not to enter the new name through the UI or Neovim's `input`
        -- prompt
        with_popup = true,
        -- The keymaps available while in the `renamer` buffer. The example below
        -- overrides the default values, but you can add others as well.
        mappings = {
          ["<c-i>"] = mappings_utils.set_cursor_to_start,
          ["<c-a>"] = mappings_utils.set_cursor_to_end,
          ["<c-e>"] = mappings_utils.set_cursor_to_word_end,
          ["<c-b>"] = mappings_utils.set_cursor_to_word_start,

          ["<c-c>"] = mappings_utils.clear_line,

          ["<esc>"] = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
          end,

          ["<c-u>"] = mappings_utils.undo,
          ["<c-r>"] = mappings_utils.redo,
        },
        -- Custom handler to be run after successfully renaming the word. Receives
        -- the LSP 'textDocument/rename' raw response as its parameter.
        handler = nil,
      })
    end,
  },
}
