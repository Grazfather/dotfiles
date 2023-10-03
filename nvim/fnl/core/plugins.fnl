(import-macros {: setup
                : call-module-func} :core.macros)

[
 ; Profile with :StartupTime
 "tweekmonster/startuptime.vim"

 ; Language support
 {1 "williamboman/mason.nvim" :build ":MasonUpdate" :config true}
 ; -- Markdown
 "jtratner/vim-flavored-markdown"
 ; -- Lisps
 {1 "Grazfather/sexp.nvim"
  :lazy true
  :ft ["clojure" "scheme" "lisp" "timl" "fennel" "janet"]
  :opts {:filetypes "clojure,scheme,lisp,timl,fennel,janet"}
  :dependencies "tpope/vim-repeat"}
 ; ---- Connection to various lisp REPLs
 {1 "Olical/conjure" :lazy true :ft ["clojure" "fennel" "janet"]}
 ; -- Clojure
 {1 "borkdude/clj-kondo" :lazy true :ft ["clojure"]}
 ; -- Janet
 "janet-lang/janet.vim"
 ; -- Fennel
 "jaawerth/fennel.vim"
 ; -- Solidity
 "tomlion/vim-solidity"


 ; Git
 "tpope/vim-fugitive"
 {1 "TimUntersberger/neogit"
  :dependencies ["nvim-lua/plenary.nvim"]}
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
 {1 "numToStr/Comment.nvim" :config true}
 {1 "kylechui/nvim-surround" :config true}
 "mbbill/undotree"]
