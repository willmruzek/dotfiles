execute pathogen#infect()

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

syntax on
filetype plugin indent on

set number
set cursorline
