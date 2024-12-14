local M = {}

---Helper function to find the context node given a start node for different languages
---Returns the context node found, the language and the kind of node found (TS query)
---@param node TSNode
---@return TSNode | nil, string, string
local function find_context_node(node)
  local langs = {
    json = {
      nodes = {
        object = [[
[
  (object _ @context)
]
        ]],
        document = [[
[
  (document _ @context)
]
        ]],
      },
    },
    java = {
      nodes = {
        constructor_declaration = [[
[
  (constructor_declaration
     name: (_) @identifier
  )
]
        ]],
        interface_declaration = [[
[
  (interface_declaration
     name: (_) @identifier
  )
]
        ]],
        lambda_expression = [[
[
  (lambda_expression _ @context)
]
        ]],
        class_declaration = [[
[
  (class_declaration
     name: (_) @identifier
  )
]
        ]],
        method_declaration = [[
[
  (method_declaration
     name: (_) @identifier
  )
]
        ]],
      },
    },
    rust = {
      nodes = {
        mod_item = [[
[
  (mod_item
  )
     _ @context
]
        ]],
        macro_invocation = [[
[
  (macro_invocation _ @context
  )
]
        ]],
        macro_definition = [[
[
  (macro_definition
     name: (_) @identifier
  )
]
        ]],
        block = [[
[
  (block _ @context)
]
        ]],
        impl_item = [[
[
  (impl_item
     type: (_) @identifier
  )
]
        ]],
        function_item = [[
[
  (function_item
     name: (_) @identifier
  )
]
        ]],
      },
    },
    lua = {
      nodes = {
        function_declaration = [[
[
  (function_declaration
     name: (_) @identifier
  )
]
        ]],
        -- TODO - rethink this , add a way to use "high level" contexts only (e.g. functions) - moliva - 2024/06/04
        table_constructor = [[
        [
          (table_constructor _ @context)
        ]
        ]],
        function_definition = [[
[
  (function_definition _ @context)
]
]],
      },
    },
    tsx = {
      nodes = {
        function_declaration = [[
[
  (function_declaration name: (_) @identifier)
]
        ]],
        function_expression = [[
[
  (function_expression name: (_) @identifier)
]
 ]],
        arrow_function = [[
[
  (arrow_function _ @identifier)
]
        ]],
      },
    },
    typescript = {
      nodes = {
        method_definition = [[
[
  (method_definition name: (_) @identifier)
]
        ]],
        function_declaration = [[
[
  (function_declaration name: (_) @identifier)
]
        ]],
        function_expression = [[
[
  (function_expression name: (_) @identifier)
]
 ]],
        arrow_function = [[
[
  (arrow_function _ @identifier)
]
        ]],
      },
    },
  }

  local file_type = vim.treesitter.get_parser():lang()
  local lang = langs[file_type]
  if not lang then
    vim.notify("Not supported language '" .. file_type .. "'")
    return
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

    return
  end

  return node, file_type, kind
end

---Select the current code context visually
local function visual_select_context()
  local start = vim.treesitter.get_node()
  local node = find_context_node(start)
  if not node then
    return
  end

  local row, column, _ = node:start()
  vim.api.nvim_win_set_cursor(0, { row + 1, column })

  row, column, _ = node:end_()

  local column_cmd
  if column == 0 or column == 1 then
    column_cmd = "0"
  else
    column_cmd = "0" .. column - 1 .. "l"
  end

  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<esc>v" .. row + 1 .. "gg" .. column_cmd .. "o", true, false, true),
    "x",
    true
  )
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

    -- visual selection
    { "vc", visual_select_context, desc = "Visually select the current context", unpack(opts) },

    -- go to
    { "g", group = "Go to", unpack(opts) },
    { "gd", vim.lsp.buf.definition, desc = "Go to definition", unpack(opts) },
    { "gi", vim.lsp.buf.type_definition, desc = "Go to implementation", unpack(opts) },
    { "gy", vim.lsp.buf.implementation, desc = "Go to type definition", unpack(opts) },
    { "ga", go_to_current_declaration, desc = "Go to current function signature/definition", unpack(opts) },

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
