set nocompatible

set expandtab
filetype plugin indent on
set tabstop=8
set shiftwidth=4
set expandtab
syntax on

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256
map <F2> :NERDTreeToggle <CR>
map <F3> :TagbarToggle <CR>
set number



" CursorLines

set cursorline
hi CursorLine   cterm=NONE ctermbg=darkgrey ctermfg=lightgrey
hi CursorLineNR cterm=bold


"hi clear CursorLine
"augroup CLClear
"    autocmd! ColorScheme * hi clear CursorLine
"augroup END

"hi CursorLineNR cterm=bold
"augroup CLNRSet
"    autocmd! ColorScheme * hi CursorLineNR cterm=bold
"augroup END
