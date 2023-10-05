return {
  {
    'ThePrimeagen/harpoon',
    lazy = true,
    keys = {
      { '<leader>h', nil,        desc = "Harpoon" },
      { '<leader>ha', function() require("harpoon.mark").add_file() end,        desc = "Mark file as harpooned" },
      { '<a-h><a-h>', function() require('harpoon.ui').toggle_quick_menu() end, desc = "Harpoon quick menu" },
      { '<a-h>a',     function() require('harpoon.ui').nav_file(1) end,         desc = "Navigate to harpooned file 1", },
      { '<a-h>s',     function() require('harpoon.ui').nav_file(2) end,         desc = "Navigate to harpooned file 2", },
      { '<a-h>d',     function() require('harpoon.ui').nav_file(3) end,         desc = "Navigate to harpooned file 3", },
      { '<a-h>f',     function() require('harpoon.ui').nav_file(4) end,         desc = "Navigate to harpooned file 4", },
    },
  },
}
