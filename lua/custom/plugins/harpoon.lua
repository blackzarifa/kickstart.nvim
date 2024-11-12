return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- Harpoon 2 setup with default configurations
    harpoon:setup()

    -- Command-line interface configuration
    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():append()
    end, { desc = 'Add file to Harpoon' })
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle Harpoon quick menu' })

    -- Navigation configuration
    vim.keymap.set('n', '<C-h>', function()
      harpoon:list():select(1)
    end, { desc = 'Navigate to Harpoon file 1' })
    vim.keymap.set('n', '<C-j>', function()
      harpoon:list():select(2)
    end, { desc = 'Navigate to Harpoon file 2' })
    vim.keymap.set('n', '<C-k>', function()
      harpoon:list():select(3)
    end, { desc = 'Navigate to Harpoon file 3' })
    vim.keymap.set('n', '<C-l>', function()
      harpoon:list():select(4)
    end, { desc = 'Navigate to Harpoon file 4' })

    -- Optional: Prev/Next navigation
    vim.keymap.set('n', '<C-S-P>', function()
      harpoon:list():prev()
    end, { desc = 'Navigate to previous Harpoon file' })
    vim.keymap.set('n', '<C-S-N>', function()
      harpoon:list():next()
    end, { desc = 'Navigate to next Harpoon file' })
  end,
}
