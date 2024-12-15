local job_id = 0

local term = vim.api.nvim_create_augroup("custom-term-open", { clear = true })

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = term,
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

vim.keymap.set("n", "<leader>to", function()
  -- if job_id ~= 0 then
  --   vim.fn.chanclose(job_id)
  -- end

  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)

  job_id = vim.bo.channel
end, { desc = "Open terminal" })

vim.keymap.set("n", "<leader>tj", function()
  vim.fn.chansend(job_id, "echo 'Hello, world!'\r")
end, { desc = "Send job to terminal" })
