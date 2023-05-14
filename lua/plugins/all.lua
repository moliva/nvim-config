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
    -- TODO - set command as trigger - moliva - 2023/05/14
    lazy = true
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
  },

  {
    'simrat39/symbols-outline.nvim',
    lazy = true
  },


  -- git utils
  {
    'mbbill/undotree',
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
      { 'neovim/nvim-lspconfig', },
      { 'williamboman/mason.nvim', },
      { 'williamboman/mason-lspconfig.nvim', },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' }, { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-nvim-lua' }, -- Snippets
      { 'L3MON4D3/LuaSnip' }, { 'rafamadriz/friendly-snippets' }
    }
  },
  {
    "onsails/lspkind.nvim",
    lazy = true,
  },

  -- lua
  {
    "ckipp01/stylua-nvim",
    build = "cargo install stylua",
    lazy = true,
  },
  {
    "folke/neodev.nvim",
    lazy = true,
  },

  -- edit
  {
    'tpope/vim-surround',
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
