set nocompatible              " required
filetype off                  " required
set relativenumber

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'davidhalter/jedi-vim'

if has('nvim')
  Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plugin 'Shougo/deoplete.nvim'
  Plugin 'roxma/nvim-yarp'
  Plugin 'roxma/vim-hug-neovim-rpc'
endif

Plugin 'dense-analysis/ale'
" Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'preservim/nerdcommenter'
Plugin 'ervandew/supertab'
Plugin 'mileszs/ack.vim'
Plugin 'ambv/black'
Plugin 'junegunn/goyo.vim'
Plugin 'cespare/vim-toml'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tmux-plugins/vim-tmux-focus-events'

" Colorschemes
" Plugin 'chriskempson/base16-vim'
Plugin 'morhetz/gruvbox'
Plugin 'whatyouhide/vim-gotham'
Bundle 'chase/focuspoint-vim'
Plugin 'kaicataldo/material.vim'
Plugin 'mhartington/oceanic-next'
" ..."

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let g:deoplete#enable_at_startup = 1
let g:jedi#completions_enabled = 1
autocmd FileType python setlocal completeopt-=preview

"" Colorschemes
syntax enable

set term=xterm-256color
if (has("termguicolors"))
  set termguicolors
endif

 let g:lightline = {
     \ 'active': {
     \   'left': [ [ 'mode', 'paste' ],
     \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
     \ },
     \ 'component_function': {
     \   'gitbranch': 'FugitiveHead'
     \ },
   \ }

" Spaces
let g:NERDSpaceDelims = 0
autocmd BufWritePre * %s/\s\+$//e

" Tmux
au FocusGained,BufEnter * :checktime

" Enable folding
set foldmethod=indent
set foldlevel=2

nnoremap <space> za

set nowrap

" Tabs and Spaces
set expandtab
set ts=4
autocmd FileType make setlocal noexpandtab  " Dont expand on makefiles
autocmd FileType sql setlocal ts=2
autocmd FileType json setlocal ts=2
autocmd FileType html setlocal ts=2

" PEP8
set encoding=utf-8
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=88 |
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
autocmd FileType python,sql setlocal colorcolumn=89
autocmd FileType tex setlocal colorcolumn=101
highlight ColorColumn guibg=red

set textwidth=0 wrapmargin=0
autocmd FileType tex setlocal textwidth=100

" Keybindings

" Tabs
nnoremap t :tabnew<enter>
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
nnoremap <S-u> <C-R>
nnoremap <C-s> :w<enter>

" Remove completion for SQL files
let g:omni_sql_no_default_maps = 1
let g:ftplugin_sql_omni_key = '<Leader>sql'
let g:ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'

" Delete, not cut
nnoremap d "_d
vnoremap d "_d
vnoremap p "_dP

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256          " Remove this line if not necessary
  source ~/.vimrc_background
endif
