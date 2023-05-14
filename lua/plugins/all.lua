return {
  -- find stuff
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
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

  -- tabs
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
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
    build = ':TSUpdate'
  },
  {
    'nvim-treesitter/playground',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
  },

  {
    'simrat39/symbols-outline.nvim',
  },


  -- git utils
  {
    'mbbill/undotree',
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'f-person/git-blame.nvim',
  },

  -- lsp
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig',             lazy = false },
      { 'williamboman/mason.nvim',           lazy = false },
      { 'williamboman/mason-lspconfig.nvim', lazy = false },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' }, { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-nvim-lua' }, -- Snippets
      { 'L3MON4D3/LuaSnip' }, { 'rafamadriz/friendly-snippets' }
    }
  },
  {
    "onsails/lspkind.nvim",
  },
  {
    'moliva/inlay-hints.nvim',
    branch = 'feat/disable-tsserver-adapter',
  },
  -- use('simrat39/inlay-hints.nvim')

  -- lua
  {
    "ckipp01/stylua-nvim",
    build = "cargo install stylua",
  },
  {
    "folke/neodev.nvim",
  },

  -- edit
  {
    'tpope/vim-surround',
  },
  {
    'numToStr/Comment.nvim',
  },
  {
    'windwp/nvim-autopairs',
  },
  {
    'RRethy/vim-illuminate',
  },
  {
    "AckslD/nvim-neoclip.lua",
  },
  {
    'ethanholz/nvim-lastplace',
  },

  -- use('tpope/vim-repeat')
  {
    'ggandor/leap.nvim',
  },

  -- debugging
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui' },
  { 'theHamsta/nvim-dap-virtual-text' },

  -- context menu keybindings
  {
    "folke/which-key.nvim",
  },

  -- todos and diagnostics
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },

  -- rust tools
  {
    'saecki/crates.nvim',
    version = 'v0.3.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  -- use 'simrat39/rust-tools.nvim'

  { 'gbrlsnchs/telescope-lsp-handlers.nvim' },

  -- typescript
  -- use 'jose-elias-alvarez/typescript.nvim'

  -- postman/curl like tool
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },


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
