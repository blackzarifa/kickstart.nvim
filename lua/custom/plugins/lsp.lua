return {
  -- Mason: Our automated LSP acquisition protocol
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
          -- JavaScript/TypeScript ecosystem
          'ts_ls', -- TypeScript
          'volar', -- Vue
          'svelte', -- Svelte
          'eslint', -- Linting
          'tailwindcss', -- TailwindCSS
          'cssls', -- CSS
          'html', -- HTML
          'jsonls', -- JSON
          'emmet_ls', -- Emmet
        },
        automatic_installation = true,
      }
    end,
  },

  -- nvim-cmp: The completion testing protocol
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'

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
            fields = { 'kind', 'abbr', 'menu' },
            expandable_indicator = true,
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

      -- Diagnostic signs configuration
      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Global diagnostic configuration
      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
        },
      }

      -- Shared inlay hints configuration
      local inlay_hints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      }

      -- LSP servers configuration
      local servers = {
        -- TypeScript/JavaScript
        ts_ls = {
          settings = {
            typescript = {
              format = { indentSize = 2 },
              inlayHints = vim.tbl_extend('force', inlay_hints, {
                includeInlayEnumMemberValueHints = true,
              }),
            },
            javascript = {
              inlayHints = inlay_hints,
            },
          },
        },
      }

      -- Add simple servers
      local simple_servers = {
        'volar',
        'svelte',
        'tailwindcss',
        'cssls',
        'html',
        'jsonls',
        'emmet_ls',
      }
      for _, server in ipairs(simple_servers) do
        servers[server] = {}
      end

      -- Setup LSP keybindings
      local function setup_keymaps(ev)
        local opts = { buffer = ev.buf }
        local function open_url()
          local url = vim.fn.expand '<cWORD>'
          local open_cmd = {
            Linux = { 'xdg-open' },
            Darwin = { 'open' },
            Windows_NT = { 'cmd', '/c', 'start' },
          }
          local sys = vim.fn.has 'win32' and 'Windows_NT' or vim.fn.has 'macunix' and 'Darwin' or 'Linux'
          local cmd = open_cmd[sys]
          if cmd then
            table.insert(cmd, url)
            vim.fn.jobstart(cmd)
          end
        end
        -- LSP navigation
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

        -- URL opener
        vim.keymap.set('n', '<leader>u', open_url, vim.tbl_extend('force', opts, { desc = 'Open URL under cursor' }))
      end

      -- Register keymaps on LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = setup_keymaps,
      })

      -- Initialize all servers with capabilities
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end
    end,
  },
}
