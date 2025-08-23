return {
	"lewis6991/gitsigns.nvim",
	-- event = "LazyFile",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "" },
				change = { text = "" },
				delete = { text = "" },
				topdelete = { text = "󰍵" },
				changedelete = { text = "󰍴" },
				untracked = { text = "" },
			},
			signs_staged = {
				add = { text = "" },
				change = { text = "" },
				delete = { text = "" },
				topdelete = { text = "󰍵" },
				changedelete = { text = "󰍴" },
			},

			-- ⚙️ OPCIONES VISUALES
			signcolumn = true, -- Mostrar signos en gutter
			numhl = true, -- Resaltar número de línea
			linehl = false, -- No resaltar línea completa
			word_diff = false, -- No mostrar diff a nivel palabra

			-- 📡 MONITOREO
			watch_gitdir = {
				follow_files = true,
			},
			attach_to_untracked = true,

			-- 🕵️ BLAME INLINE
			current_line_blame = false, -- Toggle con :Gitsigns toggle_current_line_blame
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

			-- ⚡ RENDIMIENTO
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Usa el default
			max_file_length = 40000, -- No activar en archivos enormes

			-- 🔍 VENTANA DE PREVIEW
			preview_config = {
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},

			-- 🎹 KEYMAPS PERSONALIZADOS
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				-- Navegación entre hunks
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next Hunk")

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev Hunk")

				map("n", "]H", function()
					gs.nav_hunk("last")
				end, "Last Hunk")
				map("n", "[H", function()
					gs.nav_hunk("first")
				end, "First Hunk")

				-- Stage / Reset
				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
				map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")

				-- Blame / Diff
				map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>ghB", function()
					gs.blame()
				end, "Blame Buffer")
				map("n", "<leader>ghd", gs.diffthis, "Diff This")
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, "Diff This ~")

				-- Objeto de texto "ih" = hunk entero
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		})
	end,
}
