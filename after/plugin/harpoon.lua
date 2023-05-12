local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local wk = require("which-key")
local modes = { 'n', 'i', 'v' }

for _, mode in ipairs(modes) do
  wk.register({
    ['<a-h>'] = {
      name = "Harpoon",
      ['<a-h>'] = { ui.toggle_quick_menu, "Harpoon quick menu" },

      a = { function() ui.nav_file(1) end, "Navigate to harpooned file 1", },
      s = { function() ui.nav_file(2) end, "Navigate to harpooned file 2", },
      d = { function() ui.nav_file(3) end, "Navigate to harpooned file 3", },
      f = { function() ui.nav_file(4) end, "Navigate to harpooned file 4", },
    },
  })
end

wk.register({
  ha = { mark.add_file, "Mark file as harpooned" }
}, { prefix = '<leader>' })

