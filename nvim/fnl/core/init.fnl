(module core.init
  {require-macros [core.macros]})

(require :core.plugins)
(require :core.completion)
(require :core.lsp)
(require :core.treesitter)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THEMES/UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Color scheme
(set! syntax "enable")
(set-true! termguicolors)
(setup-module! :onedark {:style :warmer})
(vim.api.nvim_command "silent! colorscheme onedark")

; Tmuxline (Configures Tmux's statusbar)
(let! g/tmuxline_preset "powerline"
      g/tmuxline_theme "zenburn")

; Status line
(setup-module! :lualine {:options {:theme :auto
                                   :component_separators {:left ""
                                                          :right ""}
                                   :section_separators {:left ""
                                                        :right ""}}})
; Always show the status bar
(set! laststatus 2)
; Show opened buffers on tabline
(setup-module! :bufferline {:options {:diagnostics :nvim_lsp
                                      :offsets [{:filetype :NvimTree
                                                 :text ""
                                                 :padding 1}]}})

(each [name text (pairs {:DiagnosticSignError ""
                         :DiagnosticSignWarn ""
                         :DiagnosticSignHint ""
                         :DiagnosticSignInfo ""})]
  (vim.fn.sign_define name {:texthl name :text text :numhl ""}))

; Show lines at each indent
(setup-module! :indent_blankline
               {:buftype_exclude ["terminal" "nofile"]
                :filetype_exclude ["NvimTree" "help"]})

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
; <leader>b_ -> Buffer stuff
; <leader>e_ -> Edit stuff
; <leader>g_ -> Git stuff
; <leader>m_ -> 'localleader': Filetype specific stuff
; <leader>f_ -> File stuff, some [fuzzy] find stuff
; <leader>t_ -> Toggleable settings
; <leader>w_ -> Window stuff
; Though some that don't fit aren't yet put behind a namespace
(let! g/mapleader " "
      g/maplocalleader " m")

; Short timeoutlen to get which-key to kick in sooner
(set! timeoutlen 200)
; -- Document top-level prefixes
(call-module-method! :which-key :register
                     {:b {:name "Buffer stuff"}
                      :e {:name "Edit stuff"}
                      :g {:name "Git"}
                      :h {:name "Help"}
                      :m {:name "Local leader"}
                      :f {:name "File/find ops"}
                      :t {:name "Toggles"}
                      :w {:name "Window"}}
                     {:prefix :<leader>})

; Read configurations from files
(set-true! modeline)
(set! modelines 5)

; Setup tags file
(set! tags "./tags,tags;")

; Set path to include the cwd and everything underneath
(set! path "**3")

; Show the normal mode command as I type it
(set-true! showcmd)

; Lazily redraw: Make macros faster
(set-true! lazyredraw)

; Setup todo-comments.nvim to highlight special words
; DELETEME:
; TODO: This is a todo
; HACK:
; WARN:
; NOTE:
(setup-module! :todo-comments
               {:keywords {:DELETEME {:icon "✗" :color "error"}
                           :TODO {:icon " " :color "info"}
                           :HACK {:icon " " :color "warning"}
                           :WARN {:icon " " :color "warning" :alt ["WARNING" "XXX"]}
                           :NOTE {:icon " " :color "hint" :alt  ["INFO"]}}
                ; I set the colon to optional for DELETEME comments
                :highlight {:pattern ".*<(KEYWORDS)\\s*:?"}})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NAVIGATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Jump to last cursor position unless it's invalid or in an event handler
(vim.cmd "autocmd! BufReadPost *
         \\ if line(\"'\\\"\") > 0 && line(\"'\\\"\") <= line(\"$\") |
         \\   exe \"normal g`\\\"\" |
         \\ endif")

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

; Start scrolling before my cursor reaches the top or bottom of the screen
(set! scrolloff 4)

; Improve search
(set-true! ignorecase
           smartcase
           infercase)
(set-false! incsearch)

; Turn off swap files
(set-false! swapfile
            backup
            writebackup)

; Open new split panes to right and bottom
(set-true! splitbelow
           splitright)

; Short ttimeoutlen to lower latency to show current mode
(set! ttimeoutlen 50)

; When tabbing on lines with extra spaces, round to the next tab barrier
(set-true! shiftround)

; Enable indent folding, but have it disabled by default
(set! foldmethod "indent"
      foldlevel 99)

; Use braces to determine when to auto indent
(set-true! smartindent)

; Show linenumbers by default
(set-true! number relativenumber)

; Make joins keep the cursor in the same spot in the window
(nnoremap! J "mzJ`z")

; Unmap ex mode
(nnoremap! Q "<nop>")

; Configure hop bindings
(setup-module! :hop {:keys "arstneio"})
(map! "nv" gs/ "<cmd>HopPattern<CR>"
      "nv" gss "<cmd>HopChar2<CR>"
      "nv" gsw "<cmd>HopWordAC<CR>"
      "nv" gsb "<cmd>HopWordBC<CR>"
      "nv" gsj "<cmd>HopLineAC<CR>"
      "nv" gsk "<cmd>HopLineBC<CR>")

; Toggleterm
(setup-module! :toggleterm {:open_mapping "<c-\\>"})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GLOBAL MAPPINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(nmap!
  ; Clear trailing whitespace
  <leader>eW "<cmd>%s/\\s\\+$//<CR><C-o>"

  ; Convert tabs to spaces
  <leader>eT2 "<cmd>%s/\t/  /g<CR>"
  <leader>eT4 "<cmd>%s/\t/    /g<CR>"
  <leader>eT8 "<cmd>%s/\t/        /g<CR>"

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
  <leader>fs "<cmd>write<CR>"

  ; Add 'DELETEME' comment using Comment.nvim
  <leader>dm "mxgcADELETEME<ESC>`x<ESC>"
  ; Delete all DELETEME lines
  <leader>dd "<cmd>keepp :g/DELETEME/d<CR><C-o>"

  ; Toggle search highlighting
  <leader>th "<cmd>set hlsearch!<CR>"

  ; Show relative line numbers
  <leader>tl "<cmd>set number! relativenumber!<CR>"

  ; Toggle cursor highlighting
  <leader>tx "<cmd>set cursorline! cursorcolumn!<CR>"

  ; Blink on demand
  <leader><space> "<cmd>lua require('blinker').blink_cursorline()<CR>"

  ; Toggle paste
  <leader>tp "<cmd>set paste!<CR>"

  ; Window (split) management
  <leader>wv "<cmd>vsplit<CR>"
  <leader>ws "<cmd>split<CR>"
  <leader>wd "<cmd>close<CR>"
  <leader>wo "<cmd>only<CR>"

  ; Nvim tree
  <leader>ft "<cmd>NvimTreeToggle<CR>"

  ; Undotree
  <leader>tu "<cmd>UndotreeToggle<CR>"

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
  (set! listchars "eol:¬,nbsp:␣,conceal:⋯,tab:▸—,precedes:…,extends:…,trail:•")
  (set! listchars "eol:$,conceal:+tab:>-,precedes:<,extends:>"))

; Comment.nvim
(nmap! "<leader>c " "gcc")

; Blinker.nvim
(setup-module! :blinker {})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Specific language settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Use github-flavored markdown
(vim.cmd "augroup markdown
         autocmd! BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
         augroup end")

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
;   - M-S-h/M-S-j/M-S-k/M-S-l - Barf/slurp
; Make vim-sexp work for more languages
(vim.api.nvim_set_var "sexp_filetypes" "clojure,scheme,lisp,timl,fennel,janet")
