return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = {
      char = '│',
      tab_char = '⋅',
      highlight = 'IblIndent',
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
      injected_languages = true,
      highlight = 'IblScope',
      priority = 500,
      -- Include more scope types
      include = {
        node_type = {
          ['*'] = '*', -- This tells treesitter to highlight all scope types
        },
      },
    },
    whitespace = {
      remove_blankline_trail = true,
    },
    exclude = {
      filetypes = {
        'help',
        'dashboard',
        'lazy',
        'mason',
        'notify',
        'toggleterm',
      },
    },
  },
  config = function(_, opts)
    local hooks = require 'ibl.hooks'
    -- Set up scope handling
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

    require('ibl').setup(opts)

    vim.cmd [[
      highlight! link IblIndent NonText
      highlight! link IblScope CursorLineNr
    ]]
  end,
}
