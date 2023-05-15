return {
  'f-person/git-blame.nvim',
  event = { "BufReadPre", "BufNewFile" },
  keys = {

    { "<leader>go", "<cmd>GitBlameOpenFileURL<CR>", desc = "Open file URL" },
    { "<leader>gc", "<cmd>GitBlameCopyFileURL<CR>", desc = "Copy file URL" },
  }
}
