(import-macros {: call-module-func} :macros)

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
 {1 "folke/flash.nvim"
  :event :VeryLazy
  :opts {:labels "arstneiozxcdh,./qwfpluy;ARSTNEIOZXCDH<>?QWFPLUY:1234567890"}
  :keys [{1 :s
          :mode [:n :x :o]
          :desc "Flash"
          2 #(call-module-func :flash :jump)}
         {1 :S
          :mode [:n :x :o]
          :desc "Flash Treesitter"
          2 #(call-module-func :flash :treesitter)}
         {1 :r
          :mode :o
          :desc "Remote Flash"
          2 #(call-module-func :flash :remote)}
         {1 :R
          :mode [:o :x]
          :desc "Treesitter Search"
          2 #(call-module-func :flash :treesitter_search)}
         {1 :<c-s>
          :mode [:c]
          :desc "Toggle Flash Search"
          2 #(call-module-func :flash :toggle)}
         {1 "<leader>k"
          :mode ["n" "v"]
          :desc "Jump line upwards"
          2 #(call-module-func :flash :jump {:search {:mode :search
                                                      :forward false
                                                      :wrap false}
                                             :label {:after [0 0]}
                                             :pattern "^"})}
         {1 "<leader>j"
          :mode ["n" "v"]
          :desc "Jump line downwards"
          2 #(call-module-func :flash :jump {:search {:mode :search
                                                      :forward true
                                                      :wrap false}
                                             :label {:after [0 0]}
                                             :pattern "^"})}]}
 {1 "stevearc/aerial.nvim"
  :config true}]
