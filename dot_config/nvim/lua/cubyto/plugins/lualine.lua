return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- require("transparent").clear_prefix("lualine")
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				icons_enabled = true,
				theme = "tokyonight-storm",
				-- theme = "dracula",
			},
			sections = {
				lualine_a = {
					{
						"filename",
						path = 1,
					},
				},
			},
		})
	end,
}
