return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      opts = {
        -- Position and size
        position = {
          row = '50%',
          col = '50%',
        },
        size = {
          min_width = 60,
          width = 'auto',
          height = 'auto',
        },
        -- Appearance
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = 'Normal',
            FloatBorder = 'DiagnosticInfo',
          },
        },
        notify = {
          enabled = true,
          view = 'notify',
          opts = {
            timeout = 2000,
            render = 'minimal',
            stages = 'fade_in_slide_out',
            fps = 144,
            level = 2,
          },
        },
      },
      -- Custom icons for different command types
      icons = {
        ['/'] = { icon = ' ', hl_group = 'DiagnosticWarn' },
        ['?'] = { icon = ' ', hl_group = 'DiagnosticWarn' },
        [':'] = { icon = ' ', hl_group = 'DiagnosticInfo' },
      },
    },
    -- Enhanced search UI
    views = {
      mini = {
        win_options = {
          winblend = 0,
        },
      },
      cmdline_popup = {
        position = {
          row = '30%',
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = '42%',
          col = '50%',
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = 'Normal',
            FloatBorder = 'DiagnosticInfo',
          },
        },
      },
    },
    -- Prettier search messages
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = 'search_count',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
    },
    -- Message display settings
    messages = {
      enabled = true,
      view = 'notify',
      view_error = 'notify',
      view_warn = 'notify',
      view_history = 'messages',
      view_search = false, -- We'll handle search differently
    },
  },
  keys = {
    {
      '<leader>nl',
      function()
        require('noice').cmd 'last'
      end,
      desc = 'Noice Last Message',
    },
    {
      '<leader>nh',
      function()
        require('noice').cmd 'history'
      end,
      desc = 'Noice History',
    },
    {
      '<leader>na',
      function()
        require('noice').cmd 'all'
      end,
      desc = 'Noice All',
    },
    {
      '<leader>nd',
      function()
        require('noice').cmd 'dismiss'
      end,
      desc = 'Dismiss All',
    },
  },
}
