""""""""""""""""""""""""""""""""""""""""
" General configuration
""""""""""""""""""""""""""""""""""""""""

" Disable swp files
set noswapfile

" Enable persistent undo
set undofile

" Enable the mouse in the terminal
set mouse=a

" Share the system clipboard
set clipboard+=unnamedplus

" As recommended by `:help provider`, define a venv just for neovim that has
" the neovim module and some Python linters
let g:python_host_prog = $HOME . "/.nvim-venv2/bin/python2"
let g:python3_host_prog = $HOME . "/.nvim-venv/bin/python3"


""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""

" Plugin configuration
call plug#begin('~/.local/share/nvim/plugged')

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ryanoasis/vim-devicons'
Plug 'hoob3rt/lualine.nvim'

call plug#end()



""""""""""""""""""""""""""""""""""""""""
" UI
""""""""""""""""""""""""""""""""""""""""

" Show the executing command
set showcmd

" Have some context around the current line always on screen
set scrolloff=3
set sidescrolloff=5

" Try to display very long lines, rather than showing @
set display+=lastline

" show trailing whitespace as -, tabs as >-
set listchars=tab:>-,trail:-
set list

" Live substitution
set inccommand=split

if has("nvim")
  set laststatus=1
endif

""""""""""""""""""""""""""""""""""""""""
" Coding style
""""""""""""""""""""""""""""""""""""""""

" Tabs as two spaces
set tabstop=2
set shiftwidth=2
set expandtab

""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""

" change the leader key to space
let mapleader="\<Space>"

" Stop command window from popping u
map q: :q

" clear search highlighting with <space>,
nmap <leader>, <Plug>(LoupeClearHighlight)

" Quickly save, quit, or save-and-quit
map <leader>w :w<CR>
map <leader>x :x<CR>
map <leader>q :q<CR>

function ToggleRelativeLineNumbers()
  set invnumber
  set invrelativenumber
endfunction
nnoremap <leader>l :call ToggleRelativeLineNumbers()<cr>
