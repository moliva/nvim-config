return {
  {
    'theHamsta/nvim-dap-virtual-text',
    -- required by ui config
    lazy = true,
  },
  {
    'mfussenegger/nvim-dap',
    -- required by ui config
    lazy = true,
  },
  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    keys = {
      { "<leader>ct", nil,                           desc = "Debug" },
      { "<leader>ct", "<cmd>DapToggleBreakpoint<cr>" },
      { "<leader>cx", "<cmd>DapTerminate<cr>" },
      { "<leader>co", "<cmd>DapStepOver<cr>" },
    },
    config = function()
      require("nvim-dap-virtual-text").setup()

      local dapui = require("dapui")

      dapui.setup()

      local dap = require("dap")

      dap.listeners.after.event_initialized["dap_uiconfig"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dap_uiconfig"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dap_uiconfig"] = function()
        dapui.close()
      end
    end
  },
}
