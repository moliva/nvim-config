

---@diagnostic disable-next-line: unused-local
M.on_attach = function(_client, bufnr)
  print("LSSLSLSLSLSLSLSLS")
  local opts = { buffer = bufnr, remap = false }

  -- symbols
  vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<CR>")

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

return M
