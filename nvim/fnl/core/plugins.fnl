(module core.plugins
        {autoload {lazy lazy}
         require-macros [core.macros
                         aniseed.macros.autocmds]})

(lazy.setup
  [
   ; META (Vim config stuff)
   ; -- Aniseed itself, to compile fennel
   "Olical/aniseed"
   ; -- Profile with :StartupTime
   "tweekmonster/startuptime.vim"

   ; Visual/Layout
   {1 "hoob3rt/lualine.nvim"
    :dependencies "kyazdani42/nvim-web-devicons"}
   {1 "akinsho/bufferline.nvim"
    :dependencies "kyazdani42/nvim-web-devicons"}
   "lukas-reineke/indent-blankline.nvim"
   {1 "folke/which-key.nvim" :config true}
   {1 "folke/todo-comments.nvim"
    :dependencies "nvim-lua/plenary.nvim"}
   {1 "Grazfather/blinker.nvim" :config true}
   {1 "goolord/alpha-nvim"
    :dependencies ["kyazdani42/nvim-web-devicons"]
    :config #(setup :alpha
                    (. (require "alpha.themes.startify") :config))}
   {1 "folke/noice.nvim"
    :config true
    :dependencies ["MunifTanjim/nui.nvim"]}
   "akinsho/toggleterm.nvim"
   "mbbill/undotree"

   ; Navigation
   {1 "nvim-telescope/telescope.nvim"
    :dependencies ["nvim-lua/plenary.nvim"
                   {1 "nvim-telescope/telescope-fzf-native.nvim"
                    :build "make"}]}
   {1 "nvim-neo-tree/neo-tree.nvim"
    :dependencies ["nvim-lua/plenary.nvim"
                   "kyazdani42/nvim-web-devicons"
                   "MunifTanjim/nui.nvim"]}
   ; -- Add targets to 's'/'S'
   {1 "ggandor/leap.nvim"
    :dependencies "tpope/vim-repeat"
    :config (fn []
              (call-module-func :leap :add_default_mappings)
              ; Labels better for my keyboard layout + preference
              (tset (require :leap.opts) :labels [:a :r :s :t :n :e :i :o
                                                  :z :x :c :d :h "," "." "/"
                                                  :q :w :f :p :l :u :y ";"
                                                  :A :R :S :T :N :E :I :O
                                                  :Z :X :C :D :H "<" ">" "?"
                                                  :Q :W :F :P :L :U :Y ":"])
              (tset (require :leap.opts) :safe_labels [])
              (augroup :LeapCustom
                       [[:ColorScheme]
                        {:callback #(vim.api.nvim_set_hl 0
                                                         :LeapBackdrop
                                                         {:link :Comment})}]))}
   ; -- Override f/t
   {1 "ggandor/flit.nvim"
    :dependencies "ggandor/leap.nvim"
    :config true}
   ; -- Leap line-wise with `<leader>` h/j
   {1 "Grazfather/leaplines.nvim"
    :dev true
    :dir "~/code/leaplines.nvim"
    :dependencies "ggandor/leap.nvim"
    :keys [{1 "<leader>k"
            :mode ["n" "v"]
            :desc "Leap line upwards"
            2 #(call-module-func :leaplines :leap :up)}
           {1 "<leader>j"
            :mode ["n" "v"]
            :desc "Leap line downwards"
            2 #(call-module-func :leaplines :leap :down)}]}
   ; -- Jump up the AST hierarchy
   {1 "ggandor/leap-ast.nvim"
    :keys [{1 "<leader>a"
            :mode ["n" "v"]
            :desc "Leap up AST"
            2 #(call-module-func :leap-ast :leap)}]}

   ; Language support
   {1 "williamboman/mason.nvim" :build ":MasonUpdate" :config true}
   ; -- LSP
   "williamboman/mason-lspconfig.nvim"
   "neovim/nvim-lspconfig"
   "onsails/lspkind-nvim"
   "j-hui/fidget.nvim"
   {1 "jose-elias-alvarez/null-ls.nvim"
    :ft ["go"]
    :config #(let [null-ls (require :null-ls)
                   group (vim.api.nvim_create_augroup :LspFormatting {})]
               (setup :null-ls
                      {:sources [null-ls.builtins.formatting.gofmt
                                 null-ls.builtins.formatting.goimports]
                       :on_attach (fn [client bufnr]
                                    (autocmd [:BufWritePre]
                                             {:group group
                                              :buffer bufnr
                                              :callback #(vim.lsp.buf.format {:bufnr bufnr})}))}))}
   ; -- Parsing
   {1 "nvim-treesitter/nvim-treesitter" :build ":TSUpdate"}
   "nvim-treesitter/nvim-treesitter-textobjects"
   "nvim-treesitter/nvim-treesitter-context"
   "nvim-treesitter/playground"
   "p00f/nvim-ts-rainbow"
   ; -- Completion
  {1 "hrsh7th/nvim-cmp"
   :lazy true
   :event "InsertEnter"
   :dependencies ["hrsh7th/cmp-buffer" "hrsh7th/cmp-nvim-lsp"
                  "saadparwaiz1/cmp_luasnip" "L3MON4D3/LuaSnip"
                  "rafamadriz/friendly-snippets"]
   :config (. (require "core.completion") :config)}
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
   ; ---- Linting
   {1 "borkdude/clj-kondo" :lazy true :ft ["clojure"]}
   ; -- Janet
   "janet-lang/janet.vim"
   ; -- Fennel
   "bakpakin/fennel.vim"
   ; -- Solidity
   "tomlion/vim-solidity"

   ; Git
   "tpope/vim-fugitive"
   {1 "TimUntersberger/neogit"
    :dependencies ["nvim-lua/plenary.nvim"]}
   ; -- Adds :Gbrowse
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

   ; Themes
   "morhetz/gruvbox"
   "shaunsingh/nord.nvim"
   "navarasu/onedark.nvim"
   ])
