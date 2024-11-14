-- See `:help nvim-treesitter`

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  build = ':TSUpdate',
  config = function()
    -- [[ Configure Treesitter ]]
    -- See `:help nvim-treesitter`
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        -- Core languages
        'bash',
        'c',
        'diff',
        'lua',
        'luadoc',
        'vim',
        'vimdoc',

        -- Web development
        'html',
        'css',
        'javascript',
        'typescript',
        'tsx', -- TypeScript + JSX
        'svelte', -- Svelte framework
        'vue', -- Vue framework
        'scss', -- SCSS styling
        'styled', -- styled-components

        -- Documentation & Data
        'markdown',
        'markdown_inline',
        'json',
        'yaml',
      },

      -- Required fields for types
      modules = {},
      sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
      ignore_install = {}, -- List of parsers to ignore installing
      auto_install = true, -- Automatically install missing parsers when entering buffer

      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        additional_vim_regex_highlighting = { 'ruby' },
      },

      indent = {
        enable = true,
        disable = { 'ruby' },
      },

      -- [[ Textobject Configuration ]]
      -- See `:help nvim-treesitter-textobjects`
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer', -- Select around function
            ['if'] = '@function.inner', -- Select inside function
            ['ac'] = '@class.outer', -- Select around class
            ['ic'] = '@class.inner', -- Select inside class
            ['aa'] = '@parameter.outer', -- Select around parameter
            ['ia'] = '@parameter.inner', -- Select inside parameter
          },
        },

        -- Jump to next/previous start of textobject
        move = {
          enable = true,
          set_jumps = true, -- Whether to set jumps in the jumplist
          goto_next_start = {
            [']f'] = '@function.outer', -- Jump to next function
            [']c'] = '@class.outer', -- Jump to next class
          },
          goto_previous_start = {
            ['[f'] = '@function.outer', -- Jump to previous function
            ['[c'] = '@class.outer', -- Jump to previous class
          },
        },
      },
    }
  end,
}
