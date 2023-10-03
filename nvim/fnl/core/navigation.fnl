(import-macros {: call-module-func
                : setup} :core.macros)
(import-macros {: augroup} :aniseed.macros.autocmds)

[{1 "nvim-telescope/telescope.nvim"
  :config (fn []
            (setup :telescope
                   {:pickers {:git_files {:file_ignore_patterns ["^vendor/"]}}})
            (call-module-func :telescope :load_extension :fzf))
  :dependencies ["nvim-lua/plenary.nvim"
                 {1 "nvim-telescope/telescope-fzf-native.nvim"
                  :build "make"}]}
 {1 "nvim-neo-tree/neo-tree.nvim"
  :dependencies ["nvim-lua/plenary.nvim"
                 "kyazdani42/nvim-web-devicons"
                 "MunifTanjim/nui.nvim"]}
 ; Add targets to 's'/'S'
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
 ; Override f/t
 {1 "ggandor/flit.nvim"
  :dependencies "ggandor/leap.nvim"
  :config true}
 {1 "ggandor/leap-spooky.nvim"
  :dependencies "ggandor/leap.nvim"
  :config true}
 ; Leap line-wise with `<leader>` h/j
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
 ; Jump up the AST hierarchy
 {1 "ggandor/leap-ast.nvim"
  :keys [{1 "<leader>a"
          :mode ["n" "v"]
          :desc "Leap up AST"
          2 #(call-module-func :leap-ast :leap)}]}]
