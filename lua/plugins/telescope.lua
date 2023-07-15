local function grep_string_input()
  require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") });
end

return {
  {
    'gbrlsnchs/telescope-lsp-handlers.nvim',
    lazy = true,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = "Telescope",
    keys = {
      {
        '<C-p>',
        function() require('telescope.builtin').git_files() end,
        desc = "Look in git files"
      },
      {
        '<leader>pf',
        function() require('telescope.builtin').find_files() end,
        desc = "Telescope find files"
      },
      {
        '<leader>ps',
        grep_string_input,
        desc = "Telescope grep string with input"
      },
      {
        '<leader>pd',
        function() require('telescope.builtin').live_grep() end,
        desc = "Telescope live grep"
      },
      {
        '<leader>po',
        function() require('telescope.builtin').lsp_document_symbols() end,
        desc = "Telescope document symbols"
      },
      {
        '<leader>pi',
        function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
        desc = "Telescope dynamic workspace symbols"
      },
      {
        '<leader>pa',
        function() require('telescope.builtin').grep_string() end,
        desc = "Telescope grep string",
      },
      {
        '<leader>ph',
        function() require('telescope.builtin').help_tags() end,
        desc = "Telescope help tags"
      },
      {
        '<leader>pp',
        "<cmd>Telescope<cr>",
        desc = "Telescope introspection"
      },
      {
        '<leader>pr',
        "<cmd>Telescope harpoon marks<cr>",
        desc = "Telescope harpoon marks"
      },
      {
        '<c-f>',
        function() require('telescope.builtin').buffers() end,
        desc = "Telescope buffers"
      },
      {
        '<leader><tab>',
        function() require('telescope.builtin').commands() end,
        desc = "Telescope commands"
      },
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local wk = require("which-key")
      wk.register({
        p = {
          name = "Telescope",
        },
      }, { prefix = "<leader>" })

      local telescope = require('telescope')

      telescope.setup({
        extensions = {
          lsp_handlers = {
            disable = {
              ['callHierarchy/incomingCalls'] = true,
              ['callHierarchy/outgoingCalls'] = true,
            },
            location = {
              telescope = {},
              no_results_message = 'No references found',
            },
            symbol = {
              telescope = {},
              no_results_message = 'No symbols found',
            },
            call_hierarchy = {
              telescope = {},
              no_results_message = 'No calls found',
            },
            code_action = {
              telescope = require('telescope.themes').get_dropdown({}),
              no_results_message = 'No code actions available',
              prefix = '',
            },
          },
        },
      })

      telescope.load_extension('lsp_handlers')

      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      telescope.load_extension('fzf')

      telescope.load_extension('neoclip')
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    lazy = true
  },
}
