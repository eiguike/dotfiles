set nocompatible

syntax enable
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'mileszs/ack.vim'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'git://github.com/terryma/vim-multiple-cursors.git'
Plugin 'git://github.com/scrooloose/nerdtree.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

call vundle#end()
filetype plugin indent on

set path+=**
set wildmenu

command! MakeTags !ctags -R .

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

set number

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab " idents as spaces
set tags+=./tags;
" set tags+=~/go/src/tags
set nowrap
set hlsearch

map <Leader>n :NERDTreeToggle<CR>

" Clipboard for Mac OS X
set clipboard=unnamed
