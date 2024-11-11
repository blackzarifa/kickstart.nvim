return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      window = {
        position = 'right',
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          -- File operations
          ['a'] = {
            command = 'add',
            config = { show_path = 'relative' }, -- Adds new file/directory
          },
          ['d'] = 'delete', -- Delete file/directory
          ['r'] = 'rename', -- Rename file/directory
          ['y'] = 'copy_to_clipboard', -- Copy file path to clipboard
          ['x'] = 'cut_to_clipboard', -- Cut file/directory
          ['p'] = 'paste_from_clipboard', -- Paste from clipboard
          ['c'] = 'copy', -- Copy file to a new location
          ['m'] = 'move', -- Move file to a new location

          -- Navigation
          ['<cr>'] = 'open', -- Open file and close tree
          ['l'] = 'open', -- Alternative open
          ['<esc>'] = 'revert_preview', -- Close preview or clean up
          ['h'] = 'close_node', -- Close directory
          ['z'] = 'close_all_nodes', -- Close all directories
          ['R'] = 'refresh', -- Refresh the tree

          -- Filter and Search
          ['/'] = 'fuzzy_finder', -- Open fuzzy finder
          ['#'] = 'fuzzy_sorter', -- Open sorter
          ['f'] = 'filter_on_submit', -- Filter tree content
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true, -- Follow current file when opening new files
        },
        use_libuv_file_watcher = true, -- Use more efficient file watcher
        filtered_items = {
          hide_dotfiles = false, -- Show dotfiles
          hide_gitignored = false, -- Show gitignored files
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            -- Auto close when file is opened
            require('neo-tree.command').execute { action = 'close' }
          end,
        },
      },
    }
  end,
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Toggle Explorer' },
  },
}
