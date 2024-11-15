return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require 'nvim-autopairs'
      local Rule = require 'nvim-autopairs.rule'

      npairs.setup {
        check_ts = true, -- Use treesitter to check for pairs
        enable_check_bracket_line = true, -- Don't add pairs if it already has a close pair in the same line
        ignored_next_char = '[%w%.]', -- Will ignore alphanumeric and `.` symbol
        fast_wrap = {
          map = '<M-e>', -- Alt-e for fast wrap
          chars = { '{', '[', '(', '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey = 'Comment',
        },
      }

      -- Add spaces between parentheses
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' }, { '<', '>' } }
      npairs.add_rules {
        Rule(' ', ' '):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({
            brackets[1][1] .. brackets[1][2],
            brackets[2][1] .. brackets[2][2],
            brackets[3][1] .. brackets[3][2],
          }, pair)
        end),
      }
    end,
  },
}
