return {
  -- theme & ui
  {
    'rose-pine/neovim',
    name = 'rose-pine',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons", 'RRethy/nvim-base16' }
  },
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
  {
    "AckslD/nvim-neoclip.lua",
    -- TODO - review this - moliva - 2023/05/29
    lazy = true,
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
