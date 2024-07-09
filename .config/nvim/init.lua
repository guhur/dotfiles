
return require('packer').startup(function()
  -- set leader key to Space
  vim.g.mapleader = ' '

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Vim plugins
  use {'scrooloose/nerdtree', on = 'NERDTreeToggle' }
  use 'tmux-plugins/vim-tmux'
  use 'morhetz/gruvbox'
  use 'vim-airline/vim-airline'
  use 'github/copilot.vim'
  use 'vim-scripts/YankRing.vim'
  -- Neovim plugins
  use {'neoclide/coc.nvim', branch = 'release'}
  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use 'neoclide/coc-prettier'

  local home = vim.fn.expand("$HOME")

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'neovim/nvim-lspconfig'
  -- Configure `ruff-lsp`.
  -- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
  -- For the default config, along with instructions on how to customize the settings
  require('lspconfig').ruff_lsp.setup {
    init_options = {
      settings = {
        -- Activate the fixer
        args = { '--fix' }
      }
    }
  }
  use 'kyazdani42/nvim-web-devicons'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- Configure ALE
  use 'dense-analysis/ale'
  vim.g.ale_linters = {
    python = {'mypy', 'flake8'}
  }
 vim.g.ale_python_flake8_options = '--max-line-length=89 --ignore=E265,E266,E501,E203,W503,E741'
  vim.g.ale_fixers = {
     python = {'black', 'autoimport', 'pycln', 'remove_trailing_lines', 'trim_whitespace'},
  }
  vim.g.ale_python_auto_poetry = 1
  vim.g.ale_fix_on_save = 1
  vim.cmd [[
    " Jump to the next error
    nnoremap <silent> <leader>n :ALENext<CR>
    " Jump to the previous error
    nnoremap <silent> <leader>p :ALEPrevious<CR>
    " Highlight errors with underlines
    " highlight ALEError textprop=underline
    " Displaying Errors in a Floating Window
    nnoremap <silent> <leader>e :lua vim.diagnostic.open_float(nil, {focus=false})<CR>
  ]]

  -- set mouse to scroll
  vim.o.mouse = 'a'
  
  -- set line numbers
  vim.wo.number = true
  
  -- set relative line numbers
  vim.wo.relativenumber = true

  -- set pasting from system clipboard
  -- vim.o.clipboard = 'unnamedplus'
  
  -- set tab width
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true
  
  -- but for typescript, javascript, vue, jsx, typescriptreact, javascriptreact, php, css, yaml, yml set tab width to 2
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
  
  -- set colorscheme
  vim.o.background = "dark" -- or "light" for light mode
  vim.cmd([[colorscheme gruvbox]])

  -- set encoding to UTF-8 (for devicons)
  vim.o.encoding = "UTF-8"
  
  -- set shortcut
  vim.cmd [[
  " Configure YankRing
  nnoremap <silent> <F12> :YRShow<CR>
  
  " Configure Github Copilot
  let g:copilot_filetypes = { 
  			\ 'yaml': v:true,
  			\ 'yml': v:true,
  			\ }
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true
  
  " Configure Telescope
  nnoremap <leader><leader> <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <leader><leader> <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

  " Configure NERDTree
  map <F3> :NERDTreeToggle<CR>

  " Configure Prettier
  map <F4> :CocCommand prettier.formatFile<CR>

  " Configure Coc Nvim
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  ]]
end)

