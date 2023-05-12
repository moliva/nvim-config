
-- TODO - move to an autocommand group for git repos - moliva - 2023/04/20
vim.keymap.set("n", "<leader>go", "<cmd>GitBlameOpenFileURL<CR>")
vim.keymap.set("n", "<leader>gc", "<cmd>GitBlameCopyFileURL<CR>")
