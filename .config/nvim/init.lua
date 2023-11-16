
return require('packer').startup(function()
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
  use {'fannheyward/coc-pyright', run = 'yarn install --frozen-lockfile'}
  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use 'neoclide/coc-prettier'

  local home = vim.fn.expand("$HOME")
 -- use({
 --   "jackMort/ChatGPT.nvim",
 --     config = function()
 --       require("chatgpt").setup()
 --     end,
 --     requires = {
 --       "MunifTanjim/nui.nvim",
 --       "nvim-lua/plenary.nvim",
 --       "nvim-telescope/telescope.nvim"
 --     }
 -- })

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'neovim/nvim-lspconfig'
  use 'kyazdani42/nvim-web-devicons'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- set leader key to Space
  vim.g.mapleader = ' '
  
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

  " Configure ChatGPT
  " map <F4> :ChatGPTEditWithInstructions<CR>


  ]]
end)
