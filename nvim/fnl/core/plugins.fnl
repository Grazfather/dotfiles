(import-macros {: keys!} :macros)

[
 ; META (Vim config stuff)
 ; -- Aniseed itself, to compile fennel
 {1 "Olical/aniseed" :lazy true}
 ; Profile with :StartupTime
 "tweekmonster/startuptime.vim"

 ; Language support
 ; -- Markdown
 {1 "MeanderingProgrammer/render-markdown.nvim"
  :depencencies  ["nvim-treesitter/nvim-treesitter" "nvim-tree/nvim-web-devicons"]
  :opts {:file_types  ["markdown"]}
  :ft ["markdown"]}
 ; -- Lisps
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
 {1 "Grazfather/sexp.nvim"
  :ft ["clojure" "scheme" "lisp" "timl" "fennel" "janet"]
  :opts {:filetypes "clojure,scheme,lisp,timl,fennel,janet"}
  :dependencies ["tpope/vim-repeat"]
  :keys (keys! "Slurp from right" "n" <leader>xs "<Plug>(sexp_capture_next_element)"
               "Slurp from left" "n" <leader>xS "<Plug>(sexp_capture_prev_element)"
               "Barf from right" "n" <leader>xe "<Plug>(sexp_emit_tail_element)"
               "Barf from left" "n" <leader>xE "<Plug>(sexp_emit_head_element)"
               "Convolute" "n" <leader>xc "<Plug>(sexp_convolute)"
               "Drag forward" "n" <leader>xl "<Plug>(sexp_swap_element_forward)"
               "Drag back" "n" <leader>xh "<Plug>(sexp_swap_element_backward)"
               "Next element" "n" <leader>xw "<Plug>(sexp_move_to_next_element_head)"
               "Previous element" "n" <leader>xb "<Plug>(sexp_move_to_prev_element_head)")}
 ; ---- Connection to various lisp REPLs
 {1 "Olical/conjure" :ft ["clojure" "fennel" "janet"]}
 ; -- Clojure
 {1 "borkdude/clj-kondo" :ft ["clojure"]}
 ; -- Janet
 {1 "janet-lang/janet.vim" :ft ["janet"]}
 ; -- Fennel
 {1 "jaawerth/fennel.vim" :ft ["fennel"]}
 ; -- Solidity
 "tomlion/vim-solidity"

 ; Misc
 {1 "szw/vim-maximizer"
  :keys (keys! "Toggle window zoom" "n" <leader>wz "<cmd>MaximizerToggle<CR>")}
 {1 "numToStr/Comment.nvim" :config true}
 {1 "echasnovski/mini.surround"
  :version "*"
  :opts {:mappings {:add "<leader>sa"
                    :delete "<leader>sd"
                    :find "<leader>sf"
                    :find_left "<leader>sF"
                    :highlight "<leader>sh"
                    :replace "<leader>sr"
                    :update_n_lines "<leader>sn"}}}
 {1 "mbbill/undotree"
  :keys (keys! "Toggle Undotree" "n" <leader>tu "<cmd>UndotreeToggle<CR>")}
 {1 "stevearc/oil.nvim"
  :dependencies ["nvim-tree/nvim-web-devicons"]
  :config true}]
