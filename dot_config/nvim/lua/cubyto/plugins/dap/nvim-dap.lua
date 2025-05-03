return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()

			require("nvim-dap-virtual-text").setup({
				-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)
					if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
						return "*****"
					end

					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end

					return " " .. variable.value
				end,
			})

			-- Handled by nvim-dap-go
			-- dap.adapters.go = {
			--   type = "server",
			--   port = "${port}",
			--   executable = {
			--     command = "dlv",
			--     args = { "dap", "-l", "127.0.0.1:${port}" },
			--   },
			-- }

			local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
			if elixir_ls_debugger ~= "" then
				dap.adapters.mix_task = {
					type = "executable",
					command = elixir_ls_debugger,
				}

				dap.configurations.elixir = {
					{
						type = "mix_task",
						name = "phoenix server",
						task = "phx.server",
						request = "launch",
						projectDir = "${workspaceFolder}",
						exitAfterTaskReturns = false,
						debugAutoInterpretAllModules = false,
					},
				}
			end

			-- Debugger
			vim.api.nvim_set_keymap(
				"n",
				"<leader>dt",
				"<cmd>DapUiToggle<CR>",
				{ noremap = true, desc = "Add breakpoint at line" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>db",
				"<cmd>DapToggleBreakpoint<CR>",
				{ noremap = true, desc = "Toggle breakpoint" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>dc",
				"<cmd>DapContinue<CR>",
				{ noremap = true, desc = "Continue the debugger" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>dr",
				"<cmd>lua require('dapui').open({reset = true})<CR>",
				{ noremap = true, desc = "Restar the debugger" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>ht",
				"<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
				{ noremap = true }
			)
			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
