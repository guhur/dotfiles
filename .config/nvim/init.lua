-- Ensure lazy.nvim is installed and available
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.cmd([[
  set number
  set relativenumber
  set tabstop=4
  set shiftwidth=4
  set expandtab
  set mouse=a
]])

-- Filetype-specific settings
vim.cmd [[
  autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype javascriptreact setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype typescript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype typescriptreact setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype vue setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype jsx setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype php setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype css setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
]]

-- Set leader
vim.g.mapleader = ' '

-- Set encoding
vim.o.encoding = "UTF-8"

vim.g.python3_host_prog = '/opt/homebrew/bin/python3'

-- Lazy.nvim setup
require("lazy").setup({

  -- CoC for advanced IDE features and language server integration
  {
    "neoclide/coc.nvim",
    branch = "release"
  },

  -- Mason setup
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "eslint", "ruff" }
      })
    end
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- Define capabilities once for use by LSP servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Ruff native LSP setup
      require("lspconfig").ruff.setup({
        -- Setup for the new native 'ruff server'
        -- Based on latest migration guide
        on_attach = function(client, bufnr)
          -- Enable formatting
          if client.server_capabilities.documentFormattingProvider then
            -- Enable auto-formatting on save for Python files
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ 
                  bufnr = bufnr,
                  filter = function(c) return c.name == "ruff" end
                })
              end,
            })
          end
        end
      })

      -- Python LSP (pylsp) setup
      require("lspconfig").pylsp.setup({
        settings = {
          pylsp = {
            plugins = {
              mypy = {
                enabled = false,  -- Disabled to prevent duplicate mypy workers
              }
            }
          }
        }
      })

      -- TypeScript LSP setup (ts_ls)
      require("lspconfig").ts_ls.setup({
        capabilities = capabilities,
        on_attach = function(client)
          -- Disable formatting in the LSP since we're using direct prettier
          client.server_capabilities.documentFormattingProvider = false
        end,
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
      })

      -- ESLint LSP setup
      require("lspconfig").eslint.setup({
        settings = {
          format = { enable = true },
          codeActionOnSave = {
            enable = true,
            mode = "all"
          },
        },
      })
    end
  },

  -- We're using direct system prettier for formatting TS/JS files instead of plugins

  -- NERDTree
  {
    'scrooloose/nerdtree',
    cmd = 'NERDTreeToggle',
  },
  
  -- Tmux integration
  'tmux-plugins/vim-tmux',
  
  -- Colorscheme
  'morhetz/gruvbox',
  
  -- Vim Airline
  'vim-airline/vim-airline',

  -- GitHub Copilot
  'github/copilot.vim',

  -- YankRing
  'vim-scripts/YankRing.vim',

  -- Surround plugin
  {
    'kylechui/nvim-surround',
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          normal = "ys",
          delete = "ds",
          change = "cs",
        }
      })
    end
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },

  -- Trouble for diagnostics
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- Web devicons
  'kyazdani42/nvim-web-devicons',

  {
    "hrsh7th/nvim-cmp", -- Completion Plugin
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP Completion
      "hrsh7th/cmp-buffer", -- Buffer Completion
      "hrsh7th/cmp-path", -- Path Completion
      "hrsh7th/cmp-cmdline", -- Command-line Completion
      "L3MON4D3/LuaSnip", -- Snippet Engine
      "saadparwaiz1/cmp_luasnip", -- Snippet Completion
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- Expand Snippets
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to accept suggestion
          ["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        }),
      })
    end
  },

})

-- Set colorscheme
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Create custom user command for direct Prettier formatting
vim.api.nvim_create_user_command("PrettierFormat", function()
  local file = vim.fn.expand("%:p")
  vim.fn.system({ "prettier", "--write", file })
  vim.cmd("edit") -- Reload the buffer
  print("Formatted with Prettier")
end, {})

-- Custom key mappings
vim.cmd [[
  " YankRing configuration
  nnoremap <silent> <F12> :YRShow<CR>

  " GitHub Copilot configuration
  let g:copilot_filetypes = { 'yaml': v:true, 'yml': v:true }
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true

  " Telescope key mappings
  nnoremap <leader><leader> <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>

  " NERDTree toggle
  map <F3> :NERDTreeToggle<CR>

  " Prettier format shortcut
  nnoremap <leader>pf :PrettierFormat<CR>
]]

-- LSP Keybindings
local opts = { noremap = true, silent = true }

-- Go to Definition
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

-- Go to Type Definition
vim.api.nvim_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

-- Go to Implementation
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

-- Find References
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

-- Hover Documentation
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

-- Signature Help (for function parameters)
vim.api.nvim_set_keymap("n", "<leader>sh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

-- Show Next/Previous Diagnostics
vim.api.nvim_set_keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

-- Format the Code
vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)

-- Rename Symbol
vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

-- Code Actions
vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
vim.api.nvim_set_keymap("v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)

-- Show Diagnostics in Floating Window
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

-- Restart LSP
vim.api.nvim_set_keymap("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

-- Autoformat on save for non-TS/JS files (TS/JS handled by prettier.nvim)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.css", "*.html", "*.json", "*.yaml", "*.yml" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Format TS/JS/Vue files with Prettier on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue" },
  callback = function()
    local file = vim.fn.expand("%:p")
    -- Format directly with system prettier command
    vim.fn.system({ "prettier", "--write", file })
    -- Reload the buffer to show changes
    vim.cmd("e")
  end,
})

-- Python-specific format on save (using CoC only, not LSP)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py" },
  callback = function()
    -- We're using CoC for Python formatting to prevent duplicate formatters
    vim.cmd("silent! CocCommand python.runLinting")
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false, -- Set to true if you want warnings while typing
  float = {
    source = "always", -- Show source of diagnostic (e.g., ESLint, Pyright)
  },
})

-- We're using CoC for mypy configuration instead of LSP/pylsp
