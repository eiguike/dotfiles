set nocompatible

syntax enable
filetype off

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'mileszs/ack.vim'
Plug 'https://github.com/terryma/vim-multiple-cursors.git'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/ludovicchabant/vim-gutentags.git'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

" fzf plugins
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Javascript plugins
Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
filetype plugin indent on

set path+=**
set wildmenu

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
let g:NERDTreeDirArrows=0

set encoding=utf-8

set number

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab " idents as spaces
set tags+=./tags;
" set tags+=~/go/src/tags
set nowrap
set hlsearch

map <Leader>r :NERDTreeFind<CR>
map <Leader>n :NERDTreeToggle<CR>
nnoremap <leader>m :CtrlPTag<cr>

" Clipboard for Mac OS X
set clipboard+=unnamedplus

set runtimepath^=~/.vim/bundle/ctrlp.vim

nnoremap <C-p> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>
