" Solarized color scheme in ~/.vim/colors/solarized.vim
:syntax enable
:set background=dark
:colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Match extra lines, spaces, and long lines like the following:
" Extra lines:


" Long lines:
"23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
" Lines ending with spaces:   
" Lines with spaces AND tabs:
    	"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight unneeded blank lines
:highlight BlankLines ctermbg=darkgreen guibg=darkgreen ctermfg=white 
:let w:m1=matchadd('BlankLines', '^$\n\{2,}')

" Highlight trailing whitespace and spaces before tabs
:highlight TrailingWhitespace ctermbg=darkred guibg=darkred ctermfg=white
:let w:m2=matchadd('TrailingWhitespace', '\s\+$\| \+\ze\t')

" Highlight lines longer than 80 characters
:highlight LongLines ctermbg=darkblue guibg=darkblue ctermfg=white
:let w:m3=matchadd('LongLines', '\%>80v.\+')

" Disable arrow keys for navigation
:nnoremap <up> <nop>
:nnoremap <down> <nop>
:nnoremap <left> <nop>
:nnoremap <right> <nop>

" Make j and k move up and down better
:nmap j gj
:nmap k gk

" Show line numbers with \l
:nmap \l :setlocal number!<CR>

" Improve search
:set incsearch
:set ignorecase
:set smartcase
:set hlsearch
:nmap \q :nohlsearch<CR>
:nmap \w :set hlsearch<CR>

