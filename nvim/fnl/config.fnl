(import-macros {: call-module-func : setup
                : get? : set! : set-true! : set-false! : set-toggle!
                : map! : nmap! : noremap! : nnoremap! : descnmap!
                : autocmd : augroup} :core.macros)

; Setup tags file
(set! tags "./tags,tags;")

; Set path to include the cwd and everything underneath
(set! path "**3")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NAVIGATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Jump to last position when loading a file if we can
(autocmd ["BufReadPost"]
         {:pattern ["*"]
          :callback #(let [[row col] (vim.api.nvim_buf_get_mark 0 "\"")
                           lastrow (vim.api.nvim_buf_line_count 0)]
                       (when (and (> row 0) (<= row lastrow))
                         (vim.api.nvim_win_set_cursor 0 [row col])))})

; Disable arrow keys for navigation
(nmap! <up> "<nop>"
       <down> "<nop>"
       <left> "<nop>"
       <right> "<nop>")

; Make j and k move up and down better for wrapped lines
(nnoremap! k "gk"
           j "gj"
           gk "k"
           gj "j")

; Ctrl-<hjkl> to change splits
(descnmap!
  "Go to the left window" <C-h> "<C-w>h"
  "Go to the down window" <C-j> "<C-w>j"
  "Go to the up window" <C-k> "<C-w>k"
  "Go to the right window" <C-l> "<C-w>l")

; Jumping between buffers
(nmap! <C-n> "<cmd>bnext<CR>"
       <C-p> "<cmd>bprev<CR>"
       <C-e> "<cmd>b#<CR>")

; Let <C-n> and <C-p> also filter through command history
(map! "c" <C-n> "<down>"
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GLOBAL MAPPINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Make joins keep the cursor in the same spot in the window
(nnoremap! J "mzJ`z")

; Unmap ex mode
(nmap! Q "<nop>")

(descnmap!
  "Clear trailing whitespace"
  <leader>ew "<cmd>keeppatterns %s/\\s\\+$//e<CR><C-o>"

  "Convert tabs to 2 spaces"
  <leader>et2 "<cmd>keeppatterns %s/\t/  /eg<CR><C-o>"
  "Convert tabs to 4 spaces"
  <leader>et4 "<cmd>keeppatterns %s/\t/    /eg<CR><C-o>"
  "Convert tabs to 8 spaces"
  <leader>et8 "<cmd>keeppatterns %s/\t/        /eg<CR><C-o>"

  "Select whole buffer"
  vag "ggVGg_"

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
  <leader><space> #(call-module-func :blinker "blink_cursorline")

  ; Window (split) management
  "Split vertically"
  <leader>wv "<cmd>vsplit<CR>"
  "Split horizontally"
  <leader>ws "<cmd>split<CR>"
  "Close split"
  <leader>wd "<cmd>close<CR>"
  "Close other splits"
  <leader>wo "<cmd>only<CR>"
  "Switch split"
  <leader>ww "<C-w>w"

  ; "Toggle NvimTree"
  ; <leader>ft "<cmd>NvimTreeToggle<CR>"
  "Toggle Neo-tree"
  <leader>ft "<cmd>Neotree toggle<CR>"
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
  "Git log current file"
  <leader>gf "<cmd>GV!<CR>"
  "Open Neogit"
  <leader>gg "<cmd>Neogit<CR>"
  "Show commit message at line"
  <leader>gm "<cmd>GitMessenger<CR>"
  "Open selected file in github"
  <leader>go "<cmd>GBrowse<CR>"

  ; telescope.nvim
  "Find files in project"
  <leader>pf #(call-module-func "telescope.builtin" "git_files")
  "Find TODOs in project"
  <leader>pt "<cmd>TodoTelescope<CR>"
  "File files from CWD"
  <leader>ff #(call-module-func "telescope.builtin" "find_files")
  "Find buffer"
  <leader>bb #(call-module-func "telescope.builtin" "buffers")
  "Find mark"
  <leader>fm #(call-module-func "telescope.builtin" "marks")
  "Find jump"
  <leader>fj #(call-module-func "telescope.builtin" "jumplist")
  "Grep file content from CWD"
  <leader>frg #(call-module-func "telescope.builtin" "live_grep")
  "Search help"
  <leader>hh #(call-module-func "telescope.builtin" "help_tags")
  "Search highlights"
  <leader>hH #(call-module-func "telescope.builtin" "highlights")
  "Search autocommands"
  <leader>ha #(call-module-func "telescope.builtin" "autocommands")
  "Search keymaps"
  <leader>hk #(call-module-func "telescope.builtin" "keymaps")
  "Search man pages"
  <leader>hm #(call-module-func "telescope.builtin" "man_pages")
  "Search ex commands"
  "<leader>:" #(call-module-func "telescope.builtin" "commands"))

(set! signcolumn "yes")
(fn toggle-sign-column []
  (if (= (get? signcolumn) "yes")
    (set! signcolumn "no")
    (set! signcolumn "yes")))
(descnmap! "Toggle sign column"
          <leader>tg toggle-sign-column)

(descnmap! "Toggle showing listchars"
           <leader>tt "<cmd>set list!<CR>")
(set-true! list)

(set! listchars "eol:¬,nbsp:␣,conceal:⋯,tab:  ,precedes:…,extends:…,trail:•")

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
(map! "v" "<leader>c " "gc")

; Simulate readline/emacs's jump to start/end of line in insert mode
(map! "i" <C-a> "<ESC>I"
      "i" <C-e> "<ESC>A")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Specific language settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Use github-flavored markdown
(augroup :markdown
         [[:BufNewFile :BufRead]
          {:pattern "*.md"
           :callback #(set! filetype "ghmarkdown")}])

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

{}
