return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  keys = {
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Terminal Float' },
    { '<leader>th', '<cmd>ToggleTerm size=15 direction=horizontal<cr>', desc = 'Terminal Horizontal' },
    { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Terminal Vertical' },
    { '<C-t>', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
  },
  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    open_mapping = [[<C-t>]],
    hide_numbers = true,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      winblend = 3,
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    require('which-key').add {
      { '<leader>t', group = 'Terminal' },
      { '<leader>t_', hidden = true },
    }
  end,
}
