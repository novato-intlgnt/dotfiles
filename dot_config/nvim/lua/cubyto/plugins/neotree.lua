-- return {
-- 	"nvim-tree/nvim-tree.lua",
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	config = function()
-- 		require("transparent").clear_prefix("nvim-tree")
-- 		local nvimtree = require("nvim-tree")
--
-- 		-- recommended settings from nvim-tree documentation
-- 		vim.g.loaded_netrw = 1
-- 		vim.g.loaded_netrwPlugin = 1
--
-- 		-- change color for arrows in tree to light blue
-- 		vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
-- 		vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])
--
-- 		-- configure nvim-tree
-- 		nvimtree.setup({
-- 			view = {
-- 				relativenumber = true,
-- 			},
-- 			-- change folder arrow icons
-- 			renderer = {
--
-- 				icons = {
-- 					glyphs = {
-- 						folder = {
-- 							arrow_closed = "", -- arrow when folder is closed
-- 							arrow_open = "", -- arrow when folder is open
-- 						},
-- 					},
-- 				},
-- 			},
-- 			-- disable window_picker for
-- 			-- explorer to work well with
-- 			-- window splits
-- 			actions = {
-- 				open_file = {
-- 					window_picker = {
-- 						enable = false,
-- 					},
-- 				},
-- 			},
-- 			filters = {
-- 				custom = { ".DS_Store" },
-- 			},
-- 			git = {
-- 				ignore = false,
-- 			},
-- 		})
--
-- 		local function opts(desc)
-- 			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
-- 		end
-- 		-- set keymaps
-- 		local keymap = vim.keymap.set -- for conciseness
-- 		local api = require("nvim-tree.api")
--
-- 		keymap("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
-- 		keymap("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
-- 		keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
-- 		keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
-- 		keymap("n", "?", api.tree.toggle_help, opts("Help"))
-- 	end,
-- }

return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	branch = "v3.x",
	keys = {
		{
			"<leader>fe",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
			end,
			desc = "Explorer NeoTree (Root Dir)",
		},
		{
			"<leader>fE",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
			end,
			desc = "Explorer NeoTree (cwd)",
		},
		{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
		{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
		{
			"<leader>ge",
			function()
				require("neo-tree.command").execute({ source = "git_status", toggle = true })
			end,
			desc = "Git Explorer",
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
		-- because `cwd` is not set up properly.
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Neo-tree with directory",
			once = true,
			callback = function()
				if package.loaded["neo-tree"] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("neo-tree")
					end
				end
			end,
		})
	end,
	opts = {
		sources = { "filesystem", "buffers", "git_status" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		close_if_last_window = true,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = true,
			},
			group_empty_dirs = true,
			hijack_netrw_behavior = "open_default",
		},
		window = {
			width = 32,
			mappings = {
				["l"] = "open",
				["h"] = "close_node",
				["Y"] = {
					function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
					end,
					desc = "Copy Path to Clipboard",
				},
				["O"] = {
					function(state)
						require("lazy.util").open(state.tree:get_node().path, { system = true })
					end,
					desc = "Open with System Application",
				},
				["P"] = { "toggle_preview", config = { use_float = false } },
				["<space>"] = "toggle_node",
				["<cr>"] = "open",
				["S"] = "split_with_window_picker",
				["s"] = "vsplit_with_window_picker",
				["t"] = "open_tabnew",
				["C"] = "close_node",
				["R"] = "refresh",
				["a"] = "add",
				["d"] = "delete",
				["r"] = "rename",
				["c"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
				with_markers = true,
				indent_size = 2,
				padding = 1,
			},
			icon = {
				-- folder_closed = "", -- Carpeta cerrada
				folder_open = "", -- Carpeta abierta
				folder_empty = "", -- Carpeta vacía
				default = "", -- Archivo genérico
			},
			git_status = {
				symbols = {
					added = "",
					deleted = "",
					modified = "",
					renamed = "",
					untracked = "",
					ignored = "",
					conflict = "",
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
		},
	},
	config = function(_, opts)
		local function on_move(data)
			Snacks.rename.on_rename_file(data.source, data.destination)
		end

		local events = require("neo-tree.events")
		opts.event_handlers = opts.event_handlers or {}
		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED, handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})
		require("neo-tree").setup(opts)
		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
		-- change color for arrows in tree to light blue
		vim.cmd([[ 
      highlight NeoTreeExpander guifg=#3FC5FF
      highlight NeoTreeDirectoryIcon guifg=#7aa2f7
      highlight NeoTreeDirectoryName guifg=#7aa2f7
      highlight NeoTreeGitAdded guifg=#9ece6a
      highlight NeoTreeGitDeleted guifg=#f7768e
      highlight NeoTreeGitModified guifg=#e0af68
      highlight NeoTreeFileNameOpened guifg=#7dcfff
    ]])

		-- Mostrar número de línea en el explorador
		vim.cmd([[
      autocmd FileType neo-tree setlocal relativenumber number
    ]])
	end,
}
