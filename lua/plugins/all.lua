return {
  -- find stuff
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    lazy = true
  },

  -- theme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons", 'RRethy/nvim-base16' }
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

  -- ast and highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPre", "BufNewFile" },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or "all"
        -- TODO - remoing help as it is not found as a language - moliva - 2023/05/14
        -- ensure_installed = { "help", "javascript", "typescript", "c", "lua", "rust", "vim", "toml", "http", "json" },
        ensure_installed = { "javascript", "typescript", "c", "lua", "rust", "vim", "toml", "http", "json" },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,
        highlight = {
          -- `false` will disable the whole extension
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        ident = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        }
      })
    end
  },
  {
    'nvim-treesitter/playground',
    -- TODO - set command as trigger - moliva - 2023/05/14
    lazy = true
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('treesitter-context').setup({
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'topline',         -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
      })
    end
  },

  -- git utils
  {
    'mbbill/undotree',
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle }
    }
  },

  -- lua
  {
    "ckipp01/stylua-nvim",
    build = "cargo install stylua",
    event = { "BufReadPre *.lua" },
  },
  {
    "folke/neodev.nvim",
    event = { "BufReadPre *.lua" },
  },

  -- edit
  {
    'tpope/vim-surround',
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    'windwp/nvim-autopairs',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-autopairs").setup {}
    end
  },
  {
    "AckslD/nvim-neoclip.lua",
  },
  -- use('tpope/vim-repeat')

  -- debugging
  {
    'mfussenegger/nvim-dap',
    lazy = true,
  },
  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    lazy = true,
  },

  -- context menu keybindings
  {
    "folke/which-key.nvim",
    lazy = true,
  },

  -- rust tools
  -- use 'simrat39/rust-tools.nvim'

  {
    'gbrlsnchs/telescope-lsp-handlers.nvim',
    -- TODO - review this - moliva - 2023/05/14
    lazy = true,
  },

  -- typescript
  -- use 'jose-elias-alvarez/typescript.nvim'

  -- better notifications
  {
    "folke/noice.nvim",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
}
