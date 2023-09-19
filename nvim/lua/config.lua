-- [nfnl] Compiled from fnl/config.fnl by https://github.com/Olical/nfnl, do not edit.
do
  vim.opt["tags"] = "./tags,tags;"
end
do
  vim.opt["path"] = "**3"
end
local function _1_()
  local _let_2_ = vim.api.nvim_buf_get_mark(0, "\"")
  local row = _let_2_[1]
  local col = _let_2_[2]
  local lastrow = vim.api.nvim_buf_line_count(0)
  if ((row > 0) and (row <= lastrow)) then
    return vim.api.nvim_win_set_cursor(0, {row, col})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd({"BufReadPost"}, {pattern = {"*"}, callback = _1_})
do
  do local _ = {vim.keymap.set("n", "<up>", "<nop>", {remap = true})} end
  do local _ = {vim.keymap.set("n", "<down>", "<nop>", {remap = true})} end
  do local _ = {vim.keymap.set("n", "<left>", "<nop>", {remap = true})} end
  do local _ = {vim.keymap.set("n", "<right>", "<nop>", {remap = true})} end
end
do
  do local _ = {vim.keymap.set("n", "k", "gk", {})} end
  do local _ = {vim.keymap.set("n", "j", "gj", {})} end
  do local _ = {vim.keymap.set("n", "gk", "k", {})} end
  do local _ = {vim.keymap.set("n", "gj", "j", {})} end
end
do
  do local _ = {vim.keymap.set("n", "<C-h>", "<C-w>h", {desc = "Go to the left window", remap = true})} end
  do local _ = {vim.keymap.set("n", "<C-j>", "<C-w>j", {desc = "Go to the down window", remap = true})} end
  do local _ = {vim.keymap.set("n", "<C-k>", "<C-w>k", {desc = "Go to the up window", remap = true})} end
  do local _ = {vim.keymap.set("n", "<C-l>", "<C-w>l", {desc = "Go to the right window", remap = true})} end
end
do
  do local _ = {vim.keymap.set("n", "<C-n>", "<cmd>bnext<CR>", {remap = true})} end
  do local _ = {vim.keymap.set("n", "<C-p>", "<cmd>bprev<CR>", {remap = true})} end
  do local _ = {vim.keymap.set("n", "<C-e>", "<cmd>b#<CR>", {remap = true})} end
end
do
  do local _ = {vim.keymap.set("c", "<C-n>", "<down>", {remap = true})} end
  do local _ = {vim.keymap.set("c", "<C-p>", "<up>", {remap = true})} end
end
do
  do local _ = {vim.keymap.set("v", "<", "<gv", {})} end
  do local _ = {vim.keymap.set("v", ">", ">gv", {})} end
end
do
  vim.opt["scrolloff"] = 4
end
do
  vim.opt["ignorecase"] = true
  vim.opt["smartcase"] = true
  vim.opt["infercase"] = true
end
do
  vim.opt["incsearch"] = false
end
do
  vim.opt["swapfile"] = false
  vim.opt["backup"] = false
  vim.opt["writebackup"] = false
end
do
  vim.opt["splitbelow"] = true
  vim.opt["splitright"] = true
end
do
  vim.opt["ttimeoutlen"] = 50
end
do
  vim.opt["shiftround"] = true
end
do
  vim.opt["foldmethod"] = "indent"
  vim.opt["foldlevel"] = 99
end
do
  vim.opt["smartindent"] = true
end
do
  vim.opt["number"] = true
  vim.opt["relativenumber"] = true
end
do
  do local _ = {vim.keymap.set("n", "J", "mzJ`z", {})} end
end
do
  do local _ = {vim.keymap.set("n", "Q", "<nop>", {remap = true})} end
end
do
  do local _ = {vim.keymap.set("n", "<leader>ew", "<cmd>keeppatterns %s/\\s\\+$//e<CR><C-o>", {desc = "Clear trailing whitespace", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>et2", "<cmd>keeppatterns %s/\9/  /eg<CR><C-o>", {desc = "Convert tabs to 2 spaces", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>et4", "<cmd>keeppatterns %s/\9/    /eg<CR><C-o>", {desc = "Convert tabs to 4 spaces", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>et8", "<cmd>keeppatterns %s/\9/        /eg<CR><C-o>", {desc = "Convert tabs to 8 spaces", remap = true})} end
  do local _ = {vim.keymap.set("n", "vag", "ggVGg_", {desc = "Select whole buffer", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>bd", "<cmd>bp|bd #<CR>", {desc = "Close current buffer", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>fs", "<cmd>write<CR>", {desc = "Save buffer", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>dm", "mxgcADELETEME<ESC>`x", {desc = "Add DELETEME comment", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>dd", "<cmd>keepp :g/DELETEME/d<CR><C-o>", {desc = "Delete all DELETEME lines", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>th", "<cmd>set hlsearch!<CR>", {desc = "Toggle search highlighting", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>tl", "<cmd>set number! relativenumber!<CR>", {desc = "Toggle showing relative line numbers", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>tx", "<cmd>set cursorline! cursorcolumn!<CR>", {desc = "Toggle cursor highlighting", remap = true})} end
  do
    local cmd_30_auto
    local function _4_()
      return (require("blinker")).blink_cursorline()
    end
    cmd_30_auto = _4_
    vim.keymap.set("n", "<leader><space>", cmd_30_auto, {desc = "Blink current line", remap = true})
  end
  do local _ = {vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", {desc = "Split vertically", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", {desc = "Split horizontally", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>wd", "<cmd>close<CR>", {desc = "Close split", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>wo", "<cmd>only<CR>", {desc = "Close other splits", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>ww", "<C-w>w", {desc = "Switch split", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>ft", "<cmd>Neotree toggle<CR>", {desc = "Toggle Neo-tree", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>tu", "<cmd>UndotreeToggle<CR>", {desc = "Toggle Undotree", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", {desc = "Git blame", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>gd", "<cmd>Git diff<CR>", {desc = "Git diff", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>gs", "<cmd>Git status<CR>", {desc = "Git status", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>gl", "<cmd>GV<CR>", {desc = "Git log", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>gf", "<cmd>GV!<CR>", {desc = "Git log current file", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", {desc = "Open Neogit", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>gm", "<cmd>GitMessenger<CR>", {desc = "Show commit message at line", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>go", "<cmd>GBrowse<CR>", {desc = "Open selected file in github", remap = true})} end
  do
    local cmd_30_auto
    local function _5_()
      return (require("telescope.builtin")).git_files()
    end
    cmd_30_auto = _5_
    vim.keymap.set("n", "<leader>pf", cmd_30_auto, {desc = "Find files in project", remap = true})
  end
  do local _ = {vim.keymap.set("n", "<leader>pt", "<cmd>TodoTelescope<CR>", {desc = "Find TODOs in project", remap = true})} end
  do
    local cmd_30_auto
    local function _6_()
      return (require("telescope.builtin")).find_files()
    end
    cmd_30_auto = _6_
    vim.keymap.set("n", "<leader>ff", cmd_30_auto, {desc = "File files from CWD", remap = true})
  end
  do
    local cmd_30_auto
    local function _7_()
      return (require("telescope.builtin")).buffers()
    end
    cmd_30_auto = _7_
    vim.keymap.set("n", "<leader>bb", cmd_30_auto, {desc = "Find buffer", remap = true})
  end
  do
    local cmd_30_auto
    local function _8_()
      return (require("telescope.builtin")).marks()
    end
    cmd_30_auto = _8_
    vim.keymap.set("n", "<leader>fm", cmd_30_auto, {desc = "Find mark", remap = true})
  end
  do
    local cmd_30_auto
    local function _9_()
      return (require("telescope.builtin")).jumplist()
    end
    cmd_30_auto = _9_
    vim.keymap.set("n", "<leader>fj", cmd_30_auto, {desc = "Find jump", remap = true})
  end
  do
    local cmd_30_auto
    local function _10_()
      return (require("telescope.builtin")).live_grep()
    end
    cmd_30_auto = _10_
    vim.keymap.set("n", "<leader>frg", cmd_30_auto, {desc = "Grep file content from CWD", remap = true})
  end
  do
    local cmd_30_auto
    local function _11_()
      return (require("telescope.builtin")).help_tags()
    end
    cmd_30_auto = _11_
    vim.keymap.set("n", "<leader>hh", cmd_30_auto, {desc = "Search help", remap = true})
  end
  do
    local cmd_30_auto
    local function _12_()
      return (require("telescope.builtin")).highlights()
    end
    cmd_30_auto = _12_
    vim.keymap.set("n", "<leader>hH", cmd_30_auto, {desc = "Search highlights", remap = true})
  end
  do
    local cmd_30_auto
    local function _13_()
      return (require("telescope.builtin")).autocommands()
    end
    cmd_30_auto = _13_
    vim.keymap.set("n", "<leader>ha", cmd_30_auto, {desc = "Search autocommands", remap = true})
  end
  do
    local cmd_30_auto
    local function _14_()
      return (require("telescope.builtin")).keymaps()
    end
    cmd_30_auto = _14_
    vim.keymap.set("n", "<leader>hk", cmd_30_auto, {desc = "Search keymaps", remap = true})
  end
  do
    local cmd_30_auto
    local function _15_()
      return (require("telescope.builtin")).man_pages()
    end
    cmd_30_auto = _15_
    vim.keymap.set("n", "<leader>hm", cmd_30_auto, {desc = "Search man pages", remap = true})
  end
  local cmd_30_auto
  local function _16_()
    return (require("telescope.builtin")).commands()
  end
  cmd_30_auto = _16_
  vim.keymap.set("n", "<leader>:", cmd_30_auto, {desc = "Search ex commands", remap = true})
end
do
  vim.opt["signcolumn"] = "yes"
end
local function toggle_sign_column()
  local _17_
  do
    local ok_3f_5_auto, value_6_auto = nil, nil
    local function _18_()
      return (vim.opt.signcolumn):get()
    end
    ok_3f_5_auto, value_6_auto = pcall(_18_)
    if ok_3f_5_auto then
      _17_ = value_6_auto
    else
      _17_ = nil
    end
  end
  if (_17_ == "yes") then
    vim.opt["signcolumn"] = "no"
    return nil
  else
    vim.opt["signcolumn"] = "yes"
    return nil
  end
end
do
  local cmd_30_auto = toggle_sign_column
  vim.keymap.set("n", "<leader>tg", cmd_30_auto, {desc = "Toggle sign column", remap = true})
end
do
  do local _ = {vim.keymap.set("n", "<leader>tt", "<cmd>set list!<CR>", {desc = "Toggle showing listchars", remap = true})} end
end
do
  vim.opt["list"] = true
end
do
  vim.opt["listchars"] = "eol:\194\172,nbsp:\226\144\163,conceal:\226\139\175,tab:  ,precedes:\226\128\166,extends:\226\128\166,trail:\226\128\162"
end
do
  do local _ = {vim.keymap.set("n", "<leader>ti", "<cmd>IndentBlanklineToggle<CR>", {desc = "Toggle indent markers", remap = true})} end
end
do
  local cmd_30_auto
  local function _21_()
    toggle_sign_column()
    do
      local _22_
      do
        local ok_3f_5_auto, value_6_auto = nil, nil
        local function _23_()
          return (vim.opt.list):get()
        end
        ok_3f_5_auto, value_6_auto = pcall(_23_)
        if ok_3f_5_auto then
          _22_ = value_6_auto
        else
          _22_ = nil
        end
      end
      vim.opt["list"] = not _22_
      local _25_
      do
        local ok_3f_5_auto, value_6_auto = nil, nil
        local function _26_()
          return (vim.opt.number):get()
        end
        ok_3f_5_auto, value_6_auto = pcall(_26_)
        if ok_3f_5_auto then
          _25_ = value_6_auto
        else
          _25_ = nil
        end
      end
      vim.opt["number"] = not _25_
      local _28_
      do
        local ok_3f_5_auto, value_6_auto = nil, nil
        local function _29_()
          return (vim.opt.relativenumber):get()
        end
        ok_3f_5_auto, value_6_auto = pcall(_29_)
        if ok_3f_5_auto then
          _28_ = value_6_auto
        else
          _28_ = nil
        end
      end
      vim.opt["relativenumber"] = not _28_
    end
    return vim.cmd("IndentBlanklineToggle")
  end
  cmd_30_auto = _21_
  vim.keymap.set("n", "<leader>tv", cmd_30_auto, {desc = "Toggle visual glyphs", remap = true})
end
do
  do local _ = {vim.keymap.set("n", "<leader>c ", "gcc", {desc = "Toggle comment on current line", remap = true})} end
end
do
  do local _ = {vim.keymap.set("v", "<leader>c ", "gc", {remap = true})} end
end
do
  do local _ = {vim.keymap.set("i", "<C-a>", "<ESC>I", {remap = true})} end
  do local _ = {vim.keymap.set("i", "<C-e>", "<ESC>A", {remap = true})} end
end
do
  local group = vim.api.nvim_create_augroup("markdown", {clear = true})
  local function _31_()
    vim.opt["filetype"] = "ghmarkdown"
    return nil
  end
  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {pattern = "*.md", callback = _31_, group = group})
end
do
  do local _ = {vim.keymap.set("n", "<leader>xs", "<Plug>(sexp_capture_next_element)", {desc = "Slurp from right", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xS", "<Plug>(sexp_capture_prev_element)", {desc = "Slurp from left", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xe", "<Plug>(sexp_emit_tail_element)", {desc = "Barf from right", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xE", "<Plug>(sexp_emit_head_element)", {desc = "Barf from left", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xc", "<Plug>(sexp_convolute)", {desc = "Convolute", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xl", "<Plug>(sexp_swap_element_forward)", {desc = "Drag forward", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xh", "<Plug>(sexp_swap_element_backward)", {desc = "Drag back", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xw", "<Plug>(sexp_move_to_next_element_head)", {desc = "Next element", remap = true})} end
  do local _ = {vim.keymap.set("n", "<leader>xb", "<Plug>(sexp_move_to_prev_element_head)", {desc = "Previous element", remap = true})} end
end
return {}
