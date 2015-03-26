" Pathogen package manager
runtime bundle/vim-pathogen/autoload/pathogen.vim
silent! execute pathogen#infect()

" Solarized color scheme in ~/.vim/colors/solarized.vim
:syntax enable
:set background=dark
:colorscheme jellybeans

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

" Remap <leader>
:let mapleader=","

" Allow filetype-specific plugins
:filetype plugin on

" Read configurations from files
:set modeline
:set modelines=5

" NAVIGATION

" Disable arrow keys for navigation
:nnoremap <up> <nop>
:nnoremap <down> <nop>
:nnoremap <left> <nop>
:nnoremap <right> <nop>

" Make j and k move up and down better for wrapped lines
:noremap k gk
:noremap j gj
:noremap gk k
:noremap gj j

" Ctrl-<hjkl> to move windows
:noremap <C-h> <C-w>h
:noremap <C-j> <C-w>j
:noremap <C-k> <C-w>k
:noremap <C-l> <C-w>l

" Jumping between buffers
:noremap <C-n> :bnext<CR>
:noremap <C-p> :bprev<CR>
:noremap <C-e> :b#<CR>

" Show relative line numbers with <leader>l
:nmap <leader>l :setlocal relativenumber!<CR>:setlocal number!<CR>

" Improve search
:set ignorecase
:set smartcase
:set hlsearch

" Enable and disable search highlighting
:nmap <leader>q :set hlsearch!<CR>

" Turn off swap files
:set noswapfile
:set nobackup
:set nowritebackup

" Open new split panes to right and bottom
:set splitbelow
:set splitright

" allow hidden buffers
:set hidden

" always show the status bar
:set laststatus=2

" hide mode so it shows on the statusbar only
:set noshowmode

" short ttimeoutlen to lower latency to show current mode
:set ttimeoutlen=50

" Highlight current line
:set cursorline

" Highlight current column
:set cursorcolumn

" Consistent backspace on all systems
:set backspace=2

" Leave insert mode with jj
:inoremap jj <ESC>

" Clear trailing whitespace
:nnoremap <leader>W :%s/\s\+$//<CR><C-o>

" Toggle showing listchars
:nnoremap <leader><TAB> :set list!<CR>
if &encoding == "utf-8"
  exe "set listchars=eol:\u00ac,nbsp:\u2423,conceal:\u22ef,tab:\u25b8\u2014,precedes:\u2026,extends:\u2026"
else
  set listchars=eol:$,tab:>-,extends:>,precedes:<,conceal:+
endif

" Enable indent folding, but have it disabled by default
:set foldmethod=indent
:set foldlevel=99

" Space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" Select whole buffer
nnoremap vaa ggvGg_

" Uppercase typed word from insert mode
inoremap <C-u> <esc>mzgUiw`za

" Use braces to determine when to auto indent
:set smartindent

" Make Y act like D and C
nnoremap Y y$

" Unmap ex mode
nnoremap Q <nop>

" Special settings for some filetypes
:au Filetype ruby setl expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4
:au Filetype yaml setl expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4

" Use github-flavored markdown
:aug markdown
    :au!
    :au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
:aug END

" Open commonly edited files
:nmap <leader>ev :edit $MYVIMRC<CR>
:nmap <leader>et :edit $HOME/.tmux.conf<CR>
:nmap <leader>eb :edit $HOME/.bash_aliases<CR>
:nmap <leader>eg :edit $HOME/.gitaliases<CR>

" Reload vimrc
:nmap <leader>rv :source $MYVIMRC<CR>

" Close the current buffer
:nmap <leader>b :bd<CR>

" Use local config if it exists
if filereadable($HOME . "/.vimrc.local")
    source ~/.vimrc.local
endif

" CONFIGURE PLUGINS
" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'wombat'

" Tmuxline (Configures Tmux's statusbar to match Vim's)
let g:tmuxline_preset = 'full'

" taglist.vim
:nnoremap <leader>t :TlistToggle<CR>

" NERDTree
:nnoremap <leader>n :NERDTreeToggle<CR>

" CtrlP
:let g:ctrlp_map = '<leader>p'
