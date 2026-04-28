(module config
        {require-macros [macros]})

; First load lazy.nvim, setting up all plugins
(setup :lazy :core {:change_detection { :notify false }})

(local dm (require :deleteme))

; Setup tags file
(set! tags "./tags,tags;")

; Set path to include the cwd and everything underneath
(set! path "**3")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NAVIGATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Jump to last position when loading a file if we can
(vim.api.nvim_create_autocmd
  :BufReadPost
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
(cmap! <C-n> "<down>"
       <C-p> "<up>")

; Let indents in visual mode keep the selection
(xnoremap! "v"
           < "<gv"
           > ">gv")

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

; Use indent level to determine how to indent wrapped lines
(set-true! breakindent)

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
  "Delete all DELETEME lines"
  <leader>dd dm.delete-deleteme-lines
  ; Add 'DELETEME' comment using Comment.nvim
  "Add DELETEME comment"
  <leader>dm "mxgcADELETEME<ESC>`x")
(descxmap! "v"
           "Add DELETEME comment"
           <leader>dm dm.add-delete-markers)

(descnmap!
  "Clear trailing whitespace"
  <leader>ew "<cmd>keeppatterns %s/\\s\\+$//e<CR><C-o>"

  "Convert tabs to 2 spaces"
  <leader>et2 "<cmd>keeppatterns %s/\t/  /eg<CR><C-o>"
  "Convert tabs to 4 spaces"
  <leader>et4 "<cmd>keeppatterns %s/\t/    /eg<CR><C-o>"
  "Convert tabs to 8 spaces"
  <leader>et8 "<cmd>keeppatterns %s/\t/        /eg<CR><C-o>"

  "Open new empty buffer"
  <leader>en "<cmd>enew<CR>"

  "Select whole buffer"
  vag "ggVGg_"

  "Close current buffer"
  <leader>bd "<cmd>bp|bd #<CR>"
  "Force close current buffer"
  <leader>bD "<cmd>bp|bd! #<CR>"
  "Save buffer"
  <leader>es "<cmd>write<CR>"

  "Toggle search highlighting"
  <leader>th "<cmd>set hlsearch!<CR>"
  "Toggle showing relative line numbers"
  <leader>tl "<cmd>set number! relativenumber!<CR>"
  "Toggle cursor highlighting"
  <leader>tx "<cmd>set cursorline! cursorcolumn!<CR>"
  "Highlight occurrences of the word under the cursor"
  <leader>* (fn []
              (vim.fn.setreg "/" (.. "\\<" (vim.fn.expand "<cword>") "\\>"))
              (set-true! hlsearch))

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
  "Resize windows evently"
  <leader>w= "<C-w>="

  "Toggle Undotree"
  <leader>tu "<cmd>UndotreeToggle<CR>")

(fn toggle-quickfix []
  (let [qfwins (vim.tbl_filter (fn [w]
                                 (= w.quickfix 1))
                               (vim.fn.getwininfo))
        quickfix-open? (> (length qfwins) 0)
        cmd (if quickfix-open? vim.cmd.cclose vim.cmd.copen)]
    (cmd)))

(descnmap!
  "Go to next in quickfix"
  <leader>cn ":cnext<CR>zz"
  "Go to previous in quickfix"
  <leader>cp ":cprevious<CR>zz"
  "Open quickfix window"
  <leader>co vim.cmd.copen
  "Close quickfix window"
  <leader>cd vim.cmd.close
  "Toggle quickfix window"
  <leader>cc toggle-quickfix)

(set! signcolumn "yes")
(fn toggle-sign-column []
  (if (= (. vim.opt.signcolumn :get) "yes")
    (set! signcolumn "no")
    (set! signcolumn "yes")))
(set-true! list)

(set! listchars {:eol "¬"
                 :nbsp "␣"
                 :conceal "⋯"
                 :tab "  "
                 :precedes "…"
                 :extends "…"
                 :trail "•"})

(descnmap!
  "Toggle sign column"
  <leader>tg toggle-sign-column
  "Toggle showing listchars"
  <leader>tt "<cmd>set list!<CR>"
  "Toggle indent markers"
  <leader>ti #(vim.cmd "IBLToggle")
  "Toggle visual glyphs"
  <leader>tv (fn []
               (toggle-sign-column)
               (set-toggle! list number relativenumber)
               (vim.cmd "IBLToggle")))

; Simulate readline/emacs's jump to start/end of line in insert mode
(imap! <C-a> "<ESC>I"
       <C-e> "<ESC>A")
