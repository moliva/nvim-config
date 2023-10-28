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
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    lazy = true,
    keys = {
      --   -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      { 'zR', function() require('ufo').openAllFolds() end,  desc = "Open all folds" },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = "Close all folds" },
      {
        'zK',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold"
      },
    },
    config = function()
      require('lsp-zero')
      require('ufo').setup({
        provider_selector = function(_, _, _)
          return { 'lsp', 'indent' }
        end
      })
    end
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
