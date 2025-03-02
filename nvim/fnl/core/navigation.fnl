(import-macros {: call-module-func
                : setup} :macros)

[{1 "ibhagwan/fzf-lua"
  :dependencies ["kyazdani42/nvim-web-devicons"]
  :opts {:git {:files {:cmd "git ls-files --exclude-standard ':!:vendor'"}}
         :lines {:fzf_opts {"--with-nth" "2.."}}}}
 {1 "nvim-neo-tree/neo-tree.nvim"
  :keys [{1 "<leader>tf"
          :desc "Toggle Neo-tree"
          2 "<cmd>Neotree toggle<CR>"}]
  :dependencies ["nvim-lua/plenary.nvim"
                 "kyazdani42/nvim-web-devicons"
                 "MunifTanjim/nui.nvim"]}
 {1 "simrat39/symbols-outline.nvim"
  :keys [{1 "<leader>ts"
          :desc "Toggle symbols-outline"
          2 "<cmd>SymbolsOutline<CR>"}]
  :config true}
 ; Add targets to 's'/'S'
 {1 "ggandor/leap.nvim"
  :dependencies ["tpope/vim-repeat"]
  :config #(let [opts (require :leap.opts)]
             (call-module-func :leap :add_default_mappings)
             ; Labels better for my keyboard layout + preference
             (tset opts :labels [:a :r :s :t :n :e :i :o
                                 :z :x :c :d :h "," "." "/"
                                 :q :w :f :p :l :u :y ";"
                                 :A :R :S :T :N :E :I :O
                                 :Z :X :C :D :H "<" ">" "?"
                                 :Q :W :F :P :L :U :Y ":"])
             (tset opts :safe_labels [])
             (vim.api.nvim_create_augroup :LeapCustom {})
             (vim.api.nvim_create_autocmd :ColorScheme
                                          {:group :LeapCustom
                                           :callback #(vim.api.nvim_set_hl 0
                                                                           :LeapBackdrop
                                                                           {:link :Comment})}))}
 ; Override f/t
 {1 "ggandor/flit.nvim"
  :dependencies ["ggandor/leap.nvim"]
  :config true}
 ; Leap line-wise with `<leader>` h/j
 {1 "Grazfather/leaplines.nvim"
  :dependencies ["ggandor/leap.nvim"]
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
  :dependencies ["ggandor/leap.nvim"]
  :keys [{1 "<leader>a"
          :mode ["n" "v"]
          :desc "Leap up AST"
          2 #(call-module-func :leap-ast :leap)}]}

 ; Add better text objects for `a` and `i`
 ; -- <action><a/i>[n/l]<textobject>
 ; -- a/i for all/inner as normal
 ; -- n/l for next or previous
 ; -- Text object can be e.g. (), {}, []
 ; -- -- Using the closing one will select with whitespace, opening without
 {1 "echasnovski/mini.ai"
  :version "*"
  :config true}
 ; Add a bunch of operators under `g`.
 ; -- gr replace motion with content of yank register
 ; -- gm multiply
 ; -- gx eXchange. Exchange one motion, then do again on a target motion
 ; -- gs sort
 {1 "echasnovski/mini.operators"
  :version "*"
  :config true}]
