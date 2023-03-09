(module core.plugins
  {autoload {lazy lazy}
   require-macros [core.macros]})

(lazy.setup
  [
   ; META (Vim config stuff)
   ; -- Impatient speeds up startup
   "lewis6991/impatient.nvim"
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
   {1 "folke/which-key.nvim"
    :config (setup-module-fn! :which-key)}
   {1 "folke/todo-comments.nvim"
    :dependencies "nvim-lua/plenary.nvim"}
   {1 "Grazfather/blinker.nvim"
    :config (setup-module-fn! :blinker {})}
   "akinsho/toggleterm.nvim"
   "mbbill/undotree"

   ; Navigation
   {1 "nvim-telescope/telescope.nvim"
    :dependencies ["nvim-lua/plenary.nvim"]}
   {1 "kyazdani42/nvim-tree.lua"
    :dependencies ["kyazdani42/nvim-web-devicons"]
    :config (setup-module-fn! :nvim-tree)}
   ; -- hopping (bound to gl)
   "phaazon/hop.nvim"
   ; -- Override f/t & add sniping via s
   "ggandor/leap.nvim"

   ; Language support
   ; -- LSP
   "neovim/nvim-lspconfig"
   "onsails/lspkind-nvim"
   ; -- Parsing
   {1 "nvim-treesitter/nvim-treesitter" :build ":TSUpdate"}
   "nvim-treesitter/nvim-treesitter-textobjects"
   "nvim-treesitter/playground"
   "nvim-treesitter/nvim-treesitter-context"
   "p00f/nvim-ts-rainbow"
   ; -- Completion
   "hrsh7th/nvim-cmp"
   "hrsh7th/cmp-buffer"
   "hrsh7th/cmp-nvim-lsp"
   "saadparwaiz1/cmp_luasnip"
   "L3MON4D3/LuaSnip"
   "rafamadriz/friendly-snippets"
   ; -- Go
   "fatih/vim-go"
   ; -- Markdown
   "jtratner/vim-flavored-markdown"
   ; -- Lisps
   "guns/vim-sexp"
   ; -- Clojure
   ; ---- Connection to nREPL
   "Olical/conjure"
   ; ---- Linting
   "borkdude/clj-kondo"
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
    :config (setup-module-fn! :gitsigns)}

   ; Misc
   {1 "numToStr/Comment.nvim"
    :config (setup-module-fn! :Comment)}
   {1 "kylechui/nvim-surround"
    :config (setup-module-fn! :nvim-surround)}

   ; Themes
   "morhetz/gruvbox"
   "shaunsingh/nord.nvim"
   "navarasu/onedark.nvim"
   ])
