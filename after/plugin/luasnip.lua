local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
  -- remembers last snippet to jump back into it if you moved out accidentally
  history = true,
  -- dynamic snippets updates
  updateevents = "TextChanged,TextChangedI",
  -- check if auto snippets are good
  enable_autosnippets = true,
  -- more
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<- Current Choice", "Error" } },
      }
    }
  }
})

-- c-k expansion key
-- this will expand the current item or jump to the next item within the snippet
--vim.keymap.set({ "i", "s" }, "<c-k>", function()
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- TODO - these 2 are conflicting right!

-- c-j jumps backwards
-- moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- c-l changes choice in current snippet insert node
-- useful for choice nodes
vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set({ "i", "s" }, "<c-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)

-- shortcut to source my luasnips file again, which will reload muy snippets
vim.keymap.set("n", "<leader><leader>s", "<cmd>source /Users/moliva/.config/nvim/after/plugin/luasnip.lua<CR>")






local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")

local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep -- repeats the content of the `number` insert node referenced
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

-- cleans up all snippets (useful when reloading this file)
ls.cleanup()

ls.add_snippets("all", {
  parse("todo",
  "$LINE_COMMENT ${1|TODO,FIXME,XXX|} - ${2:description} - moliva - $CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DATE"),
  -- s("todo1", fmt("{} {} - {} - moliva - {}", { t("//"), c(1, { t("TODO"), t("FIXME"), t("XXX") }), i(2, "description"), f(function()
  --   return
  --       os.date("%Y/%m/%d")
  -- end) })),
})

ls.add_snippets("rust", {
  s("modtest",
    fmt(
      [[
            #[cfg(test)]
            mod test {{
            {}

              {}
            }}
   ]],
      {
        c(1, { t("  use super::*;", t("")) }),
        i(0)
      }))
})

ls.add_snippets("text", {
  s("meeting", fmt("**** {} ****\n{}", { i(1, "meeting name"), i(0) })),
  s("newmeetingsfile", fmt(
    [[

    {}


    ****************************************************************************************************************
    ********************* Action items *********************
    ****************************************************************************************************************



    EOF
    ]], { i(0) })),
  parse("today", "$CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DATE"),
  s("sep", fmt(
    [[
    ****************************************************************************************************************
    ********************* {} *********************
    ****************************************************************************************************************
    ]], { i(0) })),
})
