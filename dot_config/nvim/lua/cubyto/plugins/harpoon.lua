return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependecies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		vim.keymap.set("n", "<leader>am", function()
			harpoon:list():add()
		end, { desc = "Add new mark to Harpoon" })
		vim.keymap.set("n", "<leader>ss", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Show list of Harpoon marks" })

		vim.keymap.set("n", "<leader>su", function()
			harpoon:list():select(1)
		end, { desc = "Go to 1st Harpoon mark" })
		vim.keymap.set("n", "<leader>si", function()
			harpoon:list():select(2)
		end, { desc = "Go to 2nd Harpoon mark" })
		vim.keymap.set("n", "<leader>so", function()
			harpoon:list():select(3)
		end, { desc = "Go to 3th Harpoon mark" })
		vim.keymap.set("n", "<leader>sp", function()
			harpoon:list():select(4)
		end, { desc = "Go to 4th Harpoon mark" })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<leader>sd", function()
			harpoon:list():prev()
		end, { desc = "Prev buffers stored within Harpoon list" })
		vim.keymap.set("n", "<leader>sf", function()
			harpoon:list():next()
		end, { desc = "Next buffers stored within Harpoon list" })
	end,
}
