return {
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>c", nil, desc = "Debug" },
      {
        "<leader>ct",
        function()
          require("dap").toggle_breakpoint()
          require("kmobic33.breakpoints").store()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>cg",
        function()
          require("dap").set_breakpoint(vim.fn.input("[Condition] > "))
          require("kmobic33.breakpoints").store()
        end,
        desc = "Set Conditional Breakpoint",
      },
      {
        "<leader>cd",
        function()
          require("dap").clear_breakpoints()
          require("kmobic33.breakpoints").store()
        end,
        desc = "Clear Breakpoints",
      },
      { "<leader>cc", "<cmd>DapContinue<cr>", desc = "Continue" },
      { "<leader>cx", "<cmd>DapTerminate<cr>", desc = "Terminate" },
      { "<leader>co", "<cmd>DapStepOver<cr>", desc = "Step Over" },
      { "<leader>ci", "<cmd>DapStepInto<cr>", desc = "Step Into" },
      { "<leader>cu", "<cmd>DapStepOut<cr>", desc = "Step Out" },
      { "<leader>cr", "<cmd>DapRestartFrame<cr>", desc = "Restart Frame" },
    },
    dependencies = { "nvim-neotest/nvim-nio" },
    config = function()
      require("nvim-dap-virtual-text").setup()

      -- Load breakpoints
      require("kmobic33.breakpoints").load()

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
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    -- required by ui config
    lazy = true,
    config = function()
      require("nvim-dap-virtual-text").setup({
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        display_callback = function(variable, _, _, _, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

        -- experimental features:
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    -- required by ui config
    lazy = true,
  },
}
