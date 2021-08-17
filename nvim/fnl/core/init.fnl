(module core.init
        {autoload {packer packer}
         require-macros [core.macros]})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PLUGINS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(packer.startup
  (fn []
    ; Packer itself
    (use "wbthomason/packer.nvim")
    ; Aniseed itself
    (use "Olical/aniseed")

    (use "itchyny/lightline.vim")
    (use "bling/vim-bufferline")
    (use "liuchengxu/vim-which-key")
    ; Navigation
    (use {1 "junegunn/fzf" :run (fn [] (vim.fn "-> fzf#install()")) })
    (use "junegunn/fzf.vim")
    (use "edkolev/tmuxline.vim")
    (use "scrooloose/nerdtree")
    (use "tiagofumo/vim-nerdtree-syntax-highlight")
    (use "ryanoasis/vim-devicons")
    (use "junegunn/vim-peekaboo")
    (use "phaazon/hop.nvim")
    ; Language specific
    (use "neovim/nvim-lspconfig")
    (use "glepnir/lspsaga.nvim")
    (use "nvim-treesitter/nvim-treesitter")
    ; -- Go
    (use "fatih/vim-go")
    ; -- Markdown
    (use "jtratner/vim-flavored-markdown")
    ; -- Clojure
    ; ---- Connection to nREPL
    (use "guns/vim-sexp")
    (use {1 "liquidz/vim-iced" :ft ["clojure"]})
    ; ---- Linting
    (use "borkdude/clj-kondo")
    ; -- TOML
    (use "cespare/vim-toml")
    ; -- Fennel
    (use "bakpakin/fennel.vim")
    ; Git
    (use "tpope/vim-fugitive")
    ; -- Adds :Gbrowse
    (use "tpope/vim-rhubarb")
    ; -- Adds :GV to browse history
    (use "junegunn/gv.vim")
    ; -- Adds changed lines in the gutter
    (use "airblade/vim-gitgutter")
    ; Misc
    (use "scrooloose/nerdcommenter")
    ; Themes
    (use "morhetz/gruvbox")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THEMES/UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Color scheme
(set! syntax "enable"
      background "dark")
(vim.api.nvim_command "silent! colorscheme gruvbox")

; Tmuxline (Configures Tmux's statusbar)
(let! g/tmuxline_preset "powerline"
      g/tmuxline_theme "zenburn")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VISUAL/LAYOUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Match weird white space:
;   Lines ending with spaces:   
;   Mixed spaces and tabs (in either order):
    	;
	    ;

; Highlight trailing whitespace and spaces touching tabs
(vim.api.nvim_command ":highlight TrailingWhitespace ctermbg=darkred guibg=darkred")
(vim.api.nvim_command ":let w:m2=matchadd('TrailingWhitespace', '\\s\\+$\\| \\+\\ze\\t\\|\\t\\+\\ze ')")

; Remap <leader>
; I tend to use leader a lot, so I try to namespace commands under leader
; using a simple mnemonic:
; <leader>e_ -> Edit stuff
; <leader>g_ -> Git stuff
; <leader>m_ -> 'localleader': Filetype specific stuff
; <leader>f_ -> File stuff, some [fuzzy] find stuff
; <leader>t_ -> Toggleable settings
; <leader>w_ -> Window stuff
; Though some that don't fit aren't yet put behind a namespace
(let! g/mapleader " "
      g/maplocalleader " m")

; Use WhichKey to show my prefix mappings
(nmap! <leader> "<cmd>WhichKey '<Space>'<CR>")

; Allow filetype-specific plugins
:filetype plugin on

; Read configurations from files
(set-true! modeline)
(set! modelines 5)

; Setup tags file
(set! tags "./tags,tags;")

; Set path to include the cwd and everything underneath
(set! path "**3")
(set-true! wildmenu)

; Show the normal mode command as I type it
(set-true! showcmd)

; Lazily redraw: Make macros faster
(set-true! lazyredraw)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NAVIGATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Jump to last cursor position unless it's invalid or in an event handler
;(vim.api.nvim_command "autocmd BufReadPost *
  ;\\ if line(\"'\\\"\") > 0 && line(\"'\\\"\") <= line(\"$\") |
  ;\\   exe \"normal g`\\\"\" |
  ;\\ endif")

; Disable arrow keys for navigation
(nnoremap! <up> "<nop>"
           <down> "<nop>"
           <left> "<nop>"
           <right> "<nop>")

; Make j and k move up and down better for wrapped lines
(nnoremap! k "gk"
           j "gj"
           gk "k"
           gj "j")

; Ctrl-<hjkl> to change splits
(map! "nv" <C-h> "<C-w>h"
      "nv" <C-j> "<C-w>j"
      "nv" <C-k> "<C-w>k"
      "nv" <C-l> "<C-w>l")

; <Tab> to cycle through splits
(nnoremap! <Tab> "<C-w>w")

; Jumping between buffers
(nnoremap! <C-n> "<cmd>bnext<CR>"
           <C-p> "<cmd>bprev<CR>"
           <C-e> "<cmd>b#<CR>")

; Let <C-n> and <C-p> also filter through command history
(noremap! "c" <C-n> "<down>"
          "c" <C-p> "<up>")

; Start scrolling before my cursor reaches the bottom of the screen
(set! scrolloff 4)
; Improve search
(set-true! ignorecase
           smartcase
           infercase
           hlsearch)
(set-false! incsearch)

; Turn off swap files
(set-false! swapfile
            backup
            writebackup)

; Open new split panes to right and bottom
(set-true! splitbelow
           splitright)

; Allow hidden buffers
(set-true! hidden)

; Always show the status bar
(set! laststatus 2)

; Hide mode so it shows on the statusbar only
(set-false! showmode)

; Short ttimeoutlen to lower latency to show current mode
(set! ttimeoutlen 50)

; Consistent backspace on all systems
(set! backspace "indent,eol,start")

; When tabbing on lines with extra spaces, round to the next tab barrier
(set-true! shiftround)

; Enable indent folding, but have it disabled by default
(set! foldmethod "indent"
      foldlevel 99)

; Use braces to determine when to auto indent
(set-true! smartindent)

; Make Y act like D and C
(nnoremap! Y "y$")

; Make joins keep the cursor in the same spot in the window
(nnoremap! J "mzJ`z")

; Make searching keep the cursor in the same spot in the window
(nnoremap! n "nzzzv"
           N "Nzzzv")

; Unmap ex mode
(nnoremap! Q "<nop>")

; Configure hop bindings
((. (require "hop") "setup") {:keys "arstneiogmqwfpluy;"})
(map! "nv" gs/ "<cmd>HopPattern<CR>"
      "nv" gss "<cmd>HopChar2<CR>"
      "nv" gsw "<cmd>HopWordAC<CR>"
      "nv" gsh "<cmd>HopLineAC<CR>"
      "nv" gsj "<cmd>HopLineBC<CR>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GLOBAL MAPPINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(nmap!
  ; Clear trailing whitespace
  <leader>eW "<cmd>%s/\\s\\+$//<CR><C-o>"

  ; Convert tabs to spaces
  <leader>eT "<cmd>%s/\t/    /g<CR>"

  ; Select whole buffer
  vag "ggVGg_"

  ; Open commonly edited files
  <leader>fev "<cmd>edit $MYVIMRC<CR>"
  <leader>fet "<cmd>edit $HOME/.tmux.conf<CR>"
  <leader>feb "<cmd>edit $HOME/.bash_aliases<CR>"
  <leader>feg "<cmd>edit $HOME/.gitaliases<CR>"

  ; Reload vimrc
  <leader>frv "<cmd>source $MYVIMRC<CR>"

  ; Close the current buffer
  <leader>bd "<cmd>bp|bd #<CR>"

  ; Save
  <leader>fs "<cmd>w<CR>"

  ; Quit
  <leader>qq "<cmd>qa<CR>"

  ; Add 'DELETEME' comment using nerdcommenter
  <leader>dm "mx<leader>cA DELETEME<ESC>`x"
  ; Delete all DELETEME lines
  <leader>dd "<cmd>keepp :g/DELETEME/d<CR><C-o>"

  ; Toggle search highlighting
  <leader>th "<cmd>set hlsearch!<CR>"

  ; Show relative line numbers
  <leader>tl "<cmd>set number! relativenumber!<CR>"

  ; Toggle cursor highlighting
  <leader>tx "<cmd>set cursorline! cursorcolumn!<CR>"

  ; Toggle paste
  <leader>tp "<cmd>set paste!<CR>"

  ; Window (split) management
  <leader>wv "<cmd>vsp<CR>"
  <leader>ws "<cmd>sp<CR>"
  <leader>wd "<C-W>c"

  ; NERDTree
  <leader>ft "<cmd>NERDTreeToggle<CR>"

  ; Fugitive (git)
  <leader>gb "<cmd>Git blame<CR>"
  <leader>gd "<cmd>Git diff<CR>"
  <leader>gs "<cmd>Git status<CR>"
  <leader>gl "<cmd>GV<CR>"

  ; fzf.vim
  ; -- Find files in 'project' (repo)
  <leader>pf "<cmd>GFiles<CR>"
  <leader>ff "<cmd>Files<CR>"
  <leader>bb "<cmd>Buffers<CR>"
  <leader>ss "<cmd>BLines<CR>"
  <leader>f* "<cmd>Lines<CR>"
  <leader>frg "<cmd>Rg<CR>")

; Toggle signcolumn (gutter) to make copy and paste easier
(global toggle_sign_column (fn []
  (if (= (get? signcolumn) "yes")
    (set! signcolumn "no")
    (set! signcolumn "yes"))))
(nmap! "<leader>tg" "<cmd>lua toggle_sign_column()<CR>")

; Toggle showing listchars
(nnoremap! <leader>t<TAB> "<cmd>set list!<CR>")
(if (= (get? encoding) "utf-8")
  (set! listchars "eol:\u{00ac},nbsp:\u{2423},conceal:\u{22ef},tab:\u{25b8}\u{2014},precedes:\u{2026},extends:\u{2026}")
  (set! listchars "eol:$,conceal:+tab:>-,precedes:<,extends:\u{2026}"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Language support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; LSP
(local lspconfig (require "lspconfig"))

(local servers ["gopls" "clojure_lsp" "pyright"])

(defn on-attach [client bufnr]
  (defn buf-set-keymap [...] (vim.api.nvim_buf_set_keymap bufnr ...))
  (defn buf-set-option [...] (vim.api.nvim_buf_set_option bufnr ...))

  (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")

  ; Mappings
  (local opts {:noremap true :silent true})
  (buf-set-keymap "n" "gD" "<cmd>lua vim.lsp.buf.declaration()<CR>" opts)
  (buf-set-keymap "n" "gd" "<cmd>lua vim.lsp.buf.definition()<CR>" opts)
  (buf-set-keymap "n" "gdd" "<cmd>lua vim.lsp.buf.definition()<CR>" opts)
  (buf-set-keymap "n" "gdp" "<cmd>lua require('lspsaga.provider').preview_definition()<CR>" opts)
  (buf-set-keymap "n" "K" "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>" opts)
  (buf-set-keymap "n" "gi" "<cmd>lua vim.lsp.buf.implementation()<CR>" opts)
  (buf-set-keymap "n" "gr" "<cmd>lua vim.lsp.buf.references()<CR>" opts)
  (buf-set-keymap "n" "[d" "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>" opts)
  (buf-set-keymap "n" "]d" "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>" opts)
  (buf-set-keymap "n" "<leader>rn" "<cmd>lua require('lspsaga.rename').rename()<CR>" opts)

  ; Set some keybinds conditional on server capabilities
  (if client.resolved_capabilities.document_formatting
    (buf-set-keymap "n" "<leader>ef" "<cmd>lua vim.lsp.buf.formatting()<CR>" opts))
  (if client.resolved_capabilities.document_range_formatting
    (buf-set-keymap "v" "<leader>ef" "<cmd>lua vim.lsp.buf.range_formatting()<CR>" opts))

  ; Set autocommands conditional on server_capabilities
  (if client.resolved_capabilities.document_highlight
    (vim.api.nvim_command
      "hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END")))

; Use a loop to conveniently both setup defined servers and map buffer local
; keybindings when the language server attaches
(each [_ lsp (ipairs servers)]
  ((. (. lspconfig lsp) "setup") {:on_attach on-attach}))

; Treesitter
(local treesitter (require "nvim-treesitter.configs"))
(treesitter.setup {
                   :highlight {
                               :enable true
                               :disable {}
                               }
                   :indent {
                            :enable false
                            :disable {}
                            }
                   :ensure_installed [ "clojure" "fennel" "go" "python" ] })

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Specific language settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Special settings for some filetypes
(vim.api.nvim_command
  ":au Filetype ruby setl expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4
  :au Filetype yaml setl expandtab smarttab tabstop=4 shiftwidth=4 softtabstop=4")

; Use github-flavored markdown
(vim.api.nvim_exec
  ":aug markdown
  :au!
  :au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  :aug END" false)

; vim-iced (Clojure)
(let! g/iced_default_key_mapping_leader "<LocalLeader>"
      g/iced_enable_default_key_mappings "v:true"
      g/iced_enable_clj_konda_analysis "v:true")
