vim.g.mapleader = " "
-- explore command for netrw
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Explore current dir" })

-- move things around highlighted in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<A-w>", "<cmd>%bd|e#<cr>", { desc = "Close all buffers but this one" })
-- vim.keymap.set("n", "<A-Q>", "<cmd>bufdo bwipeout<cr>", { desc = "Close all buffers"})
vim.keymap.set("n", "<A-Q>", "<cmd>1,$bd!<cr>", { desc = "Close all buffers" })

-- vim.keymap.set("n", "<leader>vwm", require("vim_with_me").StartVimWithMe)
-- vim.keymap.set("n", "<leader>svwm", require("vim_with_me").StopVimWithMe)

-- greatest remap ever (?
-- allows you to visual highlight text and paste over without replacing the buffer
vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete into an anonymous buffer" })

-- TODO - reimplement this using treesitter instead to be able to copy also derives in rust and annotations in other langs - moliva - 2024/03/11
-- copy everything between { and } including the lines
vim.keymap.set("n", "YY", "va{Vy}")

-- TODO - remove wrapping () {} [] plus the function name (function call) - moliva - 2024/03/04
-- eg Some(saraza) -> saraza
-- try with treesitter

-- TODO - delete/select/yank until _ - moliva - 2024/03/05
-- TODO - delete/select/yank until next capitalized letter - moliva - 2024/03/05
-- TODO - go to the function declaration (when inside that function) - moliva - 2024/03/05
-- TODO - delete between parenthesis or , and parenthesis (function call) - moliva - 2024/03/08
-- TODO - cmd+shift+s => save all buffers - moliva - 2024/03/09
-- TODO - close all other buffers (not in a visible window) - moliva - 2024/03/13
-- TODO - move window to focus in the high end for meetings - moliva - 2024/03/16
-- TODO - open nvim files from anywhere - moliva - 2024/03/20
-- TODO - select all html/xml elemtn (with children) - moliva - 2024/03/20

-- TODO - go to plugin config - moliva - 2024/04/11

vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
-- vim.keymap.set("n", "<c-h>", "<c-w>h")
-- vim.keymap.set("n", "<c-l>", "<c-w>l")

-- next greatest remap ever
-- yank to the system clipboard!
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

vim.keymap.set("n", "<leader>Y", '"+Y')

-- control c acts as escape in visual edit mode
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- changes to another tmux session
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- substitute the current visual selection in the entire buffer
vim.keymap.set("n", "<leader><leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
-- substitute the current visual selection in the line
vim.keymap.set("n", "<leader>s", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- set execution permissions to the current file
vim.keymap.set("n", "<leader><leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- save on control s, control q for quitting and control x for quit/saving
local modes = { "n", "i", "v" }
vim.keymap.set(modes, "<a-S>", "<cmd>w<CR>")
-- vim.keymap.set(modes, "<C-x>", "<cmd>x<CR>")
vim.keymap.set(modes, "<C-q>", "<cmd>q<CR>")

-- alternate file!
vim.keymap.set(modes, "<a-a>", "<cmd>e #<cr>")

-- vim.keymap.set(modes, "<C-q>q", "<cmd>qa!<CR>")
-- vim.keymap.set(modes, "<C-x>x", "<cmd>xa!<CR>")

-- remap splits to the ones used in tmux
vim.keymap.set("n", "<C-w>\\", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<C-w>-", "<cmd>split<CR>")

-- split current tab into two
-- not used anymore with barbar
-- vim.keymap.set("n", "<C-w>t", "<cmd>tab split<CR>")

-- clear highlighted search
vim.keymap.set("n", "<leader>,", "<cmd>set hlsearch! hlsearch?<CR>")

-- move line up or down
vim.keymap.set({ "n", "i", "v" }, "<a-k>", "<cmd>m .-2<cr>")
vim.keymap.set({ "n", "i", "v" }, "<a-j>", "<cmd>m .+1<cr>")

--- @param name string
--- @return boolean
local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

vim.keymap.set("n", "gr", function()
  local cwd = vim.fn.getcwd()
  local file
  if file_exists(cwd .. "/README.md") then
    file = cwd .. "README.md"
  end

  if file then
    vim.cmd("e " .. file)
  end
end, { desc = "Go to README" })

--- @param path string
function parent_dir(path)
  local index = string.find(path, "/[^/]*$")
  return string.sub(path, 0, index - 1)
end

vim.keymap.set(
  "n",
  "gp",
  function()
    local file_path = vim.fn.expand("%")

    local base_path = parent_dir(file_path)
    if not string.match(base_path, "^.?/") then
      base_path = "./" .. base_path
    end

    local file

    while file == nil do
      if file_exists(base_path .. "/package.json") then
        file = base_path .. "/package.json"
      elseif file_exists(base_path .. "/Cargo.toml") then
        file = base_path .. "/Cargo.toml"
      elseif file_exists(base_path .. "/go.mod") then
        file = base_path .. "/go.mod"
      elseif file_exists(base_path .. "/pom.xml") then
        file = base_path .. "/pom.xml"
      end

      if file == file_path then
        file = nil
      end

      if file == nil then
        base_path = parent_dir(base_path)
      end
    end

    if file then
      vim.cmd("e " .. file)
    end
  end,
  { desc = "Looks up for the project description file (e.g. package.json, Cargo.toml) from the current path upwards" }
)

vim.keymap.set("n", "gP", function()
  local cwd = vim.fn.getcwd()
  local file
  if file_exists(cwd .. "/package.json") then
    file = cwd .. "/package.json"
  elseif file_exists(cwd .. "/Cargo.toml") then
    file = cwd .. "/Cargo.toml"
  elseif file_exists(cwd .. "/go.mod") then
    file = cwd .. "/go.mod"
  elseif file_exists(cwd .. "/pom.xml") then
    file = cwd .. "/pom.xml"
  end

  if file then
    vim.cmd("e " .. file)
  end
end, { desc = "Open project description file at cwd (e.g. package.json, Cargo.toml)" })

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

-- multi lang enviroment
vim.keymap.set("n", "ga", go_to_current_declaration, { desc = "Go to current function signature/definition" })
vim.keymap.set("n", "vc", visual_select_context, { desc = "Visually select the current context" })

-- rust environment
local function rust_keymaps()
  vim.keymap.set(
    "n",
    "<leader>vcd",
    "<cmd>%s/\\<dbg\\!(\\(.*\\))/\\1/g<cr>",
    { desc = "Remove all dbg!() statements in the file" }
  )

  vim.keymap.set("n", "<leader>vcl", "<cmd>!just lint<cr>", { desc = "Run just lint" })
end
rust_keymaps()

-- go environment
local function go_keymaps()
  vim.keymap.set("n", "<leader>vct", "<cmd>!go mod tidy<cr>", { desc = "Go mod tidy" })
end
go_keymaps()

vim.keymap.set(
  "n",
  "<leader>l",
  "<cmd>LspRestart<cr><cmd>lua vim.print('LSPs restarted')<cr>",
  { desc = "Restart LSPs" }
)

vim.keymap.set(
  "n",
  "<leader>vs",
  "<cmd>source %<cr><cmd>lua vim.print('Reloaded '.. vim.fn.expand('%'))<cr>",
  { desc = "Source the current file" }
)

vim.keymap.set("n", "<leader>gu", "<cmd>!gpull<cr>", { desc = "Git pull" })
-- vim.keymap.set("n", "<leader>gq", "<cmd>Git checkout <cr>", { desc = "Git pull" })
-- vim.fn.input("Grep > ")
