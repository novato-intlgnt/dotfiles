return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	priority = 10000,
	-- tag = "v2.15", -- uncomment to pin to a specific release
	config = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_method = "latexmk"
	end,
}
