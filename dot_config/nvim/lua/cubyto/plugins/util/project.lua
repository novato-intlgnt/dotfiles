local pick = nil

pick = function()
	return vim.cmd("Telescope projects")
end
return {
	{
		"ahmedkhalf/project.nvim",
		opts = {
			manual_mode = true,
		},
		event = "VeryLazy",
		config = function(_, opts)
			require("project_nvim").setup(opts)
			local history = require("project_nvim.utils.history")
			history.delete_project = function(project)
				for k, v in pairs(history.recent_projects) do
					if v == project.value then
						history.recent_projects[k] = nil
						return
					end
				end
			end
			require("telescope").load_extension("projects")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		keys = {
			{ "<leader>fp", pick, desc = "Projects" },
		},
	},

	-- 	{
	-- 		"folke/snacks.nvim",
	-- 		optional = true,
	-- 		opts = function(_, opts)
	-- 			table.insert(opts.dashboard.preset.keys, 3, {
	-- 				action = pick,
	-- 				desc = "Projects",
	-- 				icon = " ",
	-- 				key = "p",
	-- 			})
	-- 		end,
	-- 	},
}
