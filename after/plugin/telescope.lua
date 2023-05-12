local builtin = require('telescope.builtin')

local grep_string_input = function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end

-- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- vim.keymap.set('n', '<leader>ps', grep_string_input)
-- vim.keymap.set('n', '<leader>pd', builtin.live_grep)
-- vim.keymap.set('n', '<leader>pa', builtin.grep_string)

local wk = require("which-key")
wk.register({
  p = {
    name = "Telescope",
    f = { builtin.find_files, "Telescope find files" },
    s = { grep_string_input, "Telescope grep string with input" },
    d = { builtin.live_grep, "Telescope live grep" },
    a = { builtin.grep_string, "Telescope grep string" },
  },
}, { prefix = "<leader>" })



local telescope = require('telescope')

telescope.setup({
	extensions = {
		lsp_handlers = {
			code_action = {
				telescope = require('telescope.themes').get_dropdown({}),
			},
		},
	},
})

telescope.load_extension('lsp_handlers')

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')

telescope.load_extension('neoclip')
