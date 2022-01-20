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
Plugin 'heavenshell/vim-pydocstring', { 'do': 'make install' }
Plugin 'pseewald/vim-anyfold'
Plugin 'lepture/vim-jinja'
Plugin 'ryanoasis/vim-devicons'
Plugin 'jparise/vim-graphql'

" Colorschemes ==> Compatible with chromance
Plugin 'chriskempson/base16-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let g:deoplete#enable_at_startup = 1
let g:jedi#completions_enabled = 1
autocmd FileType python setlocal completeopt-=preview

"" ALE options
let g:ale_linters = {
\   'python': ['flake8', 'pylint', 'pyright', 'pydocstyle'],
\}
let g:ale_fixers = {
\   'python': ['black', 'isort', 'remove_trailing_lines', 'trim_whitespace'],
\}

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

" Chromance
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Spaces
let g:NERDSpaceDelims = 1
autocmd BufWritePre * %s/\s\+$//e
set backspace=indent,eol,start

" Tmux
au FocusGained,BufEnter * :checktime

" Enable folding, as stated on https://github.com/pseewald/vim-anyfold
filetype plugin indent on
syntax on
autocmd Filetype * AnyFoldActivate
set foldlevel=99 " Open all folds

nnoremap <space> za

set nowrap

" Tabs and Spaces
set expandtab
set ts=2
autocmd FileType make setlocal noexpandtab  " Dont expand on makefiles
autocmd FileType python setlocal ts=4

set encoding=utf-8
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
au BufNewFile,BufRead *.j2 set ft=jinja

" Syntax
let python_highlight_all=1
syntax on

" NerdTree
let NERDTreeIgnore=['\.pyc$', '\.DS_Store', '^__pycache__$']
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
autocmd FileType rst setlocal colorcolumn=101
highlight ColorColumn guibg=red

set textwidth=0 wrapmargin=0
autocmd FileType tex setlocal textwidth=100
autocmd FileType rst setlocal textwidth=100

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

" Pydocstring
let g:pydocstring_formatter = 'numpy'
let g:pydocstring_doq_path = '/usr/local/bin/doq'
let g:pydocstring_enable_mapping = 0
nmap <silent> <leader><C-d> <Plug>(pydocstring)
