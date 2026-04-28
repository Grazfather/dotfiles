(import-macros {: keys!} :macros)

[; Git & VCS
 {1 "tpope/vim-fugitive"
  :keys (keys! "Git blame"
               "n" <leader>gb "<cmd>Git blame<CR>"

               "Git diff"
               "n" <leader>gd "<cmd>Git diff<CR>"

               "Git status"
               "n" <leader>gs "<cmd>Git status<CR>"

               "Open selected file in github"
               "n" <leader>go "<cmd>GBrowse<CR>")}

 {1 "TimUntersberger/neogit"
  :dependencies ["nvim-lua/plenary.nvim" "sindrets/diffview.nvim"]
  :config true
  :keys (keys! "Open Neogit"
               "n" <leader>gg "<cmd>Neogit<CR>")}

 ; -- Adds :GBrowse
 "tpope/vim-rhubarb"

 ; -- Adds :GitMessenger
 {1 "rhysd/git-messenger.vim"
  :keys (keys! "Show commit message at line"
               "n" <leader>gm "<cmd>GitMessenger<CR>")}

 ; -- Adds :GV to browse history
 {1 "junegunn/gv.vim"
  :keys (keys! "Git log"
               "n" <leader>gl "<cmd>GV<CR>"

               "Git log current file"
               "n" <leader>gf "<cmd>GV!<CR>")}

 ; -- Adds changed lines in the gutter
 {1 "lewis6991/gitsigns.nvim"
  :dependencies ["nvim-lua/plenary.nvim"]
  :config true}]
