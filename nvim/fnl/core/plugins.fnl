(module core.plugins
  {autoload {packer packer}})

(packer.startup
  (fn []
    ; META (Vim config stuff)
    ; -- Packer itself
    (use "wbthomason/packer.nvim")
    ; -- Impatient speeds up startup
    (use "lewis6991/impatient.nvim")
    ; -- Aniseed itself, to compile fennel
    (use "Olical/aniseed")
    ; -- Profile with :StartupTime
    (use "tweekmonster/startuptime.vim")
    ; -- Speed up setting up filetypes to improve startup time
    (use "nathom/filetype.nvim")

    (use {1 "hoob3rt/lualine.nvim"
          :requires "kyazdani42/nvim-web-devicons"})
    (use {1 "akinsho/bufferline.nvim"
          :requires "kyazdani42/nvim-web-devicons"})
    (use "folke/which-key.nvim")

    ; Navigation
    (use {1 "junegunn/fzf" :run (fn [] (vim.fn "-> fzf#install()")) })
    (use {1 "ibhagwan/fzf-lua"
          :requires ["vijaymarupudi/nvim-fzf" "kyazdani42/nvim-web-devicons"]})
    (use "edkolev/tmuxline.vim")
    (use "kyazdani42/nvim-tree.lua")
    (use "ryanoasis/vim-devicons")
    ; -- hopping (bound to gsj & gsk)
    (use "phaazon/hop.nvim")
    ; -- Override f/t & add sniping via s
    (use "ggandor/lightspeed.nvim")

    ; Language support
    ; -- LSP
    (use "neovim/nvim-lspconfig")
    (use "onsails/lspkind-nvim")
    ; -- Parsing
    (use {1 "nvim-treesitter/nvim-treesitter" :run ":TSUpdate"})
    (use "nvim-treesitter/nvim-treesitter-textobjects")
    (use "nvim-treesitter/playground")
    (use "p00f/nvim-ts-rainbow")
    ; -- Completion
    (use "hrsh7th/nvim-cmp")
    (use "hrsh7th/cmp-buffer")
    (use "hrsh7th/cmp-nvim-lsp")
    (use "saadparwaiz1/cmp_luasnip")
    (use "L3MON4D3/LuaSnip")
    (use "rafamadriz/friendly-snippets")
    ; -- Go
    (use "fatih/vim-go")
    ; -- Markdown
    (use "jtratner/vim-flavored-markdown")
    ; -- Lisps
    (use "guns/vim-sexp")
    ; -- Clojure
    ; ---- Connection to nREPL
    (use {1 "liquidz/vim-iced" :ft ["clojure"]})
    ; ---- Linting
    (use "borkdude/clj-kondo")
    : -- Janet
    (use "janet-lang/janet.vim")
    ; -- Fennel
    (use "bakpakin/fennel.vim")
    ; -- Solidity
    (use "tomlion/vim-solidity")

    ; Git
    (use "tpope/vim-fugitive")
    (use {1 "TimUntersberger/neogit"
          :requires ["nvim-lua/plenary.nvim"]})
    ; -- Adds :Gbrowse
    (use "tpope/vim-rhubarb")
    ; -- Adds :GV to browse history
    (use "junegunn/gv.vim")
    ; -- Adds changed lines in the gutter
    (use {1 "lewis6991/gitsigns.nvim"
          :requires ["nvim-lua/plenary.nvim"]})

    ; Misc
    (use "numToStr/Comment.nvim")
    (use "tpope/vim-surround")

    ; Themes
    (use "morhetz/gruvbox")
    (use "shaunsingh/nord.nvim")))
