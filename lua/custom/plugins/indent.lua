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
    },
    whitespace = {
      remove_blankline_trail = true,
    },
  },
  config = function(_, opts)
    require('ibl').setup(opts)

    vim.cmd [[
            highlight! link IblIndent Comment
            highlight! link IblScope CursorLine
        ]]
  end,
}
