(module core.init
  {require-macros [core.macros]})

; Remap <leader> to <space>.
; This must be done before calling setup on lazy, which we do in the plugins
; module.
(let! g/mapleader " "
      g/maplocalleader " m")

(require :core.plugins)
(require :core.completion)
(require :core.lsp)
(require :core.treesitter)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THEMES/UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Color scheme
(set-true! termguicolors)
(setup-module! :onedark {:style :warmer})
(vim.api.nvim_command "silent! colorscheme onedark")

; Status line
(setup-module! :lualine {:options {:theme :auto
                                   :component_separators {:left ""
                                                          :right ""}
                                   :section_separators {:left ""
                                                        :right ""}}})
; Always show the status bar, one for all splits
(set! laststatus 3)
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
(vim.api.nvim_set_hl 0 "TrailingWhitespace" {:bg :darkred})
(vim.api.nvim_command ":let w:m2=matchadd('TrailingWhitespace', '\\s\\+$\\| \\+\\ze\\t\\|\\t\\+\\ze ')")

; I tend to use leader a lot, so I try to namespace commands under leader
; using a simple mnemonic:
(call-module-method! :which-key :register
                     {:b {:name "Buffer stuff"}
                      :e {:name "Edit stuff"}
                      :g {:name "Git"}
                      :h {:name "Help"}
                      :m {:name "Local leader"}
                      :f {:name "File/find ops"}
                      :t {:name "Toggles"}
                      :w {:name "Window"}
                      :x {:name "Lisp"}}
                     {:prefix :<leader>})
; Though some that don't fit aren't yet put behind a namespace

; Short timeoutlen to get which-key to kick in sooner
(set! timeoutlen 200)

; Setup tags file
(set! tags "./tags,tags;")

; Set path to include the cwd and everything underneath
(set! path "**3")

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
(vim.api.nvim_create_autocmd
  ["BufReadPost"]
  {:pattern ["*"]
   :callback #(let [[row _] (vim.api.nvim_buf_get_mark 0 "\"")
                    lastrow (vim.api.nvim_buf_line_count 0)]
                (if (and (> row 0)
                         (<= row lastrow))
                  (vim.cmd "normal g`\"")))})

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

; Use default (s/S) mappings for leap.nvim
(call-module-method! :leap :set_default_keymaps)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GLOBAL MAPPINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Make joins keep the cursor in the same spot in the window
(nnoremap! J "mzJ`z")

; Unmap ex mode
(nnoremap! Q "<nop>")

; Configure hop bindings
(map! "nv" gl "<cmd>HopLine<CR>")

; Toggleterm
(setup-module! :toggleterm {:open_mapping "<c-\\>"
                            :direction :tab})

(descnmap!
  "Clear trailing whitespace"
  <leader>ew "<cmd>%s/\\s\\+$//<CR><C-o>"

  "Convert tabs to 2 spaces"
  <leader>et2 "<cmd>%s/\t/  /g<CR>"
  "Convert tabs to 4 spaces"
  <leader>et4 "<cmd>%s/\t/    /g<CR>"
  "Convert tabs to 8 spaces"
  <leader>et8 "<cmd>%s/\t/        /g<CR>"

  "Select whole buffer"
  vag "ggVGg_"

  "Reload Neovim config"
  <leader>frv "<cmd>AniseedEvalFile<CR>"
  "Close current buffer"
  <leader>bd "<cmd>bp|bd #<CR>"
  "Save buffer"
  <leader>fs "<cmd>write<CR>"

  ; Add 'DELETEME' comment using Comment.nvim
  "Add DELETEME comment"
  <leader>dm "mxgcADELETEME<ESC>`x"
  "Delete all DELETEME lines"
  <leader>dd "<cmd>keepp :g/DELETEME/d<CR><C-o>"

  "Toggle search highlighting"
  <leader>th "<cmd>set hlsearch!<CR>"
  "Toggle showing relative line numbers"
  <leader>tl "<cmd>set number! relativenumber!<CR>"
  "Toggle cursor highlighting"
  <leader>tx "<cmd>set cursorline! cursorcolumn!<CR>"
  "Blink current line"
  <leader><space> "<cmd>lua require('blinker').blink_cursorline()<CR>"

  ; Window (split) management
  "Split vertically"
  <leader>wv "<cmd>vsplit<CR>"
  "Split horizontally"
  <leader>ws "<cmd>split<CR>"
  "Close split"
  <leader>wd "<cmd>close<CR>"
  "Close other splits"
  <leader>wo "<cmd>only<CR>"

  "Toggle NvimTree"
  <leader>ft "<cmd>NvimTreeToggle<CR>"
  "Toggle Undotree"
  <leader>tu "<cmd>UndotreeToggle<CR>"

  ; Git stuff
  "Git blame"
  <leader>gb "<cmd>Git blame<CR>"
  "Git diff"
  <leader>gd "<cmd>Git diff<CR>"
  "Git status"
  <leader>gs "<cmd>Git status<CR>"
  "Git log"
  <leader>gl "<cmd>GV<CR>"
  "Open Neogit"
  <leader>gg "<cmd>Neogit<CR>"
  "Show commit message at line"
  <leader>gm "<cmd>GitMessenger<CR>"

  ; telescope.nvim
  "Find files in project"
  <leader>pf "<cmd>lua require('telescope.builtin').git_files()<CR>"
  "Find TODOs in project"
  <leader>pt "<cmd>TodoTelescope<CR>"
  "File files from CWD"
  <leader>ff "<cmd>lua require('telescope.builtin').find_files()<CR>"
  "Find buffer"
  <leader>bb "<cmd>lua require('telescope.builtin').buffers()<CR>"
  "Find mark"
  <leader>fm "<cmd>lua require('telescope.builtin').marks()<CR>"
  "Find jump"
  <leader>fj "<cmd>lua require('telescope.builtin').jumplist()<CR>"
  "Grep file content from CWD"
  <leader>frg "<cmd>lua require('telescope.builtin').live_grep()<CR>"
  "Search help"
  <leader>hh "<cmd>lua require('telescope.builtin').help_tags()<CR>"
  "Search keymaps"
  <leader>hk "<cmd>lua require('telescope.builtin').keymaps()<CR>"
  "Search man pages"
  <leader>hm "<cmd>lua require('telescope.builtin').man_pages()<CR>"
  "Search ex commands"
  "<leader>:" "<cmd>lua require('telescope.builtin').commands()<CR>")

(set! signcolumn "yes")
(defn toggle-sign-column []
  (if (= (get? signcolumn) "yes")
    (set! signcolumn "no")
    (set! signcolumn "yes")))
(descnmap! "Toggle sign column"
          <leader>tg toggle-sign-column)

(descnmap! "Toggle showing listchars"
           <leader>tt "<cmd>set list!<CR>")
(set-true! list)

(if (= (get? encoding) "utf-8")
  (set! listchars "eol:¬,nbsp:␣,conceal:⋯,tab:▸—,precedes:…,extends:…,trail:•")
  (set! listchars "eol:$,conceal:+tab:>-,precedes:<,extends:>"))

; Toggle indent markers
(descnmap! "Toggle indent markers" <leader>ti "<cmd>IndentBlanklineToggle<CR>")

; Toggle visual glyphs that make copy and paste from terminal annoying
(descnmap! "Toggle visual glyphs"
           <leader>tv (fn []
                        (toggle-sign-column)
                        (set-toggle! list number relativenumber)
                        (vim.cmd "IndentBlanklineToggle")))

(descnmap! "Toggle comment on current line"
           "<leader>c " "gcc")

; Simulate readline/emacs's jump to start/end of line in insert mode
(map! "i" <C-a> "<ESC>I"
      "i" <C-e> "<ESC>A")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Specific language settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Use github-flavored markdown
(vim.api.nvim_create_autocmd
  ["BufNewFile" "BufRead"]
  {:pattern "*.md"
   :group (vim.api.nvim_create_augroup :markdown {:clear true})
   :callback #(vim.api.nvim_set_option_value :filetype :ghmarkdown {:scope :local})})

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
;   - M-{hjkl} - Drag sexp around
;   - M-S-{hjkl} - Barf/slurp
(descnmap!
  "Slurp from right"
  <leader>xs "<Plug>(sexp_capture_next_element)"
  "Slurp from left"
  <leader>xS "<Plug>(sexp_capture_prev_element)"
  "Barf from right"
  <leader>xe "<Plug>(sexp_emit_tail_element)"
  "Barf from left"
  <leader>xE "<Plug>(sexp_emit_head_element)"
  "Convolute"
  <leader>xc "<Plug>(sexp_convolute)"
  "Drag forward"
  <leader>xl "<Plug>(sexp_swap_element_forward)"
  "Drag back"
  <leader>xh "<Plug>(sexp_swap_element_backward)"
  "Next element"
  <leader>xw "<Plug>(sexp_move_to_next_element_head)"
  "Previous element"
  <leader>xb "<Plug>(sexp_move_to_prev_element_head)")
