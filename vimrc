" Vim-Plug Plugins
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'bling/vim-bufferline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'fatih/vim-go'
let g:go_version_warning = 0
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jtratner/vim-flavored-markdown'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Alok/notational-fzf-vim'

" Themes
Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
call plug#end()

" Color scheme
:syntax enable
:set background=dark
:silent! colorscheme gruvbox

" Set background and font in gVim
if has("gui_running")
  set background=light
  if has("gui_gtk2")
    set guifont=Inconsolata\ 11
  elseif has("gui_win32")
    set guifont=Consolas:h10:cANSI
  endif
endif

" Use local config if it exists
if filereadable($HOME . "/.vimrc.local")
    source ~/.vimrc.local
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Match weird white space:
"   Lines ending with spaces:   
"   Lines with spaces AND tabs (in either order):
    	"
	    "

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight trailing whitespace and spaces touching tabs
:highlight TrailingWhitespace ctermbg=darkred guibg=darkred
:let w:m2=matchadd('TrailingWhitespace', '\s\+$\| \+\ze\t\|\t\+\ze ')

" Remap <leader>
:let mapleader="\<Space>"

" Allow filetype-specific plugins
:filetype plugin on

" Read configurations from files
:set modeline
:set modelines=5

" Setup tags file
:set tags=./tags,tags;

" Set path to include the cwd and everything underneath
:set path=**
:set wildmenu

" Show the normal mode command as I type it
:set showcmd

" NAVIGATION

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

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

" Ctrl-<hjkl> to change splits
:noremap <C-h> <C-w>h
:noremap <C-j> <C-w>j
:noremap <C-k> <C-w>k
:noremap <C-l> <C-w>l

" <Tab> to cycle through splits
:noremap <Tab> <C-w>w

" Close the current split
:nmap <leader>x <C-w>c

" Jumping between buffers
:noremap <C-n> :bnext<CR>
:noremap <C-p> :bprev<CR>
:noremap <C-e> :b#<CR>

" Let <C-n> and <C-p> also filter through command history
:cnoremap <C-n> <Down>
:cnoremap <C-p> <Up>

" Start scrolling before my cursor reaches the bottom of the screen
set scrolloff=4

" Show relative line numbers with <leader>l
:nmap <leader>l :set number! relativenumber!<CR>

" Improve search
:set ignorecase
:set smartcase
:set infercase
:set hlsearch
:set noincsearch " Default on neovim, and I hate it

" Toggle search highlighting
:nmap <CR> :set hlsearch!<CR>

" Lazily redraw: Make macros faster
:set lazyredraw

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

" Toggle cursor highlighting
:nmap <leader>x :set cursorline! cursorcolumn!<CR>

" Consistent backspace on all systems
:set backspace=2

" Clear trailing whitespace
:nnoremap <leader>W :%s/\s\+$//<CR><C-o>

" Convert tabs to spaces
:nnoremap <leader>T :%s/\t/    /g<CR>

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
:nmap <leader>c :bp\|bd #<CR>

" Save
:nmap <leader>w :w<CR>

" Toggle paste
:nmap <leader>p :set paste!<CR>

" Add 'DELETEME' comment using nerdcommenter
nmap <leader>dm mx<leader>cA DELETEME<ESC>`x

" Delete all DELETEME lines
nmap <leader>dd :keepp :g/DELETEME/d<CR><C-o>

" Mappings for vimdiff
:nmap <leader>dg :diffget<CR>
:nmap <leader>dp :diffput<CR>
:nmap <leader>du :diffupdate<CR>

" CONFIGURE PLUGINS

" Tmuxline (Configures Tmux's statusbar)
:let g:tmuxline_preset = 'powerline'
:let g:tmuxline_theme = 'zenburn'

" NERDTree
:nnoremap <leader>n :NERDTreeToggle<CR>

" Fugitive
:nmap <leader>gb :Gblame<CR>
:nmap <leader>gd :Gdiff<CR>
:nmap <leader>gs :Gstatus<CR>

" fzf.vim
:nmap <leader>f :FZF<CR>
:nmap <leader>b :Buffers<CR>
:nmap <leader>s :Lines<CR>
:nmap <leader>* :Lines <c-r><c-w><cr> " Search word under cursor in all buffers
:nmap <leader>rg :Rg<CR>

" Notational fzf vim
:let g:nv_search_paths = ["~/notes/"]
:nmap <leader>o :NV<CR>
