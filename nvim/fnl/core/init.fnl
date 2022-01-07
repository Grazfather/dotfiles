(module core.init
  {autoload {: packer
             utils core.utils}
   require-macros [core.macros]})

(require :core.plugins)
(require :core.completion)
(require :core.lsp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THEMES/UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Color scheme
(set! syntax "enable"
      background "dark")
(set-true! termguicolors)
(vim.api.nvim_command "silent! colorscheme gruvbox")

; Tmuxline (Configures Tmux's statusbar)
(let! g/tmuxline_preset "powerline"
      g/tmuxline_theme "zenburn")

; Status line
(utils.call-module-setup :lualine {:options {:theme :gruvbox}})
; Always show the status bar
(set! laststatus 2)
; Show opened buffers on tabline
(utils.call-module-setup :bufferline {:options {:separator_style :slant
                                          :diagnostics :nvim_lsp}})

(each [name text (pairs {:DiagnosticSignError ""
                         :DiagnosticSignWarn ""
                         :DiagnosticSignHint ""
                         :DiagnosticSignInfo ""})]
  (vim.fn.sign_define name {:texthl name :text text :numhl ""}))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VISUAL/LAYOUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Highlight trailing whitespace and spaces touching tabs
;   Lines ending with spaces:   
;   Mixed spaces and tabs (in either order):
    	;
	    ;
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

; Let indents in visual mode keep the selection
(noremap! "v" < "<gv"
          "v" > ">gv")

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

; Show linenumbers by default
(set-true! number relativenumber)

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
(utils.call-module-setup :hop {:keys "arstneio"})
(map! "nv" gs/ "<cmd>HopPattern<CR>"
      "nv" gss "<cmd>HopChar2<CR>"
      "nv" gsw "<cmd>HopWordAC<CR>"
      "nv" gsb "<cmd>HopWordBC<CR>"
      "nv" gsj "<cmd>HopLineAC<CR>"
      "nv" gsk "<cmd>HopLineBC<CR>")

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

  ; Add 'DELETEME' comment using Comment.nvim
  ; This is broken, we hack around it for now
  ; <leader>dm "mxgcADELETEME<ESC>`x<ESC>"
  <leader>dm "mxgcoDELETEME<ESC>kJ`x<ESC>"
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
  <leader>wo "<C-W>o"

  ; NERDTree
  <leader>ft "<cmd>NERDTreeToggle<CR>"

  ; Fugitive (git)
  <leader>gb "<cmd>Git blame<CR>"
  <leader>gd "<cmd>Git diff<CR>"
  <leader>gs "<cmd>Git status<CR>"
  <leader>gl "<cmd>GV<CR>"
  <leader>gg "<cmd>Neogit<CR>"

  ; fzf.vim
  ; -- Find files in 'project' (repo)
  <leader>pf "<cmd>lua require('fzf-lua').git_files()<CR>"
  ; -- Find files from CWD
  <leader>ff "<cmd>lua require('fzf-lua').files()<CR>"
  ; -- Find buffer
  <leader>bb "<cmd>lua require('fzf-lua').buffers()<CR>"
  ; -- Find line in current buffer
  <leader>ss "<cmd>lua require('fzf-lua').blines()<CR>"
  ; -- Find line in all buffers
  <leader>f* "<cmd>lua require('fzf-lua').lines()<CR>"
  ; -- Grep file content from CWD
  <leader>frg "<cmd>lua require('fzf-lua').live_grep()<CR>"

  <leader>hh "<cmd>lua require('fzf-lua').help_tags()<CR>"
  <leader>hk "<cmd>lua require('fzf-lua').keymaps()<CR>"
  <leader>hm "<cmd>lua require('fzf-lua').man_pages()<CR>"
  "<leader>:" "<cmd>lua require('fzf-lua').commands()<CR>")

; Toggle signcolumn (gutter) to make copy and paste easier
(set! signcolumn "yes")
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

; Comment.nvim
(utils.call-module-setup :Comment {})
(nmap! "<leader>c " "gcc")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Language support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Treesitter
(utils.call-module-setup
  :treesitter
  {
   :playground {
                :enable  true
                :disable  {}
                :updatetime  25 ; Debounced time for highlighting nodes in the playground from source code
                :persist_queries  false ; Whether the query persists across vim sessions
                :keybindings  {
                               :toggle_query_editor  "o"
                               :toggle_hl_groups  "i"
                               :toggle_injected_languages  "t"
                               :toggle_anonymous_nodes  "a"
                               :toggle_language_display  "I"
                               :focus_language  "f"
                               :unfocus_language  "F"
                               :update  "R"
                               :goto_node  "<cr>"
                               :show_help  "?"
                               }
                }
   :highlight { :enable true }
   :indent { :enable false }
   :incremental_selection {
                           :enable true
                           :keymaps {
                                     :init_selection "gh"
                                     :node_incremental "ghe"
                                     :node_decremental "ghi"
                                     :scope_incremental "ghu"
                                     }
                           }
   :ensure_installed ["bash" "c" "clojure" "javascript"
                      "fennel" "json" "lua" "go" "python"
                      "toml" "yaml"] })

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

; vim-sexp
; - Adds new text objects:
;   - f - form
;   - F - top-level form
;   - s - string or regex
;   - e - element
; - Adds new motions
;   - (/) - Move back/forward sexp
;   - M-b/M-w - Move back/forward sibling
;   - [e/]e - Select prev/next sexp
;   - M-h/M-j/M-k/M-l - Drag sexp around
; Make vim-sexp work for more languages
(vim.api.nvim_set_var "sexp_filetypes" "clojure,scheme,lisp,timl,fennel,janet")
