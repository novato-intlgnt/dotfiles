return {
	"michaelrommel/nvim-silicon",
	lazyc = true,
	cmd = "Silicon",
	config = function()
		local silicon = require("silicon")

		local filePath = vim.api.nvim_get_current_buf()
		-- Función para obtener el nombre del archivo con o sin la extensión
		local function getFileName(with_ext)
			local modifier = with_ext and ":t" or ":t:r"
			return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(filePath, modifier))
		end

		-- Función para guardar en la carpeta dedicada
		local function getDedicatedFolderPath()
			local folder = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(filePath, ":h")) -- Crear la carpeta si no existe
			print(folder)
			if vim.fn.isdirectory(folder) == 0 then
				vim.fn.mkdir(folder, "p")
			end
			return folder .. getFileName(false) .. "_code.png"
		end

		silicon.setup({
			font = "Fira Code",
			theme = "Dracula",
			background = nil,
			window_title = getFileName(),
			tab_width = 2,
			gobble = true,
		})
		-- Mapeos de teclas
		local function set_keymaps()
			-- Guardar en la carpeta dedicada y copiar al portapapeles
			vim.keymap.set({ "n", "v" }, "<leader>sc", function()
				require("silicon").setup({
					output = getDedicatedFolderPath,
					to_clipboard = true,
				})
				silicon.visualise_api() -- Este comando ejecuta Silicon con la configuración actual
			end, { desc = "Save to dedicated folder and clipboard" })

			-- Guardar solo en el portapapeles
			vim.keymap.set({ "n", "v" }, "<leader>cs", function()
				require("silicon").setup({
					output = nil, -- No guardar en archivo
					to_clipboard = true,
				})
				silicon.visualise_api() -- Este comando ejecuta Silicon con la configuración actual
			end, { desc = "Save to clipboard only" })
		end

		-- Configurar los keymaps
		set_keymaps()
	end,
}
