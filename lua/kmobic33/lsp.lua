local M = {}

function M.get_capabilities()
  local cmp_nvim_lsp = require('cmp_nvim_lsp')
  local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

  return capabilities
end

function M.on_attach(_client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  local wk = require("which-key")

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
  vim.keymap.set("n", "<leader>vrr", "<cmd>Telescope lsp_references<cr>", opts)

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
      f = { "<cmd>Telescope diagnostics<cr>", "Telescope diagnostics" },
      -- show diagnostics at cursor/in project (in fuzzy finder)
      -- vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
      -- vim.keymap.set("n", "<leader>vsd", "<cmd>Telescope diagnostics<cr>", opts)
      i = { function()
        vim.lsp.buf.incoming_calls()
        require('litee.calltree').open_to()
      end, "Incoming calls" },
      o = {
        function()
          vim.lsp.buf.outgoing_calls()
          require('litee.calltree').open_to()
        end, "Outgoing calls" },
    },
  }, { prefix = "<leader>", opts })
end

return M
