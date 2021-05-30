""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'bling/vim-bufferline'
" Navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/vim-peekaboo'
" Language specific
" -- Go
Plug 'fatih/vim-go'
let g:go_version_warning = 0
" -- Markdown
Plug 'jtratner/vim-flavored-markdown'
" -- Clojure
" ---- Connection to nREPL
Plug 'guns/vim-sexp', {'for': 'clojure'}
Plug 'liquidz/vim-iced', {'for': 'clojure'}
" ---- Linting
Plug 'borkdude/clj-kondo'
" -- TOML
Plug 'cespare/vim-toml'
" Git
Plug 'tpope/vim-fugitive'
" -- Adds :Gbrowse
Plug 'tpope/vim-rhubarb'
" -- Adds :GV to browse history
Plug 'junegunn/gv.vim'
" -- Adds changed lines in the gutter
Plug 'airblade/vim-gitgutter'
" LSP
if has("nvim")
  Plug 'neovim/nvim-lspconfig'
endif
" Misc
Plug 'scrooloose/nerdcommenter'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" THEMES/UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Themes
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

" Tmuxline (Configures Tmux's statusbar)
:let g:tmuxline_preset = "powerline"
:let g:tmuxline_theme = "zenburn"

" Use local config if it exists
if filereadable($HOME . "/.vimrc.local")
    source ~/.vimrc.local
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VISUAL/LAYOUT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Match weird white space:
"   Lines ending with spaces:   
"   Mixed spaces and tabs (in either order):
    	"
	    "

" Highlight trailing whitespace and spaces touching tabs
:highlight TrailingWhitespace ctermbg=darkred guibg=darkred
:let w:m2=matchadd('TrailingWhitespace', '\s\+$\| \+\ze\t\|\t\+\ze ')

" Remap <leader>
" I tend to use leader a lot, so I try to namespace commands under leader
" using a simple mnemonic:
" <leader>e_ -> Edit stuff
" <leader>g_ -> Git stuff
" <leader>m_ -> 'localleader': Filetype specific stuff
" <leader>f_ -> File stuff, some [fuzzy] find stuff
" <leader>t_ -> Toggleable settings
" <leader>w_ -> Window stuff
" Though some that don't fit aren't yet put behind a namespace
:let mapleader="\<Space>"
:let maplocalleader="\<Space>m"

" Allow filetype-specific plugins
:filetype plugin on

" Read configurations from files
:set modeline
:set modelines=5

" Setup tags file
:set tags=./tags,tags;

" Set path to include the cwd and everything underneath
:set path=**3
:set wildmenu

" Show the normal mode command as I type it
:set showcmd

" Lazily redraw: Make macros faster
:set lazyredraw

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NAVIGATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Jumping between buffers
:noremap <C-n> :bnext<CR>
:noremap <C-p> :bprev<CR>
:noremap <C-e> :b#<CR>

" Let <C-n> and <C-p> also filter through command history
:cnoremap <C-n> <Down>
:cnoremap <C-p> <Up>

" Start scrolling before my cursor reaches the bottom of the screen
set scrolloff=4

" Improve search
:set ignorecase
:set smartcase
:set infercase
:set hlsearch
:set noincsearch " Default on neovim, and I hate it

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

" Consistent backspace on all systems
:set backspace=2

" When tabbing on lines with extra spaces, round to the next tab barrier
:set shiftround

" Enable indent folding, but have it disabled by default
:set foldmethod=indent
:set foldlevel=99

" Use braces to determine when to auto indent
:set smartindent

" Make Y act like D and C
nnoremap Y y$

" Unmap ex mode
nnoremap Q <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GLOBAL MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Clear trailing whitespace
:nnoremap <leader>eW :%s/\s\+$//<CR><C-o>

" Convert tabs to spaces
:nnoremap <leader>eT :%s/\t/    /g<CR>

" Select whole buffer
nnoremap vag ggvGg_

" Open commonly edited files
:nmap <leader>fev :edit $MYVIMRC<CR>
:nmap <leader>fet :edit $HOME/.tmux.conf<CR>
:nmap <leader>feb :edit $HOME/.bash_aliases<CR>
:nmap <leader>feg :edit $HOME/.gitaliases<CR>

" Reload vimrc
:nmap <leader>frv :source $MYVIMRC<CR>

" Close the current buffer
:nmap <leader>bd :bp\|bd #<CR>

" Save
:nmap <leader>fs :w<CR>

" Quit
:nmap <leader>qq :qa<CR>

" Add 'DELETEME' comment using nerdcommenter
nmap <leader>dm mx<leader>cA DELETEME<ESC>`x

" Delete all DELETEME lines
nmap <leader>dd :keepp :g/DELETEME/d<CR><C-o>

" Toggle search highlighting
:nmap <leader>th :set hlsearch!<CR>

" Show relative line numbers
:nmap <leader>tnv :set number! relativenumber!<CR>

" Toggle cursor highlighting
:nmap <leader>tx :set cursorline! cursorcolumn!<CR>

" Toggle signcolumn (gutter) to make copy and paste easier
:nmap <leader>tg :call Toggle_sign_column()<CR>
function! Toggle_sign_column()
    if &signcolumn == "yes"
        set signcolumn=no
    else
        set signcolumn=yes
    endif
endfunction

" Toggle showing listchars
:nnoremap <leader>t<TAB> :set list!<CR>
if &encoding == "utf-8"
  exe "set listchars=eol:\u00ac,nbsp:\u2423,conceal:\u22ef,tab:\u25b8\u2014,precedes:\u2026,extends:\u2026"
else
  set listchars=eol:$,tab:>-,extends:>,precedes:<,conceal:+
endif

" Toggle paste
:nmap <leader>tp :set paste!<CR>

" Window (split) management
:nmap <leader>wv :vsp<CR>
:nmap <leader>ws :sp<CR>
:nmap <leader>wd <C-W>c

" NERDTree
:nnoremap <leader>ft :NERDTreeToggle<CR>

" Fugitive (git)
:nmap <leader>gb :Gblame<CR>
:nmap <leader>gd :Gdiff<CR>
:nmap <leader>gs :Gstatus<CR>

" fzf.vim
:nmap <leader>ff :FZF<CR>
:nmap <leader>bb :Buffers<CR>
:nmap <leader>ss :Lines<CR>
:nmap <leader>f* :Lines <C-r><C-w><CR>
:nmap <leader>frg :Rg<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specific language settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Special settings for some filetypes
:au Filetype ruby setl expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4
:au Filetype yaml setl expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4

" Use github-flavored markdown
:aug markdown
    :au!
    :au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
:aug END

" vim-iced (Clojure)
let g:iced_default_key_mapping_leader = "<LocalLeader>"
let g:iced_enable_default_key_mappings = v:true
let g:iced_enable_clj_konda_analysis = v:true
