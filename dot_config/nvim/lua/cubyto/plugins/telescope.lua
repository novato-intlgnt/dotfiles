return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-file-browser.nvim",
		"aaronhallaert/advanced-git-search.nvim",
		"olacin/telescope-cc.nvim",
	},
	keys = {
		{
			"<leader>fp",
			function()
				require("telescope.builtin").find_files({
					prompt_title = "Plugins",
					cwd = "~/.config/nvim/lua/cubyto/plugins/",
					attach_mappings = function(_, map)
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")
						map("i", "<c-y>", function(prompt_bufnr)
							local new_plugin = action_state.get_current_line()
							actions.close(prompt_bufnr)
							local path = string.format("~/.config/nvim/lua/plugins/%s.lua", new_plugin)
							vim.cmd(string.format("edit %s", path))
							-- Guardar el archivo inmediatamente después de crearlo
							vim.cmd("write")
						end)
						return true
					end,
				})
			end,
			desc = "Find plugins",
		},
		{
			"<leader>fc",
			function()
				require("telescope.builtin").find_files({
					prompt_title = "Config",
					cwd = "~/.config/nvim/lua/cubyto/config/",
					attach_mappings = function(_, map)
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")
						map("i", "<c-y>", function(prompt_bufnr)
							local new_plugin = action_state.get_current_line()
							actions.close(prompt_bufnr)
							vim.cmd(string.format("e! ~/.config/nvim/lua/cubyto/config/%s.lua", new_plugin))
						end)
						return true
					end,
				})
			end,
			desc = "Find config",
		},
		-- {
		-- 	"<leader>fP",
		-- 	require("telescope").extensions.projects.projects({}),
		-- 	desc = "find Projects",
		-- },
		{
			"cc",
			function()
				local picker = require("telescope._extensions.conventional_commits.picker")
				local actions = require("telescope.actions.state")

				-- if you use the picker directly you have to provide your theme manually
				picker({
					action = actions.prompt,
					include_body_and_footer = true,
					-- theme = themes["get_ivy"]() -- ivy theme
				})
			end,
			desc = "Create conventional commit",
		},
		{
			"<leader>fb",
			function()
				require("telescope").extensions.file_browser.file_browser({ path = "%:h:p", select_buffer = true })
			end,
			desc = "Telescope file browser",
		},
	},
	config = function()
		require("transparent").clear_prefix("telescope")
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, --> move to prev result
						["<C-j>"] = actions.move_selection_next, --> move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				file_browser = {
					theme = "ivy",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					mappings = {
						["i"] = {
							["<C-k>"] = actions.move_selection_previous, --> move to prev result
							["<C-j>"] = actions.move_selection_next, --> move to next result
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
						["n"] = {
							-- your custom normal mode mappings
						},
					},
				},
				advanced_git_search = {
					-- fugitive or diffview
					diff_plugin = "fugitive",
					-- customize git in previewer
					-- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
					git_flags = {},
					-- customize git diff in previewer
					-- e.g. flags such as { "--raw" }
					git_diff_flags = {},
					-- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
					show_builtin_git_pickers = false,
					entry_default_author_or_date = "author", -- one of "author" or "date"

					-- Telescope layout setup
					telescope_theme = {
						function_name_1 = {
							-- Theme options
						},
						function_name_2 = "dropdown",
						-- e.g. realistic example
						show_custom_functions = {
							layout_config = { width = 0.4, height = 0.4 },
						},
					},
				},
			},
		})
		require("telescope").load_extension("file_browser")
		require("telescope").load_extension("advanced_git_search")
		require("telescope").load_extension("neoclip")
		require("telescope").load_extension("conventional_commits")

		local builtin = require("telescope.builtin")

		--vim.keymap.set("n", "<leader>fb", builtin.file_browser, { desc = "Find a file" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find string in cwd" })
		vim.keymap.set("n", "<leader>fu", builtin.grep_string, { desc = "Find string under cursor in cwd" })

		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "View the helper page" })
		-- vim.keymap.set("n", "<leader>bl", builtin.buffers, { desc = "Show the list of buffers" })

		-- GIT search
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Show the git status" })
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Show the git branches" })
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Show the git commits" })
		vim.keymap.set("n", "<leader>gB", builtin.git_bcommits, { desc = "Show the git Bcommits" })
		vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Show the git files" })

		-- NEOCLIP search
		vim.api.nvim_set_keymap("n", "<leader>cb", ":Telescope neoclip<CR>", { silent = true })
	end,
}
