(import-macros {: call-module-func : setup
                : set! : set-true!} :macros)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THEMES/VISUAL/LAYOUT/UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Status line
; Always show the status bar, one for all splits
(set! laststatus 2)

(each [name text (pairs {:DiagnosticSignError ""
                         :DiagnosticSignWarn ""
                         :DiagnosticSignHint ""
                         :DiagnosticSignInfo ""})]
  (vim.fn.sign_define name {:texthl name :text text :numhl ""}))

; Short timeoutlen to get which-key to kick in sooner
(set! timeoutlen 200)

; Highlight the text I yank
(vim.api.nvim_create_autocmd :TextYankPost {:callback #(vim.highlight.on_yank)})

; Smoothscroll to not scroll past soft-wrapped lines
(set-true! smoothscroll)

; Highlight trailing whitespace and spaces touching tabs
;   Lines ending with spaces:   
;   Mixed spaces and tabs (in either order):
;    	(Spaces then tabs))
;	    (Tabs then spaces))
(vim.fn.matchadd "TrailingWhitespace" "\\s\\+$\\| \\+\\ze\\t\\|\\t\\+\\ze ")
(vim.api.nvim_create_autocmd :ColorScheme
                             {:callback #(vim.api.nvim_set_hl 0 "TrailingWhitespace" {:bg :darkred})})

[
 ; Colorscheme
 {1 "folke/tokyonight.nvim"
  :lazy false
  :priority 1000
  :config (fn []
            (vim.cmd.colorscheme :tokyonight-night))}
 ; Status line
 {1 "hoob3rt/lualine.nvim"
  :dependencies ["kyazdani42/nvim-web-devicons"]
  :opts {:options {:theme :tokyonight
                   :component_separators {:left ""
                                          :right ""}
                   :section_separators {:left ""
                                        :right ""}}}}
 ; Show open buffers as a tab bar
 {1 "akinsho/bufferline.nvim"
  :dependencies ["kyazdani42/nvim-web-devicons"]
  :opts {:options {:diagnostics :nvim_lsp
                   :separator_style :slant
                   :show_buffer_close_icon false
                   :show_close_icon false
                   :offsets [{:filetype :neo-tree
                              :text "File explorer"}]}}}
 {1 "lukas-reineke/indent-blankline.nvim" :main "ibl" :config true}

 ; Show hints for key bindings
 ; -- I tend to use leader a lot, so I try to namespace commands under leader
 ; -- using a simple mnemonic:
 {1 "folke/which-key.nvim"
  :config #(call-module-func :which-key :register
                             {:b {:name "Buffer stuff"}
                              :e {:name "Edit stuff"}
                              :g {:name "Git"}
                              :h {:name "Help"}
                              :m {:name "Local leader"}
                              :f {:name "File/find ops"}
                              :t {:name "Toggles"}
                              :w {:name "Window"}
                              :x {:name "Lisp"}}
                             {:prefix :<leader>})}
; Highlight special words in comments
{1 "folke/todo-comments.nvim"
 :dependencies ["nvim-lua/plenary.nvim"]
 :opts {:keywords {
                   ; DELETEME:
                   :DELETEME {:icon "✗" :color "error"}
                   ; TODO:
                   :TODO {:icon " " :color "info"}
                   ; HACK:
                   :HACK {:icon " " :color "warning"}
                   ; WARN:
                   :WARN {:icon " " :color "warning" :alt ["WARNING" "XXX"]}
                   ; NOTE:
                   :NOTE {:icon " " :color "hint" :alt  ["INFO"]}}
        ; I set the colon to optional for DELETEME comments
        :highlight {:pattern ".*<(KEYWORDS)\\s*:?"}}}
 {1 "Grazfather/blinker.nvim"
  :config true}
 ; Start page
 {1 "goolord/alpha-nvim"
  :dependencies ["kyazdani42/nvim-web-devicons"]
  :config #(setup :alpha
                  (. (require "alpha.themes.startify") :config))}
 {1 "rcarriga/nvim-notify"
  :event ["VeryLazy"]
  :config #(let [notify (require :notify)]
             (tset vim :notify notify))}
 {1 "akinsho/toggleterm.nvim"
  :opts {:open_mapping "<c-\\>"
         :direction :tab}}]
