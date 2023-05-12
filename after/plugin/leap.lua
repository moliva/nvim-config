local leap = require('leap')

-- leap.add_default_mappings()

local function leap_forward()
  local current_window = vim.fn.win_getid()
  leap.leap { target_windows = { current_window } }
end

local function leap_global()
  local focusable_windows_on_tabpage = vim.tbl_filter(
    function(win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  )
  leap.leap { target_windows = focusable_windows_on_tabpage }
end

local wk = require("which-key")

wk.register({
  c = { leap_forward, "Leap forward" },
  gc = { leap_global, "Leap global" },
}, { prefix = "<leader><leader>" })

-- Or just set to grey directly, e.g. { fg = '#777777' },
-- if Comment is saturated.
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
