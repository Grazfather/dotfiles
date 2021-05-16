" Vim-Plug Plugins
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
" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Misc
Plug 'scrooloose/nerdcommenter'

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

" Use local config if it exists
if filereadable($HOME . "/.vimrc.local")
    source ~/.vimrc.local
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Match weird white space:
"   Lines ending with spaces:   
"   Mixed spaces and tabs (in either order):
    	"
	    "

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight trailing whitespace and spaces touching tabs
:highlight TrailingWhitespace ctermbg=darkred guibg=darkred
:let w:m2=matchadd('TrailingWhitespace', '\s\+$\| \+\ze\t\|\t\+\ze ')

" Remap <leader>
" I tend to use leader a lot, so I try to namespace commands under leader
" using a simple mnemonic:
" <leader>e_ -> Edit stuff
" <leader>g_ -> Git stuff
" <leader>o_ -> Coc stuff
" <leader>m_ -> 'localleader': Filestype specific stuff
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

" Consistent backspace on all systems
:set backspace=2

" When tabbing on lines with extra spaces, round to the next tab barrier
:set shiftround

" Clear trailing whitespace
:nnoremap <leader>eW :%s/\s\+$//<CR><C-o>

" Convert tabs to spaces
:nnoremap <leader>eT :%s/\t/    /g<CR>

" Enable indent folding, but have it disabled by default
:set foldmethod=indent
:set foldlevel=99

" Select whole buffer
nnoremap vag ggvGg_

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

" CONFIGURE PLUGINS

" Tmuxline (Configures Tmux's statusbar)
:let g:tmuxline_preset = 'powerline'
:let g:tmuxline_theme = 'zenburn'

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

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>orn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>of  <Plug>(coc-format-selected)
nmap <leader>of  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>oa  <Plug>(coc-codeaction-selected)
nmap <leader>oa  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>oac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>oqf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>od  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>oe  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>oc  :<C-u>CocList commands<cr>
" Find symbol of current documento.
nnoremap <silent><nowait> <leader>oo  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>os  :<C-u>CocList -I symbols<cr>
" Do default action for next itemo.
nnoremap <silent><nowait> <leader>oj  :<C-u>CocNext<CR>
" Do default action for previous oitem.
nnoremap <silent><nowait> <leader>ok  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>op  :<C-u>CocListResume<CR>
