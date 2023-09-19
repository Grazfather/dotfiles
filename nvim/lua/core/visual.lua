-- [nfnl] Compiled from fnl/core/visual.fnl by https://github.com/Olical/nfnl, do not edit.
do
  vim.opt["laststatus"] = 3
end
for name, text in pairs({DiagnosticSignError = "\239\129\151", DiagnosticSignWarn = "\239\129\177", DiagnosticSignHint = "\239\129\154", DiagnosticSignInfo = "\239\129\153"}) do
  vim.fn.sign_define(name, {texthl = name, text = text, numhl = ""})
end
do
  vim.opt["timeoutlen"] = 200
end
do
  vim.opt["lazyredraw"] = true
end
local function _1_()
  return vim.highlight.on_yank()
end
vim.api.nvim_create_autocmd({"TextYankPost"}, {callback = _1_})
vim.api.nvim_set_hl(0, "TrailingWhitespace", {bg = "darkred"})
vim.api.nvim_command(":let w:m2=matchadd('TrailingWhitespace', '\\s\\+$\\| \\+\\ze\\t\\|\\t\\+\\ze ')")
local function _2_()
  do
    vim.opt["termguicolors"] = true
  end
  do end (require("onedark")).setup({style = "warmer"})
  return vim.cmd.colorscheme("onedark")
end
local function _3_()
  return (require("which-key")).register({b = {name = "Buffer stuff"}, e = {name = "Edit stuff"}, g = {name = "Git"}, h = {name = "Help"}, m = {name = "Local leader"}, f = {name = "File/find ops"}, t = {name = "Toggles"}, w = {name = "Window"}, x = {name = "Lisp"}}, {prefix = "<leader>"})
end
local function _4_()
  return (require("alpha")).setup((require("alpha.themes.startify")).config)
end
return {{"navarasu/onedark.nvim", config = _2_}, {"hoob3rt/lualine.nvim", dependencies = "kyazdani42/nvim-web-devicons", opts = {options = {theme = "onedark", component_separators = {left = "", right = ""}, section_separators = {left = "", right = ""}}}}, {"akinsho/bufferline.nvim", dependencies = "kyazdani42/nvim-web-devicons", opts = {options = {diagnostics = "nvim_lsp", offsets = {{filetype = "NvimTree", text = "", padding = 1}}}}}, "lukas-reineke/indent-blankline.nvim", {"folke/which-key.nvim", config = _3_}, {"folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim", opts = {keywords = {DELETEME = {icon = "\226\156\151", color = "error"}, TODO = {icon = "\239\128\140 ", color = "info"}, HACK = {icon = "\239\146\144 ", color = "warning"}, WARN = {icon = "\239\129\177 ", color = "warning", alt = {"WARNING", "XXX"}}, NOTE = {icon = "\239\161\167 ", color = "hint", alt = {"INFO"}}}, highlight = {pattern = ".*<(KEYWORDS)\\s*:?"}}}, {"Grazfather/blinker.nvim", opts = {count = 3}, config = true, dir = "~/code/blinker.nvim", dev = true}, {"goolord/alpha-nvim", dependencies = {"kyazdani42/nvim-web-devicons"}, config = _4_}, {"folke/noice.nvim", config = true, dependencies = {"MunifTanjim/nui.nvim"}}, {"akinsho/toggleterm.nvim", opts = {open_mapping = "<c-\\>", direction = "tab"}}}
