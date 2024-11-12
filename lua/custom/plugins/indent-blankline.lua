return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = {
      char = '│', -- Classic indent line
      tab_char = '▸', -- More visible tab character (or try: '⟩', '▹', '⍈', '⊳')
      highlight = 'IblIndent',
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
      injected_languages = true,
      highlight = 'IblScope',
      priority = 500,
      include = {
        node_type = {
          ['*'] = '*',
        },
      },
    },
    whitespace = {
      -- Show trailing whitespace characters
      highlight = 'IblWhitespace',
      remove_blankline_trail = false, -- Set to false to show trailing spaces
    },
    exclude = {
      filetypes = {
        'help',
        'dashboard',
        'lazy',
        'mason',
        'notify',
        'toggleterm',
        'alpha', -- dashboard plugin
        'oil', -- file explorer
      },
    },
  },
  config = function(_, opts)
    local hooks = require 'ibl.hooks'
    -- Enhanced scope highlighting
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

    -- Show whitespace characters in a subtle way
    vim.opt.list = true
    vim.opt.listchars:append {
      tab = '▸ ', -- Match the tab_char style
      trail = '•', -- Bullet for trailing spaces
    }

    require('ibl').setup(opts)

    -- Enhanced highlighting
    vim.cmd [[
      highlight! link IblIndent NonText
      highlight! link IblScope CursorLineNr
      highlight! IblWhitespace guifg=#585858 gui=nocombine
    ]]
  end,
}
