set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if has("nvim-0.5")
  lua require "config"
endif
