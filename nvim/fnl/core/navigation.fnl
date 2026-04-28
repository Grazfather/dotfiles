(import-macros {: call-module-func : setup : keys!} :macros)

[{1 "ibhagwan/fzf-lua"
  :dependencies ["kyazdani42/nvim-web-devicons"]
  :opts {:git {:files {:cmd "git ls-files --exclude-standard ':!:vendor'"}}
         :lines {:fzf_opts {"--with-nth" "2.."}}}
  :keys (keys! "Find files in project"
               "n" <leader>fp #(call-module-func "fzf-lua" "git_files")

               "Find files from CWD"
               "n" <leader>ff #(call-module-func "fzf-lua" "files")

               "Find buffer"
               "n" <leader>bb #(call-module-func "fzf-lua" "buffers")

               "Find mark"
               "n" <leader>fm #(call-module-func "fzf-lua" "marks")

               "Find jump"
               "n" <leader>fj #(call-module-func "fzf-lua" "jumps")

               "Code action"
               "n" <leader>ca #(call-module-func "fzf-lua" "lsp_code_actions")

               "Find symbol"
               "n" <leader>fs #(call-module-func "aerial" "fzf_lua_picker")

               "Find register"
               "n" <leader>fr #(call-module-func "fzf-lua" "registers")

               "Find text in open buffers"
               "n" <leader>fl #(call-module-func "fzf-lua" "lines")

               "Grep file content from CWD"
               "n" <leader>fg #(call-module-func "fzf-lua" "live_grep")

               "Search help"
               "n" <leader>hh #(call-module-func "fzf-lua" "help_tags")

               "Search highlights"
               "n" <leader>hH #(call-module-func "fzf-lua" "highlights")

               "Search autocommands"
               "n" <leader>ha #(call-module-func "fzf-lua" "autocmds")

               "Search keymaps"
               "n" <leader>hk #(call-module-func "fzf-lua" "keymaps")

               "Search man pages"
               "n" <leader>hm #(call-module-func "fzf-lua" "man_pages")

               "Search ex commands"
               "n" "<leader>:" #(call-module-func "fzf-lua" "commands"))}
 {1 "nvim-neo-tree/neo-tree.nvim"
  :keys (keys! "Toggle Neo-tree" "n" "<leader>tf" "<cmd>Neotree toggle<CR>")
  :dependencies ["nvim-lua/plenary.nvim"
                 "kyazdani42/nvim-web-devicons"
                 "MunifTanjim/nui.nvim"]}
 {1 "simrat39/symbols-outline.nvim"
  :keys (keys! "Toggle symbols-outline" "n" "<leader>ts" "<cmd>SymbolsOutline<CR>")
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
