return {
  "f-person/git-blame.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {

    { "<leader>g", nil, desc = "Git" },
    { "<leader>go", "<cmd>GitBlameOpenFileURL<CR>", desc = "Open Git file URL" },
    { "<leader>gc", "<cmd>GitBlameCopyFileURL<CR>", desc = "Copy Git file URL" },
  },
}
