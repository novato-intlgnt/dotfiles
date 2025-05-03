-- We define the leader map
vim.g.mapleader = " "
---Define the mapleader
local map = vim.keymap.set -- for conciseness
local vimmap = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }
-- This keybinding use JK as the scape key, to exit a mode
map({ "i", "v" }, "jk", "<ESC>", { desc = "Exit insert mode with jk" })
map({ "i", "v" }, "JK", "<ESC>", { desc = "Exit insert mode with JK" })
-- Change : to ; in normal mode

-- This keymap clears search
map("n", "<leader>ch", "<cmd>nohl<CR>", opts, { desc = "Clean the history search" })
map("n", "<leader>rr", "<cmd>source %<CR>", { desc = "Execute the current path" })

map("v", "<", "<gv", { desc = "After tab in re-select the same" })
map("v", ">", ">gv", { desc = "After tab out re-select the same" })

-- symbols to add undo points
local symbols = { ",", ".", "!", "?", "$", ">", "<" }
for _, symbol in pairs(symbols) do
	map("i", symbol, symbol .. "<C-g>u")
end

-- vimmap("n", ";", ":", { desc = "Enter command mode with ;" })
map("n", "n", "nzzzv", { desc = "Goes to the next result on the search and put the cursor in the middle" })
map("n", "N", "Nzzzv", { desc = "Goes to the prev result on the search and put the cursor in the middle" })

map("n", "<leader>x", "<cmd>!chmod +x %<CR>") -- Make a file executable
map("n", "<leader>nf", ":ene<CR>", opts)
-- Moves buffer
map("n", "<leader>k", ":bn<CR>", opts, { desc = "Move to the next buffer" })
map("n", "<leader>j", ":bp<CR>", opts, { desc = "Move to the previous buffer" }) -- previous buffer
map("n", "qa", ":bd!<CR>", opts, { desc = "Delete all buffers" }) -- Delete all Buffer actual
map("n", "<leader>q", ":bd<CR>", opts, { desc = "Delete the current buffer" }) -- Delete buffer actual

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { noremap = true }, { desc = "Increment number" }) -- increment
map("n", "<leader>-", "<C-x>", { noremap = true }, { desc = "Decrement number" }) -- decrement

-- window management
map("n", "<leader>sv", "<C-w>v", { noremap = true }, { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { noremap = true }, { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>se", "<C-w>=", { noremap = true }, { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "sj", "<C-w>j", { noremap = true }, { desc = "Move cursor to down split" }) -- Move cursor to down split
map("n", "sk", "<C-w>k", { noremap = true }, { desc = "Move cursor to up split" }) -- Move cursor to up split
map("n", "sh", "<C-w>h", { noremap = true }, { desc = "Move cursor to right split" }) -- Move cursor to right split
map("n", "sl", "<C-w>l", { noremap = true }, { desc = "Move cursor to left split" }) -- Move cursor to left split
map("n", "<leader>sx", "<cmd>close<CR>", { noremap = true }, { desc = "Close current split" }) -- close current split window

map("n", "<leader>to", "<cmd>tabnew<CR>", { noremap = true }, { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", { noremap = true }, { desc = "Close current tab" }) -- close current tab
map("n", "<leader>tn", "<cmd>tabnext<CR>", { noremap = true }, { desc = "Go to next tab" }) --  go to next tab
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { noremap = true }, { desc = "Go to previous tab" }) --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { noremap = true }, { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- SAVE config
map("n", "<C-s>", ":w<CR>", opts, { desc = "Save buffer" }) -- Save buffer
map("n", "<leader>sa", ":wa<CR>", opts, { desc = "Save all the open buffers" }) -- save all buffers open
map("n", "<C-x>", ":x<CR>", opts, { desc = "save and exit" }) -- save and exit
map("n", "<C-q>", ":q!<CR>", opts, { desc = "Exit without save Force!!!" }) -- Exit without save Force!!!

map("n", "<C-a>", "ggVG", { noremap = true }) -- Select all
map("n", "<leader><leader>", "<S-$>%", opts) -- Te lleva al final o el principio de llave relacionada {}[]()
map("n", "<leader>z", "<S-$>zf%", opts) -- para plegar codigo de manera sencilla, debes colocarte en el principo de la, llave {}[]() y listo, con za en modo normal vuelves a desplegar el codigo

-- join lines focus
map("n", "J", "mzJ`z")

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>")
map("t", "<C-w>h", "<C-\\><C-n><C-w>h")
map("t", "<C-w>j", "<C-\\><C-n><C-w>j")
map("t", "<C-w>k", "<C-\\><C-n><C-w>k")
map("t", "<C-w>l", "<C-\\><C-n><C-w>l")
vimmap("n", "<C-t>", "<cmd>split<CR>:term<CR>:resize 16<CR>", { silent = true }) -- Open the terminal
vimmap("v", "<C-t>", "<cmd>split<CR>:term<CR>:resize 16<CR>", { silent = true }) -- Open the terminal

-- quick env file edit
map("n", "<leader>en", ":vsp .env<CR>")

vimmap(
	"n",
	"<leader>cn",
	":Noice dismiss<CR>",
	{ noremap = true, silent = true, desc = "Clean the noice notifications" }
) -- Clean the noice notifications
