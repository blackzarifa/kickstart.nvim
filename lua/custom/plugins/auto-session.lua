return {
  'rmagatti/auto-session',
  lazy = false,
  config = function()
    require('auto-session').setup {
      log_level = 'error',
      auto_session_suppress_dirs = { '~/', '~/Downloads', '/' },
      auto_session_use_git_branch = true,
      auto_session_enable_last_session = false,

      -- Customize session name
      auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
      auto_session_enabled = true,
      auto_session_create_enabled = true,

      -- Advanced options
      auto_restore_enabled = true,
      auto_save_enabled = true,
      auto_session_allow_dirs = {},

      pre_save_cmds = {},

      -- Custom session name formatting
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    }

    -- Register which-key group
    require('which-key').add {
      { '<leader>s', group = 'Session' },
    }

    -- Keymaps for session management
    vim.keymap.set('n', '<leader>ss', '<cmd>SessionSave<CR>', { desc = 'Save Session' })
    vim.keymap.set('n', '<leader>sd', '<cmd>SessionDelete<CR>', { desc = 'Delete Session' })
    vim.keymap.set('n', '<leader>sr', '<cmd>SessionRestore<CR>', { desc = 'Restore Session' })
    vim.keymap.set('n', '<leader>sf', '<cmd>SessionSearch<CR>', { desc = 'Find Session' })
  end,
}
