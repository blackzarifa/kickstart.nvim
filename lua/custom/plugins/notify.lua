return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
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
        require('telescope').extensions.notify.notify()
      end,
      desc = 'Show Notifications',
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
