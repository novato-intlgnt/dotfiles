return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	event = { "VeryLazy" },
	callback = function()
		vim.opt_local.conceallevel = 2
	end,
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		workspaces = {
			{ name = "qbytNotes", path = "~/qbyt/myObsidianVault/" },
		},
		templates = {
			subdir = "Templates",
			date_format = "%d-%m-%Y",
			time_format = "%H:%M",
		},
		pickers = { name = "snacks.pick" },
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true, desc = "Follow Obsidian link" },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true, desc = "toggle checkbox" },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true, desc = "Smart Obsidian action" },
			},
		},
	},

	config = function(_, opts)
		require("obsidian").setup(opts)

		local obsidian = require("obsidian")
		local client = obsidian.get_client()
		local Path = require("obsidian.path")

		-- 🚀 templates disponibles
		local TEMPLATE_CONFIG = {
			["Template_Class.md"] = {
				category = "course",
				subdir = "classes",
				vars = { "course", "title", "number", "prevNote", "nextNote" },
			},
			["Template_MathNotes.md"] = {
				category = "course",
				subdir = "classes",
				vars = { "course", "title", "number", "prevNote", "nextNote" },
			},
			["Template_CodeNotes.md"] = {
				category = "course",
				subdir = "classes",
				type = {
					"Concept",
					"Algorithm",
					"DataStructure",
					"Pattern",
					"Technique",
					"LanguageFeature",
					"Framework",
				},
				vars = { "mainTag", "course", "title", "number", "prevNote", "nextNote" },
			},
			["Template_CodeSelf.md"] = {
				category = "programming",
				subdir_picker = "03_Programming",
				vars = { "mainTag", "topic", "title" },
			},
			["Template_Note.md"] = {
				category = "learning",
				subdir_picker = "07_Learning",
				vars = { "mainTag", "subject", "title" },
			},
			["Template_Assignment.md"] = { category = "course", subdir = "assignments", vars = { "course", "title" } },
			["Template_Summary.md"] = { category = "course", subdir = "summaries", vars = { "course", "title" } },
			["Template_Exam.md"] = { category = "course", subdir = "exams", vars = { "course", "title" } },
			["Template_Project.md"] = {
				category = "project",
				subdir_picker = "06_Projects",
				vars = { "mainTag", "subject", "title" },
			},
			["Template_ReadingBook.md"] = {
				category = "reading",
				subdir_picker = "04_Readings",
				type = "book",
				vars = { "mainTag", "scndTag", "subject", "title" },
			},
			["Template_ReadingArticle.md"] = {
				category = "reading",
				subdir_picker = "04_Readings",
				type = "article",
				vars = { "mainTag", "scndTag", "subject", "title" },
			},
		}

		-- 📌 helpers
		local function next_number(folder_path)
			local handle = io.popen("find " .. folder_path .. ' -maxdepth 1 -type f -name "*.md"')
			if not handle then
				return "01"
			end
			local result = handle:read("*a")
			handle:close()

			local max_num = 0
			for line in result:gmatch("[^\r\n]+") do
				local filename = line:match("([^/]+)$")
				local num = filename and filename:match("^(%d+)_")
				if num and tonumber(num) > max_num then
					max_num = tonumber(num)
				end
			end
			return string.format("%02d", max_num + 1)
		end

		local function get_types(baseDir)
			local vault_path = vim.fn.expand("~/qbyt/myObsidianVault/" .. baseDir)
			local handle = io.popen("find " .. vault_path .. " -mindepth 1 -maxdepth 2 -type d")
			local result = handle:read("*a")
			handle:close()
			local options = {}
			for line in result:gmatch("[^\r\n]+") do
				local path = line:gsub("^" .. vault_path .. "/", "")
				table.insert(options, path)
			end
			return options
		end

		local function get_subDirs(baseDir)
			local vault_path = vim.fn.expand("~/qbyt/myObsidianVault/" .. baseDir)
			local handle = io.popen("find " .. vault_path .. " -mindepth 2 -maxdepth 2 -type d")
			local result = handle:read("*a")
			handle:close()

			local options = {}
			for line in result:gmatch("[^\r\n]+") do
				local path = line:gsub("^" .. vault_path .. "/", "")
				table.insert(options, path)
			end
			return options
		end

		local function pick_folder(prompt, options, cb)
			-- local pickers = require("telescope.pickers")
			-- local finders = require("telescope.finders")
			-- local conf = require("telescope.config").values
			-- local actions = require("telescope.actions")
			-- local action_state = require("telescope.actions.state")
			--
			-- pickers
			-- 	.new({}, {
			-- 		prompt_title = prompt,
			-- 		finder = finders.new_table({ results = options }),
			-- 		sorter = conf.generic_sorter({}),
			-- 		attach_mappings = function(prompt_bufnr, _)
			-- 			actions.select_default:replace(function()
			-- 				actions.close(prompt_bufnr)
			-- 				local selection = action_state.get_selected_entry()[1]
			-- 				cb(selection)
			-- 			end)
			-- 			return true
			-- 		end,
			-- 	})
			-- 	:find()

			-- local snacks = require("snacks")
			local items = {}
			for idx, opt in ipairs(options) do
				local item = {
					idx = idx,
					name = opt,
					text = opt,
				}
				table.insert(items, item)
			end
			Snacks.picker({
				title = prompt,
				items = items,
				layout = { preset = "select" },
				format = function(item, _)
					return {
						{ item.text, item.text_hl },
					}
				end,
				confirm = function(picker, picked)
					picker:close()
					cb(picked.name) -- aquí devuelves la opción seleccionada
				end,
			})
		end

		local function update_prev_note(prev_path, new_filename)
			if not prev_path or prev_path == "" then
				return
			end
			local lines = vim.fn.readfile(prev_path)
			local updated = false
			for i, line in ipairs(lines) do
				if line:match("^%*%*Next:%*%*") then
					lines[i] = "**Next:** " .. new_filename
					updated = true
				end
			end
			if not updated then
				for i, line in ipairs(lines) do
					if line:match("^%*%*Previous:%*%*") then
						table.insert(lines, i + 1, "**Next:** " .. new_filename)
						break
					end
				end
			end
			vim.fn.writefile(lines, prev_path)
		end

		local function create_note_from_template()
			pick_folder("📝 Select Template", vim.tbl_keys(TEMPLATE_CONFIG), function(chosen_template)
				local config = TEMPLATE_CONFIG[chosen_template]
				local vars = {}

				if config.category == "course" then
					pick_folder("📚 Select Course", get_subDirs("02_University"), function(course_path)
						vars.course = course_path
						local path = vim.fn.expand("~/qbyt/myObsidianVault/02_University/" .. course_path)

						local tags = { course_path, config.subdir }
						if vim.tbl_contains(config.vars, "number") then
							vars.number = next_number(path .. "/" .. config.subdir)
						end

						vars.title = vim.fn.input("Title: ")
						local file_name = (vars.number and vars.number .. "_" or "") .. vars.title
						local file_path = Path:new(path) / config.subdir

						-- ⚡ determinar nota previa (última en el folder)
						local notes = vim.fn.systemlist("ls -1 " .. path .. "/" .. config.subdir .. " | sort")
						local prevNote = (#notes > 0) and notes[#notes] or ""
						vars.prevNote = prevNote

						-- crear la nota
						client.opts.templates.substitutions = vars
						local note = client:create_note({
							title = vars.title,
							id = file_name,
							dir = file_path,
							aliases = { vars.title },
							tags = tags,
							template = chosen_template,
						})

						vim.cmd("edit " .. tostring(note.path))

						-- actualizar nota previa con nextNote
						if prevNote ~= "" then
							local prev_path = path .. "/" .. config.subdir .. "/" .. prevNote
							update_prev_note(prev_path, file_name .. ".md")
						end
					end)
				elseif
					config.category == "project"
					or config.category == "reading"
					or config.category == "programming"
					or config.category == "learning"
				then
					pick_folder("📂 Select Type", get_types(config.subdir_picker), function(type_folder)
						local path =
							vim.fn.expand("~/qbyt/myObsidianVault/" .. config.subdir_picker .. "/" .. type_folder)
						vars.subject = type_folder

						local tags = { vars.subject, config.category }

						vars.title = vim.fn.input("Title: ")
						-- Versión más legible
						local type_available = vim.tbl_contains(config, "type")
						local is_reading = config.category == "reading"

						local file_path_value = path
						if type_available and is_reading then
							file_path_value = path .. "/" .. config.type
							table.insert(tags, config.type)
						else
							if vim.tbl_contains(config, "type") then
								pick_folder("Select Type: ", config.type, function(typeCode)
									table.insert(tags, typeCode)
								end)
							end
							client.opts.templates.substitutions = vars
						end

						local file_path = Path:new(file_path_value)

						local note = client:create_note({
							title = vars.title,
							id = vars.title,
							dir = file_path,
							aliases = { vars.title },
							tags = tags,
							template = chosen_template,
						})
						vim.cmd("edit " .. tostring(note.path))
					end)
				end
			end)
		end

		-- 🔗 saltos prev/next
		local function jump_note(direction)
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local pattern = direction == "prev" and "%*%*Previous:%*%* (.+)" or "%*%*Next:%*%* (.+)"
			for _, line in ipairs(lines) do
				local match = line:match(pattern)
				if match then
					local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
					vim.cmd("edit " .. dir .. "/" .. match)
					return
				end
			end
			print("No " .. direction .. " note found.")
		end

		-- keymaps
		vim.keymap.set("n", "<leader>nt", create_note_from_template, { desc = "New note from template" })
		vim.keymap.set("n", "<leader>np", function()
			jump_note("prev")
		end, { desc = "Jump to previous note" })
		vim.keymap.set("n", "<leader>nn", function()
			jump_note("next")
		end, { desc = "Jump to next note" })
	end,
}
