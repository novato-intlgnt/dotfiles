-- Función para compilar archivos C++
local function compile_cpp()
	-- Obtén el nombre completo del archivo actual
	local filename = vim.api.nvim_buf_get_name(0)

	-- Verifica que la extensión sea .cpp
	if filename:match("%.cpp$") then
		-- Obtén el directorio del archivo actual
		local file_dir = vim.fn.fnamemodify(filename, ":h")

		-- Construye el directorio de salida para los ejecutables
		local output_dir = file_dir .. "/bin"

		-- Crea el directorio si no existe
		vim.fn.mkdir(output_dir, "p")

		-- Construye el nombre del archivo ejecutable (sin extensión) y su ruta
		local executable = output_dir .. "/" .. vim.fn.fnamemodify(filename, ":t:r")

		-- Construye el comando de compilación
		local compile_command = "clang++ --debug " .. filename .. " -o " .. executable

		-- Ejecuta el comando de compilación
		vim.cmd("!" .. compile_command)
	else
		print("No es un archivo .cpp")
	end
end

-- Función para compilar y ejecutar archivos C++
local function compile_and_run_cpp()
	-- Obtén el nombre completo del archivo actual
	local filename = vim.api.nvim_buf_get_name(0)

	-- Verifica que la extensión sea .cpp
	if filename:match("%.cpp$") then
		-- Obtén el directorio del archivo actual
		local file_dir = vim.fn.fnamemodify(filename, ":h")

		-- Construye el directorio de salida para los ejecutables
		local output_dir = file_dir .. "/bin"

		-- Crea el directorio si no existe
		vim.fn.mkdir(output_dir, "p")

		-- Construye el nombre del archivo ejecutable (sin extensión) y su ruta
		local executable = output_dir .. "/" .. vim.fn.fnamemodify(filename, ":t:r")

		-- Construye el comando de compilación
		local compile_command = "clang++ --debug " .. filename .. " -o " .. executable

		-- Compilar el archivo
		vim.cmd("!" .. compile_command)

		-- Abre una terminal dentro de Neovim, cambia al directorio y ejecuta el archivo
		vim.cmd("split | terminal cd " .. output_dir .. " && ./" .. vim.fn.fnamemodify(filename, ":t:r"))
	else
		print("No es un archivo .cpp")
	end
end

-- Función para ejecutar el archivo compilado
local function execute_cpp()
	-- Obtén el nombre completo del archivo actual
	local filename = vim.api.nvim_buf_get_name(0)

	-- Verifica que la extensión sea .cpp
	if filename:match("%.cpp$") then
		-- Obtén el directorio del archivo actual
		local file_dir = vim.fn.fnamemodify(filename, ":h")

		-- Construye el directorio de salida para los ejecutables
		local output_dir = file_dir .. "/bin"

		-- Construye el nombre del archivo ejecutable (sin extensión) y su ruta
		local executable = output_dir .. "/" .. vim.fn.fnamemodify(filename, ":t:r")

		-- Verifica si el archivo ejecutable existe
		if vim.fn.filereadable(executable) == 1 then
			-- Cierra todas las ventanas de terminal abiertas en el buffer actual
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local buf_filetype = vim.api.nvim_buf_get_option(buf, "filetype")
				if buf_filetype == "terminal" then
					vim.api.nvim_win_close(win, true)
				end
			end

			-- Abre una nueva terminal dentro de Neovim, cambia al directorio y ejecuta el archivo
			vim.cmd("split | terminal cd " .. output_dir .. " && ./" .. vim.fn.fnamemodify(filename, ":t:r"))
		else
			-- Notifica al usuario si el archivo no se encuentra
			print("No se encontró el archivo ejecutable: " .. executable)
		end
	else
		print("No es un archivo .cpp")
	end
end

-- Funcion para compilar varios archivos a la vez, solo si hay carpeta de lib e include
local function compileFilesAndRunCpp()
	-- Obtener el nombre completo del archivo actual
	local filename = vim.api.nvim_buf_get_name(0)

	-- Verificar que la extensión sea .cpp
	if not filename:match("%.cpp$") then
		print("No es un archivo .cpp")
		return
	end

	-- Obtener el directorio del archivo actual
	local file_dir = vim.fn.fnamemodify(filename, ":h")

	-- Definir las rutas para include, lib y bin
	local include_dir = file_dir .. "/include"
	local lib_dir = file_dir .. "/lib"
	local bin_dir = file_dir .. "/bin"

	-- Verificar si include/ y lib/ existen
	local include_exists = vim.fn.isdirectory(include_dir) == 1
	local lib_exists = vim.fn.isdirectory(lib_dir) == 1

	-- Definir cómo buscar los archivos .cpp
	local cpp_files = ""

	if lib_exists then
		-- Obtener todos los archivos .cpp en lib/
		local lib_cpp = vim.fn.glob(lib_dir .. "/*.cpp")
		-- Añadir el archivo principal (herenciaAnimales.cpp)
		cpp_files = lib_cpp .. " " .. filename
	else
		-- Si no existe lib/, buscar en el directorio actual
		cpp_files = vim.fn.glob(file_dir .. "/*.cpp")
	end

	-- Verificar si se encontraron archivos .cpp
	if cpp_files == "" then
		print("No se encontraron archivos .cpp para compilar.")
		return
	end

	-- Crear el directorio bin/ si no existe
	vim.fn.mkdir(bin_dir, "p")

	-- Definir el nombre del ejecutable
	local executable_name = vim.fn.fnamemodify(filename, ":t:r")
	local executable = bin_dir .. "/" .. executable_name

	-- Construir el comando de compilación
	local compile_command = "g++ --debug " .. cpp_files .. " -I " .. include_dir .. " -o " .. executable

	-- Si include/ no existe, eliminar la opción -I
	if not include_exists then
		compile_command = "clang++ --debug " .. cpp_files .. " -o " .. executable
	end

	-- Imprimir el comando para depuración
	print("Compilando con el siguiente comando:")
	print(compile_command)

	-- Ejecutar el comando de compilación
	local compile_output = vim.fn.system(compile_command)

	-- Verificar si hubo errores de compilación
	if vim.v.shell_error ~= 0 then
		print("Error durante la compilación:")
		print(compile_output)
		return
	end

	-- Verificar si el ejecutable se creó correctamente
	if vim.fn.filereadable(executable) == 0 then
		print("El ejecutable no se creó correctamente.")
		return
	end

	-- Ejecutar el ejecutable en una terminal dentro de Neovim
	vim.cmd("! split | terminal cd " .. bin_dir .. " && ./" .. executable_name)
end

-- Crear comandos :CompileCpp y :CompileAndRunCpp en Neovim
vim.api.nvim_create_user_command("CompileCpp", compile_cpp, { desc = "Compile C++ files" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>cc",
	":CompileCpp<CR>",
	{ noremap = true, silent = true, desc = "Compile C++ files" }
)

vim.api.nvim_create_user_command("CompileAndRunCpp", compile_and_run_cpp, { desc = "Compile and run C++ files" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>cr",
	":CompileAndRunCpp<CR>",
	{ noremap = true, silent = true, desc = "Compile and run C++ files" }
)

-- Crear el comando :ExecuteCpp en Neovim
vim.api.nvim_create_user_command("ExecuteCpp", execute_cpp, { desc = "Execute compiled C++ files" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>ra",
	":ExecuteCpp<CR>",
	{ noremap = true, silent = true, desc = "Compile and run C++ files" }
)

-- Crear el comando :ExecuteCpp en Neovim
vim.api.nvim_create_user_command(
	"CompileFilesCppAndRun",
	compileFilesAndRunCpp,
	{ desc = "Execute compiled C++ files" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>cfr",
	"<cmd>CompileFilesCppAndRun<CR>",
	{ noremap = true, silent = true, desc = "Compile and run C++ files" }
)
