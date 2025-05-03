return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"davidsierradz/cmp-conventionalcommits", -- source for comventional commits
		"hrsh7th/cmp-cmdline", -- source for command line
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp_status, cmp = pcall(require, "cmp")
		if not cmp_status then
			return
		end

		local luasnip_status, luasnip = pcall(require, "luasnip")
		if not luasnip_status then
			return
		end

		local lspkind = require("lspkind")

		local kind_icons = {
			article = "󰧮",
			book = "",
			incollection = "󱓷",
			Function = "󰊕",
			Constructor = "",
			Text = "󰦨",
			Method = "",
			Field = "󰅪",
			Variable = "󱃮",
			Class = "",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "󰚯",
			Enum = "",
			Keyword = "",
			Snippet = "",
			-- Color = "󰌁",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			-- EnumMember = "",
			EnumMember = "",
			Constant = "󰀫",
			-- Struct = "",
			Struct = "",
			Event = "",
			Operator = "󰘧",
			TypeParameter = "",
		}

		-- Loads VScode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip/loaders/from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "conventionalcommits" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			-- Configure lspkind fot vs-code like pictograms in completion menu
			--formatting = {
			--format = lspkind.cmp_format({
			--maxwidth = 50,
			--ellipsis_char = "...",
			--}),
			--},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
					})
					vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) -- Kind icons
					vim_item.menu = ({
						-- vimtex = (vim_item.menu ~= nil and vim_item.menu or "[VimTex]"),
						-- vimtex = test_fn(vim_item.menu, entry.source.name),
						vimtex = vim_item.menu,
						luasnip = "[Snippet]",
						nvim_lsp = "[LSP]",
						buffer = "[Buffer]",
						spell = "[Spell]",
						-- orgmode = "[Org]",
						-- latex_symbols = "[Symbols]",
						cmdline = "[CMD]",
						path = "[Path]",
					})[entry.source.name]
					return vim_item
				end,
			},
		})
		cmp.setup.buffer({
			sources = cmp.config.sources({ {
				name = "conventionalcommits",
			} }, { { name = "buffer" } }),
		})
		-- Use buffer source for `/` and `?
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
		-- `:` cmdline setup.
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})
	end,
}
