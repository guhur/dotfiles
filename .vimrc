set nocompatible              " be iMproved, required
"filetype off                  " required
filetype indent plugin on
filetype plugin indent on    " required

let mapleader = " "
set mouse=a

set hidden

" Line numbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


" This script contains plugin specific settings
source ~/.vim/plugins.vim
" This script contains mappings
source ~/.vim/mapping.vim
" additional helper functions:
source ~/.vim/functions.vim
" For abbreviations read in the following file:
source ~/.vim/abbrev.vim


" Spell checking
" --------------
augroup spellFileExtension
  autocmd FileType latex,tex,md,markdown setlocal spell
  set spelllang=fr,en_us,en_gb
  inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
  hi clear SpellBad
  hi SpellBad cterm=underline
  " Set style for gVim
  hi SpellBad gui=undercurl
augroup END


autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4
autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype javascriptreact setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype jsx setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
