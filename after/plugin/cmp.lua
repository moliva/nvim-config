-- set the transparency of the buffer on open (helpful when opening new windows, splits, tabs
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  command = "hi NormalNC ctermbg=NONE guibg=NONE"
})

-- format on sve
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.rs" },
  callback = vim.lsp.buf.format
})

vim.cmd [[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]]
