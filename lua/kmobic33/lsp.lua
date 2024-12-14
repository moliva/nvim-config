local M = {}

function M.get_capabilities()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- allow lsps to make folding dynamic folding possible
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
  }

  return capabilities
end

local cache = {}

---@diagnostic disable-next-line: unused-local
function M.on_attach(_client, bufnr)
  if cache[bufnr] then
    -- already attached!
    return
  end

  -- do not reexecute this function for this buffer in the future
  -- we almost always call on_attach multiple times (as copilot is enabled for every ft)
  cache[bufnr] = true

  local opts = { buffer = bufnr, remap = false }

  local wk = require("which-key")

  -- symbols
  vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<CR>", { desc = "Open symbols outline" })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)

  -- show next/prev error in file
  vim.keymap.set("n", "<a-.>", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<a-,>", vim.diagnostic.goto_prev, opts)
  -- vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  -- vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

  -- input a name/filter to look for a symbol in the workspaces

  -- lsp workspace folders management
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)

  wk.add({
    -- format
    -- TODO - table extend below for the opts + { desc } - moliva - 2024/02/06
    -- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format" })
    -- vim.keymap.set("n", "<leader>f", function()
    --   vim.lsp.buf.format({ async = true })
    -- end, opts)
    {
      "<leader>f",
      function()
        require("conform").format()
      end,
      desc = "Format file",
      unpack(opts),
    },

    -- go to
    { "g", group = "Go to", unpack(opts) },
    { "gd", vim.lsp.buf.definition, desc = "Go to definition", unpack(opts) },
    { "gi", vim.lsp.buf.type_definition, desc = "Go to implementation", unpack(opts) },
    { "gy", vim.lsp.buf.implementation, desc = "Go to type definition", unpack(opts) },

    -- "vim" lsp actions
    { "<leader>v", group = "Vim", unpack(opts) },
    { "<leader>vc", group = "Code", unpack(opts) },
    { "<leader>vca", vim.lsp.buf.code_action, desc = "Actions from LSP to the current line", unpack(opts) },
    { "<leader>vd", vim.diagnostic.open_float, desc = "Diagnostics float", unpack(opts) },
    { "<leader>vf", "<cmd>Telescope diagnostics<cr>", desc = "Telescope diagnostics", unpack(opts) },

    {
      "<leader>vrn",
      function()
        require("renamer").rename()
      end,
      desc = "Rename",
      unpack(opts),
    },
    { "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "List synmbols in the current workspace", unpack(opts) },
    { "<leader>vrr", "<cmd>Telescope lsp_references<cr>", desc = "References to current symbol", unpack(opts) },

    {
      "<leader>vi",
      function()
        vim.lsp.buf.incoming_calls()
        require("litee.calltree").open_to()
      end,
      desc = "Incoming calls",
      unpack(opts),
    },
    {
      "<leader>vo",
      function()
        vim.lsp.buf.outgoing_calls()
        require("litee.calltree").open_to()
      end,
      desc = "Outgoing calls",
      unpack(opts),
    },
  })
end

return M
