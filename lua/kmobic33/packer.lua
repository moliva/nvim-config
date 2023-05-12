-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  -- find stuff
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use('ThePrimeagen/harpoon')

  -- theme
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  })
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', 'RRethy/nvim-base16' }
  })

  -- tabs
  use({ 'romgrk/barbar.nvim', requires = 'nvim-web-devicons' })

  -- issue here!
  -- use {
  --   'nvim-tree/nvim-tree.lua',
  --   requires = {
  --     'nvim-tree/nvim-web-devicons', -- optional, for file icons
  --   },
  --
  -- tag = 'nightly' -- optional, updated every week. (see issue #1193)
  -- }

  -- taken from lunarvim
  -- {
  --   "kyazdani42/nvim-tree.lua",
  --   config = function()
  --     require("lvim.core.nvimtree").setup()
  --   end,
  --   cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
  --   event = "User DirOpened",
  -- },

  -- ast and highlighting
  use('nvim-treesitter/nvim-treesitter', {
    run = ':TSUpdate'
  })
  use('nvim-treesitter/playground')
  use('nvim-treesitter/nvim-treesitter-context')

  use('simrat39/symbols-outline.nvim')


  -- git utils
  use({ 'mbbill/undotree' })
  use({ 'tpope/vim-fugitive' })
  use({ 'f-person/git-blame.nvim' })

  -- lsp
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' }, { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-nvim-lua' }, -- Snippets
      { 'L3MON4D3/LuaSnip' }, { 'rafamadriz/friendly-snippets' } }
  }
  use({ "onsails/lspkind.nvim" })
  use({ 'moliva/inlay-hints.nvim', branch = 'feat/disable-tsserver-adapter' })
  -- use('simrat39/inlay-hints.nvim')

  -- lua
  use({ "ckipp01/stylua-nvim", run = "cargo install stylua" })
  use("folke/neodev.nvim")

  -- edit
  use('tpope/vim-surround')
  use('numToStr/Comment.nvim')
  use('windwp/nvim-autopairs')
  use('RRethy/vim-illuminate')
  use({ "AckslD/nvim-neoclip.lua" })
  use('ethanholz/nvim-lastplace')

  -- use('tpope/vim-repeat')
  use('ggandor/leap.nvim')

  -- debugging
  use('mfussenegger/nvim-dap')
  use('rcarriga/nvim-dap-ui')
  use('theHamsta/nvim-dap-virtual-text')

  -- context menu keybindings
  use({ "folke/which-key.nvim" })

  -- todos and diagnostics
  use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
  use({ "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" })

  -- rust tools
  use({
    'saecki/crates.nvim',
    tag = 'v0.3.0',
    requires = { 'nvim-lua/plenary.nvim' },
  })
  -- use 'simrat39/rust-tools.nvim'

  use({ 'gbrlsnchs/telescope-lsp-handlers.nvim' })

  -- typescript
  -- use 'jose-elias-alvarez/typescript.nvim'

  -- postman/curl like tool
  use {
    "rest-nvim/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" }
  }

  -- better notifications
  use({
    "folke/noice.nvim",
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  })
end)
