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

-- Lazy.nvim setup
require("lazy").setup({

   -- Mason setup
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  
  -- Note: mason-lspconfig.nvim was removed due to compatibility issues
  -- Install LSP servers manually with :Mason and then search for:
  -- typescript-language-server, eslint-lsp, ruff, pyright

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = { "williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      -- Set up lspconfig with nvim-cmp capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Ruff LSP setup
      require("lspconfig").ruff.setup({
        capabilities = capabilities
      })
      
      -- Pyright setup - using Ruff exclusively for linting, formatting, and organizing imports
      require("lspconfig").pyright.setup({
        capabilities = capabilities,
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { '*' },
            }
          }
        }
      })

      require("lspconfig").ts_ls.setup({
        capabilities = capabilities,
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
      })
      
      require("lspconfig").eslint.setup({
        capabilities = capabilities,
        settings = {
          format = { enable = true },
          codeActionOnSave = {
            enable = true,
            mode = "all"
          },
        },
      })
      
      -- Disable Ruff hover in favor of Pyright
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff',
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end
  },

})

-- Set colorscheme
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Create custom user commands for formatting
vim.api.nvim_create_user_command("PrettierFormat", function()
  local file = vim.fn.expand("%:p")
  local bufnr = vim.api.nvim_get_current_buf()
  
  vim.api.nvim_echo({{"Running Prettier...", ""}}, false, {})
  
  -- Run Prettier asynchronously
  vim.fn.jobstart({ "prettier", "--write", file }, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.api.nvim_echo({{"Prettier formatting failed", "ErrorMsg"}}, false, {})
      else
        vim.api.nvim_echo({{"Formatted with Prettier", ""}}, false, {})
      end
      
      -- Reload buffer if it's still valid
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.schedule(function()
          if vim.api.nvim_buf_is_loaded(bufnr) then
            vim.cmd("checktime")
          end
        end)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end, {})

vim.api.nvim_create_user_command("ESLintFix", function()
  local file = vim.fn.expand("%:p")
  local bufnr = vim.api.nvim_get_current_buf()
  
  vim.api.nvim_echo({{"Running ESLint fix...", ""}}, false, {})
  
  -- Run ESLint asynchronously
  vim.fn.jobstart({ "npx", "--no-install", "eslint", "--fix", file }, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.api.nvim_echo({{"ESLint fix failed - make sure project has ESLint installed", "ErrorMsg"}}, false, {})
      else
        vim.api.nvim_echo({{"Fixed with ESLint", ""}}, false, {})
      end
      
      -- Reload buffer if it's still valid
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.schedule(function()
          if vim.api.nvim_buf_is_loaded(bufnr) then
            vim.cmd("checktime")
          end
        end)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end, {})

vim.api.nvim_create_user_command("FormatTS", function()
  local file = vim.fn.expand("%:p")
  local bufnr = vim.api.nvim_get_current_buf()
  
  vim.api.nvim_echo({{"Formatting with Prettier and ESLint...", ""}}, false, {})
  
  -- Run prettier first, then ESLint
  vim.fn.jobstart({ "prettier", "--write", file }, {
    on_exit = function(_, prettier_code)
      -- Run ESLint after Prettier completes
      vim.fn.jobstart({ "npx", "--no-install", "eslint", "--fix", file }, {
        on_exit = function(_, eslint_code)
          if prettier_code ~= 0 and eslint_code ~= 0 then
            vim.api.nvim_echo({{"Formatting failed", "ErrorMsg"}}, false, {})
          elseif prettier_code ~= 0 then
            vim.api.nvim_echo({{"ESLint fix only (Prettier failed)", "WarningMsg"}}, false, {})
          elseif eslint_code ~= 0 then
            vim.api.nvim_echo({{"Formatted with Prettier only (ESLint failed)", "WarningMsg"}}, false, {})
          else
            vim.api.nvim_echo({{"Formatted with Prettier and ESLint", ""}}, false, {})
          end
          
          -- Reload buffer if it's still valid
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.schedule(function()
              if vim.api.nvim_buf_is_loaded(bufnr) then
                vim.cmd("checktime")
              end
            end)
          end
        end,
        stdout_buffered = true,
        stderr_buffered = true,
      })
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end, {})

-- Custom key mappings
vim.cmd [[
  " YankRing configuration
  nnoremap <silent> <F12> :YRShow<CR>

  " GitHub Copilot configuration
  let g:copilot_filetypes = { 'yaml': v:true, 'yml': v:true }
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  imap <silent><script><expr> <C-L> copilot#Next()
  imap <silent><script><expr> <C-H> copilot#Previous()
  let g:copilot_no_tab_map = v:true

  " Telescope key mappings
  nnoremap <leader><leader> <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>

  " NERDTree toggle
  map <F3> :NERDTreeToggle<CR>

  " Formatting shortcuts
  nnoremap <leader>pf :PrettierFormat<CR>
  nnoremap <leader>ef :ESLintFix<CR>
  nnoremap <leader>tf :FormatTS<CR>
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

-- Python specific commands
vim.api.nvim_set_keymap("n", "<leader>my", "<cmd>RunMypy<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rf", "<cmd>RuffFormat<CR>", opts)

-- Restart LSP
vim.api.nvim_set_keymap("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

-- Autoformat on save for non-TS/JS files (TS/JS handled by prettier.nvim)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.css", "*.html", "*.json", "*.yaml", "*.yml" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Format TS/JS/Vue files with Prettier & run ESLint fix asynchronously on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue" },
  callback = function()
    local file = vim.fn.expand("%:p")
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Run formatters asynchronously using vim.loop (libuv)
    vim.loop.new_timer():start(0, 0, vim.schedule_wrap(function()
      -- Run prettier in background
      vim.fn.jobstart({ "prettier", "--write", file }, {
        on_exit = function(_, code)
          if code ~= 0 then return end
          
          -- After prettier completes, run eslint in background
          vim.fn.jobstart({ "npx", "--no-install", "eslint", "--fix", file }, {
            on_exit = function(_, eslint_code)
              -- Only reload if buffer still exists and is for the same file
              if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) == file then
                vim.schedule(function()
                  -- Check if buffer is still loaded before reloading
                  if vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.cmd("checktime")
                  end
                end)
              end
            end,
            stdout_buffered = true,
            stderr_buffered = true,
          })
        end,
        stdout_buffered = true,
        stderr_buffered = true,
      })
    end))
  end,
})

-- Python-specific format on save (using builtin LSP formatter)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py" },
  callback = function()
    -- Let LSP handle formatting instead of direct command
    vim.lsp.buf.format({ 
      async = true,
      filter = function(client) 
        return client.name == "ruff" or client.name == "pylsp" 
      end
    })
    -- Don't run mypy on save for large projects to prevent multiple processes
  end,
})

-- Create Python formatting commands
vim.api.nvim_create_user_command("RuffFormat", function()
  vim.api.nvim_echo({{"Formatting with LSP...", ""}}, false, {})
  
  -- Use the LSP to format
  vim.lsp.buf.format({ 
    async = true,
    filter = function(client) 
      return client.name == "ruff" or client.name == "pylsp" 
    end,
    timeout_ms = 5000,
  })
  
  -- Provide feedback
  vim.defer_fn(function()
    vim.api.nvim_echo({{"Formatting complete", ""}}, false, {})
  end, 500)
end, {})

-- Run mypy only when manually triggered for large projects
vim.api.nvim_create_user_command("RunMypy", function()
  local file = vim.fn.expand("%:p")
  local bufnr = vim.api.nvim_get_current_buf()
  
  vim.api.nvim_echo({{"Running dmypy with uva...", ""}}, false, {})
  
  -- Run dmypy asynchronously using uva
  vim.fn.jobstart({ "uva", "dmypy", "run", "--", "." }, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.api.nvim_echo({{"Dmypy found type errors", "WarningMsg"}}, false, {})
      else
        vim.api.nvim_echo({{"Dmypy: No type errors found", ""}}, false, {})
      end
    end,
    on_stdout = function(_, data)
      if data and #data > 0 then
        -- Display dmypy output in quickfix
        local lines = {}
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(lines, line)
          end
        end
        if #lines > 0 then
          vim.schedule(function()
            vim.fn.setqflist({}, 'r', {
              title = 'Dmypy Results',
              lines = lines
            })
            vim.cmd("copen")
          end)
        end
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end, {})

-- Dmypy daemon management commands
vim.api.nvim_create_user_command("DmypyStart", function()
  vim.api.nvim_echo({{"Starting dmypy daemon...", ""}}, false, {})
  local error_lines = {}
  vim.fn.jobstart({ "uva", "dmypy", "start" }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.api.nvim_echo({{"Dmypy daemon started", ""}}, false, {})
      else
        vim.api.nvim_echo({{"Failed to start dmypy daemon", "ErrorMsg"}}, false, {})
        if #error_lines > 0 then
          vim.schedule(function()
            vim.api.nvim_echo({{table.concat(error_lines, "\n"), "ErrorMsg"}}, false, {})
          end)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(error_lines, line)
          end
        end
      end
    end,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            vim.schedule(function()
              vim.api.nvim_echo({{line, ""}}, false, {})
            end)
          end
        end
      end
    end,
    stderr_buffered = true,
    stdout_buffered = true,
  })
end, {})

vim.api.nvim_create_user_command("DmypyStop", function()
  vim.api.nvim_echo({{"Stopping dmypy daemon...", ""}}, false, {})
  local error_lines = {}
  vim.fn.jobstart({ "uva", "dmypy", "stop" }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.api.nvim_echo({{"Dmypy daemon stopped", ""}}, false, {})
      else
        vim.api.nvim_echo({{"Failed to stop dmypy daemon", "ErrorMsg"}}, false, {})
        if #error_lines > 0 then
          vim.schedule(function()
            vim.api.nvim_echo({{table.concat(error_lines, "\n"), "ErrorMsg"}}, false, {})
          end)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(error_lines, line)
          end
        end
      end
    end,
    stderr_buffered = true,
  })
end, {})

vim.api.nvim_create_user_command("DmypyRestart", function()
  vim.api.nvim_echo({{"Restarting dmypy daemon...", ""}}, false, {})
  local error_lines = {}
  vim.fn.jobstart({ "uva", "dmypy", "restart" }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.api.nvim_echo({{"Dmypy daemon restarted", ""}}, false, {})
      else
        vim.api.nvim_echo({{"Failed to restart dmypy daemon", "ErrorMsg"}}, false, {})
        if #error_lines > 0 then
          vim.schedule(function()
            vim.api.nvim_echo({{table.concat(error_lines, "\n"), "ErrorMsg"}}, false, {})
          end)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(error_lines, line)
          end
        end
      end
    end,
    stderr_buffered = true,
  })
end, {})

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
