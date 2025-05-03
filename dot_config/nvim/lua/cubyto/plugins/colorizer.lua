return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local colorizer = require("colorizer")
		colorizer.setup({
			"css",
			"js",
			html = {
				mode = "foreground",
			},
		})
	end,
}
