local ls = require("luasnip")

local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node

-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")

local extras = require("luasnip.extras")
-- local l = extras.lambda
local rep = extras.rep -- repeats the content of the `number` insert node referenced
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda

local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

return {
  parse("log", "console.log('${1:expression}', $1)"),
  s(
    "forconst",
    fmt("for (const {} of {}) {{\n  {}\n}}", {
      i(1, "i"),
      i(2, "iterable"),
      i(0),
    })
  ),
  s(
    "forlet",
    fmt("for (let {} = {}; {} < {}; ++{}) {{\n  {}\n}}", {
      i(1, "i"),
      i(2, "0"),
      rep(1),
      i(3, "array.length"), -- TODO - lookup options from context - moliva - 2024/04/01
      rep(1),
      i(0),
    })
  ),
  s(
    "itfn",
    fmt('it{}("{}", {}() => {{\n  {}\n}})', {
      c(1, { t(""), t(".only"), t(".ignore") }),
      i(2, "test name"),
      c(3, { t(""), t("async ") }),
      i(0),
    })
  ),
}
