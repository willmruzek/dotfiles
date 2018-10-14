" execute pathogen#infect()



syntax on
filetype plugin indent on

" Set Proper Tabs
set tabstop=1
set shiftwidth=4
set smarttab
set expandtab

" OSX stupid backspace fix
set backspace=indent,eol,start

" Show linenumbers
set number
set ruler

" Highlight current line
set cursorline

" set wildmenu
"set showcmd
"set tabstop=4
"set showmatch
"set updatetime=100
"set signcolumn=yes

" Use base16 color scheme
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
