return {
  "tpope/vim-fugitive",
  cmd = "Git",
  keys = {
    { "<leader>gi", "<cmd>Git init<cr>", desc = "Git Init" },
    { "<leader>gs", vim.cmd.Git, desc = "Git Status" },
    { "<leader>gp", "<cmd>Git push origin HEAD<cr>", desc = "Git Push" },
  },
}
