return {
  { 'williamboman/mason.nvim', config = true },

  -- Mason-lspconfig: Bridges Mason with Neovim's LSP
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        -- List of LSPs to automatically install
        ensure_installed = {
          'ts_ls', -- TypeScript
          'lua_ls', -- Lua
          'cssls', -- CSS
          'html', -- HTML
          'jsonls', -- JSON
          'emmet_ls', -- Emmet
          -- Framework LSPs
          'volar', -- Vue
          'svelte', -- Svelte
        },
        automatic_installation = true,
      }
    end,
  },

  -- nvim-cmp: Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'hrsh7th/cmp-path', -- Filesystem paths
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        mapping = cmp.mapping.preset.insert {
          -- Scroll up/down in the documentation window
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),

          -- Complete with Enter
          ['<CR>'] = cmp.mapping.confirm { select = true },

          -- Navigate the completion menu
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Trigger completion menu
          ['<C-Space>'] = cmp.mapping.complete(),

          -- Use Tab for both completion and jumping
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Plugin for showing LSP progress
  {
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    'j-hui/fidget.nvim',
    opts = {},
  },

  -- Automatically installs LSP server and tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers or {}),
      }
    end,
  },

  -- The main LSP config
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- LSP servers configuration
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        -- TypeScript config with inlay hints
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
          },
        },
        volar = {
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
        },
        svelte = {},
        cssls = {},
        html = {},
        jsonls = {},
        emmet_ls = {},
      }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lspconfig[server_name].setup(server)
          end,
        },
      }

      -- Setup keybindings when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings
          local opts = { buffer = ev.buf }

          -- See `:help vim.lsp.*` for documentation on any of these functions
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

          -- Toggle inlay hints for supported languages
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.supports_method 'textDocument/inlayHint' then
            vim.keymap.set('n', '<leader>ch', function()
              vim.lsp.inlay_hint.enable(ev.buf, not vim.lsp.inlay_hint.is_enabled(ev.buf))
            end, opts)
          end
        end,
      })

      -- Initialize all servers with their configurations
      for server, config in pairs(servers) do
        lspconfig[server].setup(config)
      end
    end,
  },
}
