-- [nfnl] Compiled from fnl/core/navigation.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  do end (require("telescope")).setup({pickers = {git_files = {file_ignore_patterns = {"^vendor/"}}}})
  return (require("telescope")).load_extension("fzf")
end
local function _2_()
  do end (require("leap")).add_default_mappings()
  do end (require("leap.opts"))["labels"] = {"a", "r", "s", "t", "n", "e", "i", "o", "z", "x", "c", "d", "h", ",", ".", "/", "q", "w", "f", "p", "l", "u", "y", ";", "A", "R", "S", "T", "N", "E", "I", "O", "Z", "X", "C", "D", "H", "<", ">", "?", "Q", "W", "F", "P", "L", "U", "Y", ":"}
  require("leap.opts")["safe_labels"] = {}
  local group = vim.api.nvim_create_augroup("LeapCustom", {clear = true})
  local function _3_()
    return vim.api.nvim_set_hl(0, "LeapBackdrop", {link = "Comment"})
  end
  vim.api.nvim_create_autocmd({"ColorScheme"}, {callback = _3_, group = group})
  return nil
end
local function _4_()
  return (require("leaplines")).leap("up")
end
local function _5_()
  return (require("leaplines")).leap("down")
end
local function _6_()
  return (require("leap-ast")).leap()
end
return {{"nvim-telescope/telescope.nvim", config = _1_, dependencies = {"nvim-lua/plenary.nvim", {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}}}, {"nvim-neo-tree/neo-tree.nvim", dependencies = {"nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim"}}, {"ggandor/leap.nvim", dependencies = "tpope/vim-repeat", config = _2_}, {"ggandor/flit.nvim", dependencies = "ggandor/leap.nvim", config = true}, {"ggandor/leap-spooky.nvim", dependencies = "ggandor/leap.nvim", config = true}, {"Grazfather/leaplines.nvim", dev = true, dir = "~/code/leaplines.nvim", dependencies = "ggandor/leap.nvim", keys = {{"<leader>k", _4_, mode = {"n", "v"}, desc = "Leap line upwards"}, {"<leader>j", _5_, mode = {"n", "v"}, desc = "Leap line downwards"}}}, {"ggandor/leap-ast.nvim", keys = {{"<leader>a", _6_, mode = {"n", "v"}, desc = "Leap up AST"}}}}
