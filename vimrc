" Pathogen package manager
runtime bundle/vim-pathogen/autoload/pathogen.vim
silent! execute pathogen#infect()

" Solarized color scheme in ~/.vim/colors/solarized.vim
:syntax enable
:set background=dark
:colorscheme solarized

" Set background and font in gVim
if has("gui_running")
  set background=light
  if has("gui_gtk2")
    set guifont=Inconsolata\ 11
  elseif has("gui_win32")
    set guifont=Consolas:h10:cANSI
  endif
endif

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
:highlight TrailingWhitespace ctermbg=darkred guibg=darkred
:let w:m2=matchadd('TrailingWhitespace', '\s\+$\| \+\ze\t')

" Highlight the 80th column
if exists('+colorcolumn')
  :au BufWinEnter *.c,*.h,*.cpp set colorcolumn=80
else
  :highlight LongLines ctermbg=darkblue guibg=darkblue ctermfg=white
  :au BufWinEnter *.c,*.h,*.cpp let w:m3=matchadd('LongLines', '\%80v', -1)
endif

" Allow filetype-specific plugins
:filetype plugin on

" Disable arrow keys for navigation
:nnoremap <up> <nop>
:nnoremap <down> <nop>
:nnoremap <left> <nop>
:nnoremap <right> <nop>

" Make j and k move up and down better
:nmap j gj
:nmap k gk

" Remap <leader>
:let mapleader=","

" Show relative line numbers with <leader>l
:nmap <leader>l :setlocal relativenumber!<CR>

" Improve search
:set ignorecase
:set smartcase
:set hlsearch

" Enable and disable search highlighting
:nmap <leader>q :set hlsearch!<CR>

" Open new split panes to right and bottom
:set splitbelow
:set splitright

" allow hidden buffers
:set hidden

" Ctrl-<hjkl> to move windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" always show the status bar
:set laststatus=2

" hide mode so it shows on the statusbar only
:set noshowmode

" short ttimeoutlen to lower latency to show current mode
:set ttimeoutlen=50

" Highlight current line
:set cursorline

" Consistent backspace on all systems
:set backspace=2

" Leave insert mode with jj
:inoremap jj <ESC>

" Clear trailing whitespace
:nnoremap <leader>W :%s/\s\+$//<CR>

" Toggle showing listchars
:nnoremap <leader><TAB> :set list!<CR>
if &encoding == "utf-8"
  exe "set listchars=eol:\u00ac,nbsp:\u2423,conceal:\u22ef,tab:\u25b8\u2014,precedes:\u2026,extends:\u2026"
else
  set listchars=eol:$,tab:>-,extends:>,precedes:<,conceal:+
endif

" Enable syntax folding, but have it disabled by default
:set foldmethod=syntax
:set foldlevel=99

" Open vimrc
:nmap <leader>v :edit $MYVIMRC<CR>

" Use local config if it exists
if filereadable($HOME . "/.vimrc.local")
    source ~/.vimrc.local
endif

" Configure plugins
let g:airline_powerline_fonts = 1
let g:airline_theme = 'wombat'
let g:tmuxline_preset = 'full'
