return{
  'niuiic/code-shot.nvim',
  dependencies = { 'niuiic/core.nvim' },
  config = function()
    local code = require("code-shot")
    vim.keymap.set("n", "<leader>cs", code.shot)
    vim.keymap.set("v", "<leader>cs", code.shot)
  end
}
