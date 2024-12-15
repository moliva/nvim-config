local M = {}

---Helper function to find the context node given a start node and different language contexts
---Returns the context node found, the language and the kind of node found (TS query)
---@param node TSNode
---@return TSNode | nil, string | nil, string | nil
local function find_node(node, langs)
  local file_type = vim.treesitter.get_parser():lang()
  local lang = langs[file_type]
  if not lang then
    vim.notify("Not supported language '" .. file_type .. "'")
    return nil, nil, nil
  end

  local kind = nil
  while node ~= nil do
    kind = lang.nodes[node:type()]
    if kind ~= nil then
      break
    end

    node = node:parent()
  end

  if not node then
    vim.notify("Not inside a known context")

    return nil, nil, nil
  end

  return node, file_type, kind
end

---Helper function to find the context node given a start node for different languages
---Returns the context node found, the language and the kind of node found (TS query)
---@param node TSNode
---@return TSNode | nil, string | nil, string | nil
local function find_context_node(node)
  local langs = require("kmobic33.lsp.contexts")

  return find_node(node, langs)
end

---Visually select a range from start row and column to end row and column
---Conditionally delete the range if delete is true
---@param start_row number
---@param start_column number
---@param end_row number
---@param end_column number
---@param delete boolean|nil
local function visually_select_range(start_row, start_column, end_row, end_column, delete)
  -- set cursor at the start
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_column })

  local column_cmd
  if end_column == 0 or end_column == 1 then
    column_cmd = "0"
  else
    column_cmd = "0" .. end_column - 1 .. "l"
  end

  local delete_cmd = delete and "d" or ""

  -- select the range
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(
      "<esc>v" .. end_row + 1 .. "gg" .. column_cmd .. "o" .. delete_cmd,
      true,
      false,
      true
    ),
    "x",
    true
  )
end

---Delete the surrounding function call to a list of arguments leaving the arguments alone
local function delete_surrounding_call()
  local start = vim.treesitter.get_node()
  local langs = require("kmobic33.lsp.calls")
  local node, lang, kind = find_node(start, langs)

  if not node then
    return
  end

  local query = vim.treesitter.query.parse(lang, kind)
  local iter = query:iter_captures(node, 0)
  local _, each, _ = iter()

  local row, column, _ = each:end_()
  local row2, column2, _ = node:end_()

  -- TODO(miguel): check that this works for other langs other than lua function call - 2024/12/15
  -- might need to +1 the column
  visually_select_range(row, column - 1, row2, column2, true)

  row, column, _ = node:start()
  row2, column2, _ = each:start()

  -- TODO(miguel): check that this works for other langs other than lua function call - 2024/12/15
  -- might need to -1 the column
  visually_select_range(row, column, row2, column2 + 1, true)
end

---Delete the current function call with all its arguments
local function delete_call()
  local start = vim.treesitter.get_node()
  local langs = require("kmobic33.lsp.calls")
  local node = find_node(start, langs)

  if not node then
    return
  end

  local row, column, _ = node:start()
  local row2, column2, _ = node:end_()

  visually_select_range(row, column, row2, column2, true)
end

---Select the current code context visually
local function visual_select_context()
  local start = vim.treesitter.get_node()
  local node = find_context_node(start)
  if not node then
    return
  end

  local row, column, _ = node:start()
  local end_row, end_column, _ = node:end_()

  visually_select_range(row, column, end_row, end_column)
end

---Go to the current code body declaration
local function go_to_current_declaration()
  local start = vim.treesitter.get_node():parent()
  local node, lang, kind = find_context_node(start)
  if not node then
    return
  end

  local query = vim.treesitter.query.parse(lang, kind)
  local iter = query:iter_captures(node, 0)
  local _, each, _ = iter()
  local row, column, _ = each:start()

  vim.api.nvim_win_set_cursor(0, { row + 1, column })
end

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
  vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<CR>", { desc = "Open symbols outline", unpack(opts) })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)

  -- show next/prev error in file
  vim.keymap.set("n", "<a-.>", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<a-,>", vim.diagnostic.goto_prev, opts)
  -- vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  -- vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

  -- NOTE(miguel): not sure its worth it, since i'm usign Trouble - 2024/12/14
  -- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set loclist with diagnostics", unpack(opts) })

  -- input a name/filter to look for a symbol in the workspaces

  -- lsp workspace folders management
  vim.keymap.set(
    "n",
    "<leader>wa",
    vim.lsp.buf.add_workspace_folder,
    { desc = "Add folder to workspace", unpack(opts) }
  )
  vim.keymap.set(
    "n",
    "<leader>wr",
    vim.lsp.buf.remove_workspace_folder,
    { desc = "Remove folder from workspace", unpack(opts) }
  )
  vim.keymap.set("n", "<leader>wl", function()
    vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List current workspace folders", unpack(opts) })

  wk.add({
    -- lsp workspace
    { "<leader>w", group = "LSP workspaces", unpack(opts) },

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

    -- visual selection
    { "vc", visual_select_context, desc = "Visually select the current context", unpack(opts) },

    -- delete function calls
    { "dc", delete_call, desc = "Delete function call", unpack(opts) },
    { "dsc", delete_surrounding_call, desc = "Delete surrounding function call", unpack(opts) },

    -- go to
    { "g", group = "Go to", unpack(opts) },
    { "gd", vim.lsp.buf.definition, desc = "Go to definition", unpack(opts) },
    { "gi", vim.lsp.buf.type_definition, desc = "Go to implementation", unpack(opts) },
    { "gy", vim.lsp.buf.implementation, desc = "Go to type definition", unpack(opts) },
    { "ga", go_to_current_declaration, desc = "Go to current function signature/definition", unpack(opts) },

    -- "vim" lsp actions
    { "<leader>v", group = "Vim", unpack(opts) },
    { "<leader>vc", group = "Code", unpack(opts) },
    { "<leader>vca", vim.lsp.buf.code_action, desc = "Actions from LSP", unpack(opts) },
    -- { "<leader>vd", vim.diagnostic.open_float, desc = "Diagnostics float", unpack(opts) },

    -- Telescope
    { "<leader>px", "<cmd>Telescope diagnostics<cr>", desc = "Telescope diagnostics", unpack(opts) },

    {
      "<leader>vrn",
      function()
        require("renamer").rename()
      end,
      desc = "Rename",
      unpack(opts),
    },
    { "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "List symbols in the current workspace", unpack(opts) },
    -- NOTE(miguel): gr works the same way - 2024/12/15
    -- { "<leader>vrr", "<cmd>Telescope lsp_references<cr>", desc = "References to current symbol", unpack(opts) },

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
