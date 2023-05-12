-- vim.api.nvim_create_autocmd({"BufEnter"}, {
--   pattern = {"*.txt"},
--   callback = function(ev)
-- print(string.format('event fired: %s', vim.inspect(ev)))

-- filename = vim.fn.expand('%')
-- filename = ev.file
-- file_extension = get_file_extension(filename)
-- enable_cmp = file_extension ~= '.txt'
-- vim.api.nvim_create_autocmd({"BufEnter"}, {
--   pattern = {"*.txt"},
--   callback = function(ev)
--     -- print(string.format('event fired: %s', vim.inspect(ev)))
--
--     -- filename = vim.fn.expand('%')
--     -- filename = ev.file
--     -- file_extension = get_file_extension(filename)
--     --    enable_cmp = file_extension ~= '.txt'
--
--     -- local cmp = require('cmp').setup.buffer { enabled = false }
--   end
-- })

-- require('cmp').setup.buffer { enabled = false }
--   end
-- k)
-- local utils = require("kmobic33.utils")

-- toggle `buffer` completion source when in a text file or not
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = "*",
--   callback = function(ev)
--     local file = ev["file"]
--     local file_extension = utils.get_file_extension(file)
--     local not_text = file_extension ~= ".txt"
--
--     -- require('cmp').setup.buffer({ enabled = not_text })
--   end
-- })

-- set the transparency of the buffer on open (helpful when opening new windows, splits, tabs
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  command = "hi NormalNC ctermbg=NONE guibg=NONE"
})

-- format on sve
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  -- pattern = { "*.rs", "*.lua" },
  pattern = { "*.rs" },
  callback = vim.lsp.buf.format
})

vim.cmd [[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]]
