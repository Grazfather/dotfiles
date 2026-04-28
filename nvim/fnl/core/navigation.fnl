(import-macros {: call-module-func : setup : keys!} :macros)

[{1 "ibhagwan/fzf-lua"
  :dependencies ["kyazdani42/nvim-web-devicons"]
  :opts {:git {:files {:cmd "git ls-files --exclude-standard ':!:vendor'"}}
         :lines {:fzf_opts {"--with-nth" "2.."}}}}
 {1 "nvim-neo-tree/neo-tree.nvim"
  :keys (keys! "Toggle Neo-tree"
               :n "<leader>tf" "<cmd>Neotree toggle<CR>")
  :dependencies ["nvim-lua/plenary.nvim"
                 "kyazdani42/nvim-web-devicons"
                 "MunifTanjim/nui.nvim"]}
 {1 "simrat39/symbols-outline.nvim"
  :keys (keys! "Toggle symbols-outline"
               :n "<leader>ts" "<cmd>SymbolsOutline<CR>")
  :config true}
 {1 "folke/flash.nvim"
  :event :VeryLazy
  :opts {:labels "arstneiozxcdh,./qwfpluy;ARSTNEIOZXCDH<>?QWFPLUY:1234567890"}
  :config (fn [_ opts]
            (setup :flash opts)
            -- Make the labels less hard to read.
            (vim.api.nvim_set_hl 0 :FlashLabel {:link :Folded}))
  :keys (keys! "Flash"
               [:n :x :o] :s #(call-module-func :flash :jump)

               "Flash Treesitter"
               [:n :x :o] :S #(call-module-func :flash :treesitter)

               "Remote Flash"
               :o :r #(call-module-func :flash :remote)

               "Treesitter Search"
               [:o :x] :R #(call-module-func :flash :treesitter_search)

               "Toggle Flash Search"
               [:c] :<c-s> #(call-module-func :flash :toggle)

               "Jump line upwards"
               ["n" "v"] "<leader>k" #(call-module-func :flash :jump {:search {:mode :search
                                                                               :forward false
                                                                               :wrap false}
                                                                      :label {:after [0 0]}
                                                                      :pattern "^"})

               "Jump line downwards"
               ["n" "v"] "<leader>j" #(call-module-func :flash :jump {:search {:mode :search
                                                                               :forward true
                                                                               :wrap false}
                                                                      :label {:after [0 0]}
                                                                      :pattern "^"}))}
 {1 "stevearc/aerial.nvim"
  :config true}]
