local current_file = os.getenv("HOME") .. "/.config/nvim/lua/kmobic33/debug.lua"
local inlay_file = os.getenv("HOME") .. "/.config/nvim/after/plugin/inlay-hints.lua"

vim.api.nvim_create_user_command('DebugReload', 'source ' .. current_file, {})
vim.api.nvim_create_user_command('DebugEdit', 'edit ' .. current_file, {})

vim.api.nvim_create_user_command('DebugReloadInlay', 'source ' .. inlay_file, {})

local function get_params(bufnr)
  ---@diagnostic disable-next-line: missing-parameter
  local params = vim.lsp.util.make_given_range_params()

  params["range"]["start"]["line"] = 0
  params["range"]["end"]["line"] = vim.api.nvim_buf_line_count(bufnr) - 1

  return params
end


vim.api.nvim_create_user_command('TList', function(opts)
  local buffer = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(buffer)
  -- local clients = vim.lsp.get_active_clients()

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  print("clients", vim.inspect(names))
end, {})

vim.api.nvim_create_user_command('Test', function(opts)
  -- print(vim.inspect(vim.lsp.get_active_clients()))
  -- local names = {}
  -- local clients = vim.lsp.get_active_clients()
  -- for _, client in ipairs(clients) do
  --   table.insert(names, client.name)
  -- end
  -- -- print("clients", vim.inspect(names))
  -- --
  -- local buffer = vim.api.nvim_get_current_buf()
  -- local params = get_params(buffer)
  -- print(vim.inspect(params))
  --
  -- local params_2 = {
  --   javascript = {
  --     inlayHints = {
  --       includeInlayEnumMemberValueHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --     },
  --   },
  --   typescript = {
  --     inlayHints = {
  --       includeInlayEnumMemberValueHints = true,
  --       includeInlayFunctionLikeReturnTypeHints = true,
  --       includeInlayFunctionParameterTypeHints = true,
  --       includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --       includeInlayPropertyDeclarationTypeHints = true,
  --       includeInlayVariableTypeHints = true,
  --     },
  --   },
  -- }
  --
  -- local cli = clients[1]
  -- cli.request("textDocument/inlayHint", params, function(err, result)
  --   -- cli.request("typescript/inlayHints", params, function(err, result)
  --   -- cli.request("$/typescriptVersion", params, function(err, result)
  --   -- cli.request("workspace/didChangeConfiguration", params_2, function(err, result)
  --   -- cli.request("initialize", params_2, function(err, result)
  --   if err then
  --     print('err', err)
  --     return
  --   end
  --
  --   print("result", vim.inspect(result))
local buffer = vim.api.nvim_get_current_buf()
-- print(buffer)

local clients = vim.lsp.buf_get_clients(buffer)
-- print(clients[1].name)
print(vim.inspect(clients[1].server_capabilities.inlayHintProvider))
  -- end)
end, {})







-- local buffer = vim.api.nvim_get_current_buf()
-- print(buffer)

-- local clients = vim.lsp.buf_get_clients(buffer)
-- print(clients[1].name)
-- print(vim.inspect(clients[1].server_capabilities.inlayHintProvider))
