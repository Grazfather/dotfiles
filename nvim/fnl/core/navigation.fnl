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
 ; Add targets to 's'/'S'
 {1 "ggandor/leap.nvim"
  :event "VeryLazy"
  :keys [{1 "s" :mode ["n" "x" "o"] 2 "<Plug>(leap-forward)"}
         {1 "S" :mode ["n" "x" "o"] 2 "<Plug>(leap-backward)"}
         {1 "<leader>l" :mode ["n"] 2 "<Plug>(leap-from-window)"}]
  :config #(let [opts (require :leap.opts)]
             ; Labels better for my keyboard layout + preference
             (tset opts :labels (.. "arstneio"
                                    "zxcdh,./"
                                    "qwfpluy;"
                                    "ARSTNEIO"
                                    "ZXCDH<>?"
                                    "QWFPLUY:"))
             (tset opts :safe_labels "")

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
 {1 "stevearc/aerial.nvim"
  :config true}]
