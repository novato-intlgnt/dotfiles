return{
  'otavioschwanck/tmux-awesome-manager.nvim',
  config = function ()
    local tmux = require("tmux-awesome-manager")
    tmux.setup({
      per_project_commands = { -- Configure your per project servers with
      -- project name = { { cmd, name } }
        api = { { cmd = 'rails server', name = 'Rails Server' } },
        front = { { cmd = 'yarn dev', name = 'react server' } },
      },
      session_name = 'Neovim Terminals',
      use_icon = false, -- use prefix icon
      icon = ' ', -- Prefix icon to use
      -- project_open_as = 'window', -- Open per_project_commands as.  Default: separated_session
      -- default_size = '30%', -- on panes, the default size
      -- open_new_as = 'window' -- open new command as.  options: pane, window, separated_session.
    })
    vim.keymap.set('v', '<leader>l', tmux.send_text_to, {}) -- Send text to a open terminal?
    vim.keymap.set('n', '<leader>lo', tmux.switch_orientation, {}) -- Open new panes as vertical / horizontal?
    vim.keymap.set('n', '<leader>lp', tmux.switch_open_as, {}) -- Open new terminals as panes or windows?
    vim.keymap.set('n', '<leader>lk', tmux.kill_all_terms, {}) -- Kill all open terms.
    vim.keymap.set('n', '<leader>l!', tmux.run_project_terms, {}) -- Run the per project commands
    vim.keymap.set('n', '<leader>lf', function() vim.cmd(":Telescope tmux-awesome-manager list_terms") end, {}) -- List all terminals
    vim.keymap.set('n', '<leader>ll', function() vim.cmd(":Telescope tmux-awesome-manager list_open_terms") end, {}) -- List open terminals
  end
}
