filetype off
if &compatible
  set nocompatible
endif
set runtimepath^=~/.vim//repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.cache/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('The-NERD-tree')
call dein#add('ShowMarks')
call dein#add('taglist.vim')
call dein#add('copypath.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/unite.vim')
call dein#add('hrp/EnhancedCommentify')
call dein#add('mattn/emmet-vim')
call dein#add('terryma/vim-multiple-cursors')
call dein#add('osyo-manga/vim-over')
call dein#add('Yggdroot/indentLine')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('majutsushi/tagbar')
call dein#add('joker1007/vim-markdown-quote-syntax')
call dein#add('tpope/vim-endwise')
call dein#add('tfnico/vim-gradle')
call dein#add('ekalinin/Dockerfile.vim')
call dein#add('udalov/kotlin-vim')
call dein#add('scrooloose/syntastic')
call dein#add('vim-scripts/ShowMarks')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

if dein#check_install()
  call dein#install()
endif

call dein#end()

filetype plugin indent on

