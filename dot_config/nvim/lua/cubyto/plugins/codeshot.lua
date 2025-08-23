-- Lua
return {
	"SergioRibera/codeshot.nvim",
	config = function()
		require("codeshot").setup({})
		-- Take screenshot just of selected lines
		vim.keymap.set("v", "<Leader>s", ":SSSelected")
		-- Take screenshot of file and highlight selected lines
		vim.keymap.set("v", "<Leader>s", ":SSFocused")
	end,
}
