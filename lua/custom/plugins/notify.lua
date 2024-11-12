return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    require('which-key').add {
      { '<leader>n', group = 'Notifications' },
    }
  end,
  opts = {
    timeout = 2000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    render = 'minimal',
    stages = 'fade_in_slide_out',
    fps = 144,
  },
  keys = {
    {
      '<leader>nt',
      function()
        local actions = require 'telescope.actions'
        local action_state = require 'telescope.actions.state'

        local copy_notification = function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            local message = selection.value.message
            vim.fn.setreg('+', message)
            vim.notify('Notification copied to clipboard', vim.log.levels.INFO)
          end
        end

        require('telescope').extensions.notify.notify {
          layout_strategy = 'vertical',
          layout_config = {
            width = 0.6,
            height = 0.6,
          },
          initial_mode = 'normal',
          results_title = 'Notification History',
          sorting_strategy = 'descending',
          -- Press 'c' inside the telescope to copy the notification
          attach_mappings = function(_, map)
            map('n', 'c', copy_notification)
            return true
          end,
        }
      end,
      desc = 'Show Notifications (Telescope)',
    },
    {
      '<leader>nc',
      function()
        require('notify').dismiss { silent = true, pending = true }
      end,
      desc = 'Clear Notifications',
    },
  },
}
