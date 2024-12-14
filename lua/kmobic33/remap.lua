vim.g.mapleader = " "

local u = require("kmobic33.utils")

-- move things around highlighted in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- move line up or down
vim.keymap.set({ "n", "i", "v" }, "<a-k>", "<cmd>m .-2<cr>")
vim.keymap.set({ "n", "i", "v" }, "<a-j>", "<cmd>m .+1<cr>")

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

-- TODO - go to plugin config - moliva - 2024/04/11

-- window movement
-- vim.keymap.set("n", "<c-j>", "<c-w>j")
-- vim.keymap.set("n", "<c-k>", "<c-w>k")
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

-- quickfix + location list movement
vim.keymap.set("n", "<leader>q", u.toggle_quickfix, { desc = "Quickfix toggle" })
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Quickfix next" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Quickfix previous" })

-- TODO(miguel): not sure this works as i intend it - 2024/12/14
vim.keymap.set("n", "<leader>l", u.toggle_locationlist, { desc = "Location list toggle" })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = "Location list next" })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = "Location list previous" })

-- substitute the current visual selection in the entire buffer
vim.keymap.set(
  "n",
  "<leader><leader>s",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Substitute current word for another in the entire buffer" }
)
vim.keymap.set(
  "v",
  "<leader><leader>s",
  'y:%s/<C-r>"/<C-r>"/g<Left><Left>',
  { desc = "Substitute current selection for another in the entire buffer" }
)

-- substitute the current visual selection in the line
vim.keymap.set(
  "n",
  "<leader>s",
  ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Substitute current word for another in the line" }
)
vim.keymap.set(
  "v",
  "<leader>s",
  'y:s/<C-r>"/<C-r>"/g<Left><Left>',
  { desc = "Substitute current selection for another in the line" }
)

-- set execution permissions to the current file
vim.keymap.set(
  "n",
  "<leader><leader>x",
  "<cmd>!chmod +x %<CR>",
  { desc = "Make current file executable", silent = true }
)

-- save on control s, control q for quitting and control x for quit/saving
local modes = { "n", "i", "v" }
vim.keymap.set(modes, "<a-S>", "<cmd>w<CR>")
-- vim.keymap.set(modes, "<C-x>", "<cmd>x<CR>")
vim.keymap.set(modes, "<C-q>", "<cmd>q<CR>")

-- alternate buffer!
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
vim.keymap.set("n", "<leader>,", "<cmd>set hlsearch! hlsearch?<CR>", { desc = "Toggle search highlight" })

-- go to
vim.keymap.set("n", "gr", function()
  local cwd = vim.fn.getcwd()
  local file
  if u.file_exists(cwd .. "/README.md") then
    file = cwd .. "README.md"
  end

  if file then
    vim.cmd("e " .. file)
  end
end, { desc = "Go to README" })

-- find the project description file (e.g. package.json, Cargo.toml) from the current path upwards
vim.keymap.set(
  "n",
  "gp",
  u.edit_project_description_file_from_current_file,
  { desc = "Looks up for the project description file (e.g. package.json, Cargo.toml) from the current path upwards" }
)

-- find the project description file (e.g. package.json, Cargo.toml) at the root of the cwd
vim.keymap.set(
  "n",
  "gP",
  u.edit_project_description_file_in_cwd,
  { desc = "Open project description file at cwd (e.g. package.json, Cargo.toml)" }
)

-- local wk = require("which-key")

-- source code + lsp restart
-- wk.add({
--   { "<leader><leader>r", group = "Source code" },
-- })
vim.keymap.set("n", "<leader><leader>rf", "<cmd>source %<cr><cmd>lua vim.notify('Sourced '.. vim.fn.expand('%'))<cr>")
vim.keymap.set("n", "<leader><leader>rs", ":.lua<cr><cmd>lua vim.notify('Sourced lines')<cr>")
vim.keymap.set("v", "<leader><leader>rs", ":lua<cr><cmd>lua vim.notify('Sourced lines')<cr>")
vim.keymap.set(
  "n",
  "<leader><leader>rl",
  "<cmd>LspRestart<cr><cmd>lua vim.print('LSPs restarted')<cr>",
  { desc = "Restart LSPs" }
)

-- git
vim.keymap.set("n", "<leader>gu", "<cmd>!gpull<cr>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>gk", function()
  local branch = vim.fn.input("Branch > ")
  local result = vim.cmd.Git("checkout " .. branch)
  vim.notify(result)
end, { desc = "Git checkout" })
vim.keymap.set("n", "<leader>gK", function()
  local branch = vim.fn.input("New Branch > ")
  local result = vim.cmd.Git("checkout -b" .. branch)
  vim.notify(result)
end, { desc = "Git checkout new branch" })
