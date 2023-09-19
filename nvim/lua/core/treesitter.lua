-- [nfnl] Compiled from fnl/core/treesitter.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  return (require("nvim-treesitter.configs")).setup({playground = {enable = true}, highlight = {enable = true, additional_vim_regex_highlighting = {"clojure", "fennel"}}, indent = {enable = false}, incremental_selection = {enable = true, keymaps = {init_selection = "gh", node_incremental = "gh", node_decremental = "ghd", scope_incremental = "ghu"}}, rainbow = {enable = true, disable = {}, extended_mode = false}, textobjects = {select = {enable = true, keymaps = {aa = "@parameter.outer", ia = "@parameter.inner", af = "@function.outer", ["if"] = "@function.inner", ac = "@class.outer", ic = "@class.inner"}}, swap = {enable = true, swap_next = {["<M-l>"] = "@parameter.inner"}, swap_previous = {["<M-h>"] = "@parameter.inner"}}}, ensure_installed = {"bash", "clojure", "cpp", "fennel", "go", "gomod", "gosum", "javascript", "json", "make", "markdown", "proto", "python", "query", "toml", "regex", "yaml", "zig", "c", "help", "lua", "vim"}})
end
local function _2_()
  return (require("treesitter-context")).setup()
end
return {{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = _1_}, {"nvim-treesitter/nvim-treesitter-context", config = _2_}, "nvim-treesitter/nvim-treesitter-textobjects", "nvim-treesitter/playground", "p00f/nvim-ts-rainbow"}
