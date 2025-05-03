return {
	"Wansmer/treesj",
	keys = { "<leader>m" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local tsj = require("treesj")
		tsj.setup({ max_join_length = 400 })
	end,
}
