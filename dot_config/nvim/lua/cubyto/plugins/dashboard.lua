return {
	"glepnir/dashboard-nvim",
	event = "VimEnter",
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	config = function()
		require("dashboard").setup({
			-- config
			theme = "doom",
			config = {
				--preview_file_height = 20,
				--preview_file_width = 70,
				header = {
					"",
					"",
					" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
					" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
					" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
					" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
					" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
					" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
					"",
					" [ -- Wellcome Cubyto  -- ] ",
					"",
				},
				center = {
					{
						icon = "📝  ",
						desc = "New File                          ",
						action = "<cmd>ene<CR>",
						key = "Space n f",
					},
					{
						icon = "🔍🔠 ",
						desc = "Find  word                              ",
						action = "Telescope live_grep",
						key = "Space f g",
					},
					{
						icon = "🔍📂 ",
						desc = "Find  File                              ",
						action = "Telescope find_files",
						key = "Space f f",
					},
					{
						icon = "⌛ ",
						desc = "Recently opened files                   ",
						action = "Telescope oldfiles",
						key = "Space f r",
					},
					{
						icon = "🔖  ",
						desc = "Bookmarks                               ",
						action = "BookmarkShowAll",
						key = "b a",
					},
					{
						icon = "🕵  ",
						desc = "File Browser                             ",
						action = "Telescope file_browser",
						key = "Space f b",
					},
					{
						icon = "🌵   ",
						desc = "NvimTree                              ",
						action = "NvimTreeToggle",
						key = "Space e e",
					},
					{
						icon = "📤   ",
						desc = "Exit of Neovim                                    ",
						action = ":quit",
					},
				},
				footer = {
					"",
					"Cubyto Have a fun time on Neovim",
					"",
				},
			},
		})
	end,
}
