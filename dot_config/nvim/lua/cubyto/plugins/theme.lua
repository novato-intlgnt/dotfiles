return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- Set colorscheme
		vim.o.termguicolors = true
		-- load the colorscheme here
		vim.cmd([[colorscheme tokyonight]])
		require("tokyonight").setup({
			-- style = {
			-- 	sidebars = "transparent",
			-- 	floats = "transparent",
			-- },
			style = "storm",
			transparent = vim.g.transparent_enabled,
			transparent_background = true,
		})
	end,
}
