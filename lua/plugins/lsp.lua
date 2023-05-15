M = {}

local function local_attach(_client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- symbols
  -- vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<CR>")

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)

  -- show next/prev error in file
  vim.keymap.set("n", "<a-.>", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<a-,>", vim.diagnostic.goto_prev, opts)
  -- vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  -- vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

  -- input a name/filter to look for a symbol in the workspaces
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  -- vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  -- vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrr", "<cmd>Telescope lsp_references<cr>", opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)

  -- lsp workspace folders management
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)

  vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
  -- vim.keymap.set("n", "<leader>f", function()
  --   vim.lsp.buf.format({ async = true })
  -- end, opts)

  local wk = require("which-key")
  wk.register({
    g = {
      name = "Go to",
      d = { vim.lsp.buf.definition, "Go to definition" },
      y = { vim.lsp.buf.type_definition, "Go to type definition" },
      i = { vim.lsp.buf.implementation, "Go to implementation" }
    },
  })

  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  -- vim.keymap.set("n", "gy",  opts)
  -- vim.keymap.set("n", "gi", opts)
  wk.register({
    v = {
      name = "Vim",
      c = {
        name = "Code",
        a = { vim.lsp.buf.code_action, "Actions from LSP to the current line" }
      },
      d = { vim.diagnostic.open_float, "Diagnostics float" },
      -- s = {
      -- name = "SSSS",
      -- d = { "<cmd>Telescope diagnostics<cr>", "Telescope diagnostics" }
      -- }
      f = { "<cmd>Telescope diagnostics<cr>", "Telescope diagnostics" }
      -- show diagnostics at cursor/in project (in fuzzy finder)
      -- vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
      -- vim.keymap.set("n", "<leader>vsd", "<cmd>Telescope diagnostics<cr>", opts)
    },
  }, { prefix = "<leader>" })
end

return {

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' }, { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' }, -- Snippets
      { 'L3MON4D3/LuaSnip' }, { 'rafamadriz/friendly-snippets' },
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
    cmd = {'LspInfo', 'Mason'},
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
        local_attach(c, b)
        require("inlay-hints").on_attach(c, b)
      end

      lsp.on_attach(on_attach)

      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())


      -- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      local lspconfig = require('lspconfig')

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` and other globals
              -- globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins" },
            },
            completion = { callSnippet = "Both" },
            telemetry = { enable = false },
            -- workspace = {
            --   -- Make the server aware of Neovim runtime files
            --   -- library = vim.api.nvim_get_runtime_file("lua", true),
            --   library = vim.api.nvim_get_runtime_file("", true),
            -- },
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

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        cmd = {
          "rustup", "run", "stable", "rust-analyzer"
          -- "ra-multiplex", "--ra-mux-server", "/Users/moliva/.rustup/toolchains/stable-x86_64-apple-darwin/bin/rust-analyzer"
        },
        settings = {
          ['rust-analyzer'] = {
            -- server = {
            --   path = '/Users/moliva/.cargo/bin/ra-multiplex'
            -- },
            -- enable clippy on save
            -- checkOnSave = {
            --   command = "clippy",
            -- },
            check = {
              command = "clippy",
            },
            diagnostics = {
              enable = true,
              disabled = { "unresolved-proc-macro" },
              enableExperimental = true,
            },
            inlayHints = {
              bindingModeHints = {
                enable = true
              },
              chainingHints = {
                enable = true
              },
              closingBraceHints = {
                enable = true
              },
              closureReturnTypeHints = {
                enable = true
              },
            }
          }
          -- rust-analyzer.inlayHints.bindingModeHints.enable (default: false)
          -- Whether to show inlay type hints for binding modes.
          --
          -- rust-analyzer.inlayHints.chainingHints.enable (default: true)
          -- Whether to show inlay type hints for method chains.
          --
          -- rust-analyzer.inlayHints.closingBraceHints.enable (default: true)
          -- Whether to show inlay hints after a closing } to indicate what item it belongs to.
          --
          -- rust-analyzer.inlayHints.closingBraceHints.minLines (default: 25)
          -- Minimum number of lines required before the } until the hint is shown (set to 0 or 1 to always show them).
          --
          -- rust-analyzer.inlayHints.closureReturnTypeHints.enable (default: "never")
          -- Whether to show inlay type hints for return types of closures.
          --
          -- rust-analyzer.inlayHints.closureStyle (default: "impl_fn")
          -- Closure notation in type and chaining inaly hints.
          --
          -- rust-analyzer.inlayHints.discriminantHints.enable (default: "never")
          -- Whether to show enum variant discriminant hints.
          --
          -- rust-analyzer.inlayHints.expressionAdjustmentHints.enable (default: "never")
          -- Whether to show inlay hints for type adjustments.
          --
          -- rust-analyzer.inlayHints.expressionAdjustmentHints.hideOutsideUnsafe (default: false)
          -- Whether to hide inlay hints for type adjustments outside of unsafe blocks.
          --
          -- rust-analyzer.inlayHints.expressionAdjustmentHints.mode (default: "prefix")
          -- Whether to show inlay hints as postfix ops (. instead of , etc).
          --
          -- rust-analyzer.inlayHints.lifetimeElisionHints.enable (default: "never")
          -- Whether to show inlay type hints for elided lifetimes in function signatures.
          --
          -- rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames (default: false)
          -- Whether to prefer using parameter names as the name for elided lifetime hints if possible.
          --
          -- rust-analyzer.inlayHints.maxLength (default: 25)
          -- Maximum length for inlay hints. Set to null to have an unlimited length.
          --
          -- rust-analyzer.inlayHints.parameterHints.enable (default: true)
          -- Whether to show function parameter name inlay hints at the call site.
          --
          -- rust-analyzer.inlayHints.reborrowHints.enable (default: "never")
          -- Whether to show inlay hints for compiler inserted reborrows. This setting is deprecated in favor of rust-analyzer.inlayHints.expressionAdjustmentHints.enable.
          --
          -- rust-analyzer.inlayHints.renderColons (default: true)
          -- Whether to render leading colons for type hints, and trailing colons for parameter hints.
          --
          -- rust-analyzer.inlayHints.typeHints.enable (default: true)
          -- Whether to show inlay type hints for variables.
          --
          -- rust-analyzer.inlayHints.typeHints.hideClosureInitialization (default: false)
          -- Whether to hide inlay type hints for let statements that initialize to a closure. Only applies to closures with blocks, same as rust-analyzer.inlayHints.closureReturnTypeHints.enable.
          --
          -- rust-analyzer.inlayHints.typeHints.hideNamedConstructor (default: false)
          -- Whether to hide inlay type hints for constructors.
        }
      })

      lsp.setup()

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

      -- shortcut to source my luasnips file again, which will reload muy snippets
      vim.keymap.set("n", "<leader><leader>s", "<cmd>source /Users/moliva/.config/nvim/after/plugin/luasnip.lua<CR>")






      local s = ls.snippet
      -- local sn = ls.snippet_node
      -- local isn = ls.indent_snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      -- local f = ls.function_node
      local c = ls.choice_node
      -- local d = ls.dynamic_node
      -- local r = ls.restore_node

      -- local events = require("luasnip.util.events")
      -- local ai = require("luasnip.nodes.absolute_indexer")

      local extras = require("luasnip.extras")
      -- local l = extras.lambda
      -- local rep = extras.rep -- repeats the content of the `number` insert node referenced
      -- local p = extras.partial
      -- local m = extras.match
      -- local n = extras.nonempty
      -- local dl = extras.dynamic_lambda

      local fmt = require("luasnip.extras.fmt").fmt
      -- local fmta = require("luasnip.extras.fmt").fmta
      -- local conds = require("luasnip.extras.expand_conditions")
      -- local postfix = require("luasnip.extras.postfix").postfix
      -- local types = require("luasnip.util.types")
      local parse = require("luasnip.util.parser").parse_snippet

      -- cleans up all snippets (useful when reloading this file)
      ls.cleanup()

      ls.add_snippets("all", {
        parse("todo",
          "$LINE_COMMENT ${1|TODO,FIXME,XXX|} - ${2:description} - moliva - $CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DATE"),
        -- s("todo1", fmt("{} {} - {} - moliva - {}", { t("//"), c(1, { t("TODO"), t("FIXME"), t("XXX") }), i(2, "description"), f(function()
        --   return
        --       os.date("%Y/%m/%d")
        -- end) })),
      })

      ls.add_snippets("rust", {
        s("modtest",
          fmt(
            [[
            #[cfg(test)]
            mod test {{
            {}

              {}
            }}
   ]],
            {
              c(1, { t("  use super::*;", t("")) }),
              i(0)
            }))
      })

      ls.add_snippets("text", {
        s("meeting", fmt("**** {} ****\n{}", { i(1, "meeting name"), i(0) })),
        s("newmeetingsfile", fmt(
          [[

    {}


    ****************************************************************************************************************
    ********************* Action items *********************
    ****************************************************************************************************************



    EOF
    ]], { i(0) })),
        parse("today", "$CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DATE"),
        s("sep", fmt(
          [[
    ****************************************************************************************************************
    ********************* {} *********************
    ****************************************************************************************************************
    ]], { i(0) })),
      })
    end
  }
}
