(import-macros {: set!} :macros)

[
 ; META (Vim config stuff)
 ; -- Aniseed itself, to compile fennel
 {1 "Olical/aniseed" :lazy true}
 ; Profile with :StartupTime
 "tweekmonster/startuptime.vim"

 ; Language support
 {1 "williamboman/mason.nvim" :build ":MasonUpdate" :config true}
 ; -- Markdown
 {1 "jtratner/vim-flavored-markdown"
  :ft ["markdown"]
  :config (fn []
            ; Use github-flavored markdown
            (vim.api.nvim_create_augroup :markdown {})
            (vim.api.nvim_create_autocmd
              [:BufNewFile :BufRead]
              {:pattern "*.md"
               :group :markdown
               :callback #(set! filetype "ghmarkdown")}))}
 ; -- Lisps
 {1 "Grazfather/sexp.nvim"
  :ft ["clojure" "scheme" "lisp" "timl" "fennel" "janet"]
  :opts {:filetypes "clojure,scheme,lisp,timl,fennel,janet"}
  :dependencies ["tpope/vim-repeat"]}
 ; ---- Connection to various lisp REPLs
 {1 "Olical/conjure" :ft ["clojure" "fennel" "janet"]}
 ; -- Clojure
 {1 "borkdude/clj-kondo" :ft ["clojure"]}
 ; -- Janet
 "janet-lang/janet.vim"
 ; -- Fennel
 "jaawerth/fennel.vim"
 ; -- Solidity
 "tomlion/vim-solidity"

 ; Git
 "tpope/vim-fugitive"
 {1 "TimUntersberger/neogit"
  :dependencies ["nvim-lua/plenary.nvim" "sindrets/diffview.nvim"]
  :config true}
 ; -- Adds :GBrowse
 "tpope/vim-rhubarb"
 ; -- Adds :GitMessenger
 "rhysd/git-messenger.vim"
 ; -- Adds :GV to browse history
 "junegunn/gv.vim"
 ; -- Adds changed lines in the gutter
 {1 "lewis6991/gitsigns.nvim"
  :dependencies ["nvim-lua/plenary.nvim"]
  :config true}

 ; Misc
 "szw/vim-maximizer"
 {1 "numToStr/Comment.nvim" :config true}
 {1 "kylechui/nvim-surround" :config true}
 "mbbill/undotree"
 {1 "stevearc/oil.nvim"
  :dependencies ["nvim-tree/nvim-web-devicons"]
  :config true}]
