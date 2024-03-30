return {
  -- call tree to be used by lsp zero
  {
    'ldelossa/litee-calltree.nvim',
    dependencies = 'ldelossa/litee.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- configure the litee.nvim library
      require('litee.lib').setup({})
      -- configure litee-calltree.nvim
      require('litee.calltree').setup({})
    end
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' }, { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' }, -- Snippets
      { 'hrsh7th/cmp-cmdline' },
      { 'L3MON4D3/LuaSnip',    version = "v2.*" }, { 'rafamadriz/friendly-snippets' },
      { "onsails/lspkind.nvim" },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require('lsp-zero.cmp').extend()

      local lsp = require('lsp-zero')

      -- -- And you can configure cmp even more, if you want to.
      -- local cmp = require('cmp')
      -- local cmp_action = require('lsp-zero.cmp').action()
      --
      -- cmp.setup({
      --   mapping = {
      --     ['<C-Space>'] = cmp.mapping.complete(),
      --     ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      --     ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      --   }
      -- })

      local cmp = require('cmp')
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Cr>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
      })

      -- / cmdline setup
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- : cmdline setup
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })

      local sources = lsp.defaults.cmp_sources()

      local utils = require('kmobic33.utils')
      local text_sources = utils.copy_table(sources)

      local index = utils.find_index(function(_, v) return v['name'] == 'buffer' end, sources)

      if index ~= nil then
        sources[index] = { name = 'buffer', keyword_length = 5 }
        table.remove(text_sources, index)
      end

      local lspkind = require('lspkind')

      -- lsp.setup_nvim_cmp({
      --   mapping = cmp_mappings,
      --   experimental = {
      --     ghost_text = true,
      --   },
      --   sources = sources,
      --   formatting = {
      --     format = lspkind.cmp_format(),
      --   },
      -- })
      cmp.setup({
        mapping = cmp_mappings,
        experimental = {
          ghost_text = true,
        },
        sources = sources,
        formatting = {
          format = lspkind.cmp_format(),
        },
      })

      require("cmp").setup.filetype('text', {
        sources = cmp.config.sources(text_sources)
      })
    end
  },

  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    cmd = { 'LspInfo', 'Mason' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        build = function() pcall(vim.cmd, 'MasonUpdate') end,
      },
    },
    config = function()
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      -- require("neodev").setup({
      --   -- add any options here, or leave empty to use the default settings
      -- })

      -- XXX - lsp-zero + lspconfig living together to avoid cycle dependencies - moliva - 2023/05/15
      local lsp = require('lsp-zero').preset('recommended')

      -- This is where all the LSP shenanigans will live

      vim.diagnostic.config({
        -- shows errors in line
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      lsp.ensure_installed({
        'tsserver',
        'eslint',
        'lua_ls',
        'rust_analyzer',
      })

      local on_attach = function(c, b)
        -- require('lsp_mappings').on_attach(c, b)
        require("kmobic33.lsp").on_attach(c, b)
        require("inlay-hints").on_attach(c, b)
      end

      lsp.on_attach(on_attach)

      local capabilities = require("kmobic33.lsp").get_capabilities()

      local lspconfig = require('lspconfig')

      lspconfig.csharp_ls.setup({})

      lspconfig["solidity"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
        filetypes = { "solidity" },
        root_dir = lspconfig.util.root_pattern(".prettierrc"),
        single_file_support = true,
      })

      -- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
              -- Get the language server to recognize the `vim` and other globals
              -- globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins" },
            },
            -- completion = { callSnippet = "Both" },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
            workspace = {
              -- checkThirdParty = false,
              -- Make the server aware of Neovim runtime files
              -- library = vim.api.nvim_get_runtime_file("lua", true),
              library = {
                "${3rd}/luv/library",
                unpack(vim.api.nvim_get_runtime_file("", true)),
              }
            },
            hint = {
              enable = true,
            },
          }
        }
      })

      lspconfig.tsserver.setup({
        capabilities = capabilities,
        -- need to install previously:
        -- $ npm install -g typescript-language-server typescript
        -- cmd = { "typescript-language-server", "--stdio" },
        -- disable_formatting = true,
        settings = {
          javascript = {
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
          typescript = {
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      })

      require 'lspconfig'.cssls.setup({})

      require 'lspconfig'.cssmodules_ls.setup({
        init_options = {
          camelCase = 'dashes',
        },
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        init_options = {
          provideFormatter = true
        },
        settings = {
          json = {
            format = "enable",
          }
        }
      })

      lsp.skip_server_setup({ 'rust_analyzer' })

      lsp.setup()

      require("ufo")

      -- LUasnip config

      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      ls.config.set_config({
        -- remembers last snippet to jump back into it if you moved out accidentally
        history = true,
        -- dynamic snippets updates
        updateevents = "TextChanged,TextChangedI",
        -- check if auto snippets are good
        enable_autosnippets = true,
        -- more
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "<- Current Choice", "Error" } },
            }
          }
        }
      })

      -- c-k expansion key
      -- this will expand the current item or jump to the next item within the snippet
      --vim.keymap.set({ "i", "s" }, "<c-k>", function()
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      -- TODO - these 2 are conflicting right!

      -- c-j jumps backwards
      -- moves to the previous item within the snippet
      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      -- c-l changes choice in current snippet insert node
      -- useful for choice nodes
      vim.keymap.set({ "i", "s" }, "<c-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-h>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end)

      -- TODO - review this - moliva - 2024/03/09
      -- shortcut to source my luasnips file again, which will reload muy snippets
      -- vim.keymap.set("n", "<leader><leader>s", "<cmd>source /Users/moliva/.config/nvim/after/plugin/luasnip.lua<CR>")

      require("kmobic33.snippets").configure_snippets(ls)
    end
  }
}
