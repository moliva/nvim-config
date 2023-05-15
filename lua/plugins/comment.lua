return {
  'numToStr/Comment.nvim',
  lazy = true,
  -- TODO - add the visual block trigger as well - moliva - 2023/05/15
  keys = { 'gc', 'gb' },
  config = function()
    require('Comment').setup({
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
      },
      --- Enable keybindings
      --- NOTE: If given `false` then the plugin won't create any mappings
      -- gcc --> line comment the current line
      -- gcb --> block-comment the current line
      -- gc[count]{motion} --> line-comment the region contained in {motion}
      -- gb[count]{motion} --> block-comment the region contained in {motion}
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        -- gco --> new comment-linea below
        -- gco --> new comment-linea above
        -- gcA --> append line in comment
        extra = true,
      },
    })

    -- to add new/custom lang support
    -- local comment_ft = require("Comment.ft")
    -- comment_ftset( "lua", {"--%s", "--[[%s]]"})
  end
}
