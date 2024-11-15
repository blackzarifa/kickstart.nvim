return {
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
      -- Git grouping
      require('which-key').add {
        { '<leader>G', group = 'Git' },
      }
      -- Git interface synchronization protocols
      local keymap = vim.keymap.set
      keymap('n', '<leader>Gs', vim.cmd.Git, { desc = 'Git Status' })
      keymap('n', '<leader>Gc', function()
        vim.cmd 'Git commit'
      end, { desc = 'Git Commit' })
      keymap('n', '<leader>Gp', function()
        vim.cmd 'Git push'
      end, { desc = 'Git Push' })
      keymap('n', '<leader>Gl', function()
        vim.cmd 'Git pull'
      end, { desc = 'Git Pu[L]l' })
      keymap('n', '<leader>Gb', function()
        vim.cmd 'Git blame'
      end, { desc = 'Git Blame' })
    end,
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = 'diff2_horizontal',
            winbar_info = true,
          },
          merge_tool = {
            layout = 'diff3_horizontal',
            disable_diagnostics = true,
          },
        },
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
          end,
        },
      }

      -- Temporal modification interface
      local keymap = vim.keymap.set
      keymap('n', '<leader>Gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git Diff View' })
      keymap('n', '<leader>Gh', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git History' })
      keymap('n', '<leader>Gq', '<cmd>DiffviewClose<cr>', { desc = 'Git Diff Quit' })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▁' },
        topdelete = { text = '▔' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 200,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation protocols
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Next hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Previous hunk' })

        -- Data manipulation interfaces
        map('n', '<leader>Hs', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>Hr', gs.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>Hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage hunk' })
        map('v', '<leader>Hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset hunk' })
        map('n', '<leader>HS', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>Hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>HR', gs.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>Hp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>Hb', function()
          gs.blame_line { full = true }
        end, { desc = 'Blame line' })
        map('n', '<leader>HB', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
        map('n', '<leader>Hd', gs.diffthis, { desc = 'Diff this' })
        --[[ map('n', '<leader>HD', function()
          gs.diffthis '~'
        end, { desc = 'Diff this ~' }) ]]
        map('n', '<leader>HD', gs.toggle_deleted, { desc = 'Toggle deleted' })
      end,
    },
  },
  {
    'kdheepak/lazygit.nvim',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', '<leader>Gg', ':LazyGit<CR>', { desc = 'LazyGit' })
    end,
  },
}
