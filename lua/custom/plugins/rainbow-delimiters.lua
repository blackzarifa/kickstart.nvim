return {
  'HiPhish/rainbow-delimiters.nvim',
  event = 'BufReadPost',
  config = function()
    -- This uses tree-sitter as the source
    local rainbow_delimiters = require 'rainbow-delimiters'

    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rainbow_delimiters.strategy['global'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        jsx = 'rainbow-blocks',
        typescript = 'rainbow-delimiters-react',
      },
      priority = {
        [''] = 110,
        jsx = 120,
        tsx = 120,
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end,
}
