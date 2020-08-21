set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
" Bundle 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'preservim/nerdcommenter'

" Colorschemes
Plugin 'morhetz/gruvbox'
Plugin 'whatyouhide/vim-gotham'
Bundle 'chase/focuspoint-vim'
Plugin 'kaicataldo/material.vim'
Plugin 'mhartington/oceanic-next'
" ..."

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Colorschemes
syntax enable

set term=xterm-256color
if (has("termguicolors"))
  set termguicolors
endif

let g:lightline = {'colorscheme': 'OceanicNext'}
colorscheme Material

let g:NERDSpaceDelims = 1

" Enable folding
set foldmethod=indent
set foldlevel=99

nnoremap <space> za

" PEP8
set encoding=utf-8
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_use_clangd = 0

" Syntax
let python_highlight_all=1
syntax on

" NerdTree
let NERDTreeIgnore=['\.pyc$', '\.DS_Store']
autocmd vimenter * NERDTree
nnoremap <C-o> :NERDTreeToggle<enter>

set nu
set clipboard=unnamed
set splitbelow
set splitright
set updatetime=250

" Wrap guides
set colorcolumn=80,100
set colorcolumn=100
highlight ColorColumn guibg=red

" Keybindings

" move between panes
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" move between panes
nnoremap <S-Up> <C-W>+
nnoremap <S-Down> <C-W>-
nnoremap <S-Left> <C-W><
nnoremap <S-Right> <C-W>>
" Create and destroy panes
nnoremap S :w<enter>
nnoremap s :split<enter>
nnoremap V :vsplit<enter>
nnoremap x :q<enter>
nnoremap X :q!<enter>
" Undo and redo
nnoremap <S-h> u
nnoremap <S-L> <C-R>
nnoremap <C-s> :w<enter>
