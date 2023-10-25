return {
  -- theme & ui
  {
    'rose-pine/neovim',
    name = 'rose-pine',
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
  -- use('tpope/vim-repeat')

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

  -- typescript
  -- use 'jose-elias-alvarez/typescript.nvim'
}
