return {
  'saecki/crates.nvim',
  version = 'v0.3.0',
  -- TODO - doesn't work, there seems to be an issue with the spawn job of plenary and the plugin - moliva - 2023/05/14
  -- ft = 'toml',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local crates = require('crates')

    crates.setup({
      text = {
        loading = "  Loading...",
        version = "  %s",
        prerelease = "  %s",
        yanked = "  %s yanked",
        nomatch = "  Not found",
        upgrade = "  %s",
        error = "  Error fetching crate",
      },
      popup = {
        text = {
          title = "# %s",
          pill_left = "",
          pill_right = "",
          created_label = "created        ",
          updated_label = "updated        ",
          downloads_label = "downloads      ",
          homepage_label = "homepage       ",
          repository_label = "repository     ",
          documentation_label = "documentation  ",
          crates_io_label = "crates.io      ",
          categories_label = "categories     ",
          keywords_label = "keywords       ",
          version = "%s",
          prerelease = "%s pre-release",
          yanked = "%s yanked",
          enabled = "* s",
          transitive = "~ s",
          normal_dependencies_title = "  Dependencies",
          build_dependencies_title = "  Build dependencies",
          dev_dependencies_title = "  Dev dependencies",
          optional = "? %s",
          loading = " ...",
        },
      },
      src = {
        text = {
          prerelease = " pre-release ",
          yanked = " yanked ",
        },
      },
    })

    local wk = require("which-key")

    wk.register({
      t = { crates.toggle, "crates.toggle" },
      r = { crates.reload, "crates.reload" },
      v = { crates.show_versions_popup, "crates.show_versions_popup" },
      f = { crates.show_features_popup, "crates.show_features_popup" },
      d = { crates.show_dependencies_popup, "crates.show_dependencies_popup" },
      u = { crates.update_crate, "crates.update_crate" },
      a = { crates.update_all_crates, "crates.update_all_crates" },
      U = { crates.upgrade_crate, "crates.upgrade_crate" },
      A = { crates.upgrade_all_crates, "crates.upgrade_all_crates" },
      H = { crates.open_homepage, "crates.open_homepage" },
      R = { crates.open_repository, "crates.open_repository" },
      D = { crates.open_documentation, "crates.open_documentation" },
      C = { crates.open_crates_io, "crates.open_crates_io" },
    }, { prefix = "<leader>c", silent = true })

    wk.register({
      u = { crates.update_crates, "crates.update_crates" },
      U = { crates.upgrade_crates, "crates.upgrade_crates" },
    }, { prefix = "<leader>c", mode = 'v', silent = true })
  end
}
