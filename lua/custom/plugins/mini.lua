-- Configuration for all mini.nvim modules
-- See: https://github.com/echasnovski/mini.nvim

return {
  -- Collection of various small independent plugins/modules
  {
    'echasnovski/mini.nvim',
    config = function()
      -- [[ Mini AI ]]
      -- Extend and create a/i textobjects
      -- See `:help mini.ai`
      -- Note: We disable some textobjects to prevent conflicts with nvim-treesitter
      require('mini.ai').setup {
        custom_textobjects = {
          f = false, -- Disable mini.ai function textobject
          c = false, -- Disable mini.ai class textobject
        },
        n_lines = 500,
      }

      -- [[ Mini Surround ]]
      -- Adds, deletes, and replaces surroundings (brackets, quotes, etc.)
      -- See `:help mini.surround`
      --
      -- Operation examples:
      -- - saiw)  - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'    - [S]urround [D]elete [']quotes
      -- - sr)'   - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- [[ Mini Statusline ]]
      -- Simple and easy statusline
      -- See `:help mini.statusline`
      local statusline = require 'mini.statusline'

      -- Configure statusline with proper icon support
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
      }

      -- Custom statusline section configuration
      -- Set the cursor location to show as LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- [[ Additional Mini Modules ]]
      -- Mini.nvim comes with many other modules you can enable:
      -- - mini.animate   - Animations for common actions
      -- - mini.bufremove - Buffer removing while preserving layout
      -- - mini.comment   - Fast commenting
      -- - mini.indentscope - Show scope by indent
      -- - mini.pairs     - Auto-pairing brackets and quotes
      -- And many more! Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
