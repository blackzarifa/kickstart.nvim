return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  keys = {
    { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Toggle pin' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Delete other buffers' },
    { '<leader>bd', '<cmd>BufferLinePickClose<cr>', desc = 'Pick buffer to delete' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
  },
  opts = {
    options = {
      mode = 'buffers',
      diagnostics = 'nvim_lsp',
      separator_style = 'thin',
      show_tab_indicators = true,
      always_show_bufferline = true,
    },
  },
  init = function()
    require('which-key').add {
      { '<leader>b', group = 'Buffer' },
      { '<leader>b_', hidden = true },
    }
  end,
}
