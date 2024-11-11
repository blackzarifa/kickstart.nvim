return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'ts_ls',
          'volar',
          'svelte',
          'eslint',
          'tailwindcss',
          'cssls',
          'html',
          'jsonls',
          'emmet_ls',
        },
        automatic_installation = true,
      }
    end,
  },

  -- nvim-cmp: The completion testing protocol
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip', -- Snippet engine
      'saadparwaiz1/cmp_luasnip', -- Snippet completion source
      'hrsh7th/cmp-nvim-lsp', -- LSP completion
      'hrsh7th/cmp-buffer', -- Buffer completion
      'hrsh7th/cmp-path', -- Path completion
      'rafamadriz/friendly-snippets', -- Snippet collection
      'onsails/lspkind.nvim', -- VSCode-like pictograms
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'

      -- Load friendly snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
          },
        },
      }
    end,
  },

  -- LSP Configuration and Management
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require 'lspconfig'

      -- Diagnostic signs
      local signs = {
        Error = ' ',
        Warn = ' ',
        Hint = ' ',
        Info = ' ',
      }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Diagnostic configuration
      vim.diagnostic.config {
        virtual_text = true, -- Show diagnostics beside code
        signs = true, -- Show signs in the gutter
        update_in_insert = false, -- Don't update diagnostics in insert mode
        underline = true, -- Underline problematic code
        severity_sort = true, -- Sort diagnostics by severity
        float = {
          border = 'rounded',
          source = 'always',
        },
      }

      -- LSP servers configuration
      local servers = {
        -- TypeScript/JavaScript
        tsserver = {
          -- Disable tsserver if typescript-tools is available
          autostart = false,
        },
        -- TypeScript Tools (modern replacement for tsserver)
        typescript = {},
        -- Vue
        volar = {},
        -- Svelte
        svelte = {},
        -- ESLint
        eslint = {
          on_attach = function(client, bufnr)
            -- Enable formatting
            client.server_capabilities.documentFormattingProvider = true
            -- Auto-fix on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
        },
        -- TailwindCSS
        tailwindcss = {},
        -- CSS
        cssls = {},
        -- HTML
        html = {},
        -- JSON
        jsonls = {},
        -- Emmet
        emmet_ls = {},
      }

      -- Setup LSP key bindings
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
          -- Diagnostic navigation
          vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

          -- Add URL opener
          vim.keymap.set('n', '<leader>u', function()
            local url = vim.fn.expand '<cWORD>' -- Get word under cursor
            vim.fn.jobstart { 'xdg-open', url } -- Linux
            -- vim.fn.jobstart({"open", url})     -- macOS
            -- vim.fn.jobstart({"cmd", "/c", "start", url})  -- Windows
          end, { buffer = ev.buf, desc = 'Open URL under cursor' })
        end,
      })

      -- Initialize servers
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end
    end,
  },
}
