local plugins_path = vim.fn.stdpath("data") .. "/lazy/"
local function bootstrap(path, project)
  local path = plugins_path .. path
  if not vim.loop.fs_stat(path) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/" .. project .. ".git",
      path,
    })
  end
  vim.opt.rtp:prepend(path)
end

bootstrap("lazy.nvim", "folke/lazy.nvim")
bootstrap("aniseed", "Olical/aniseed")

-- Enable Aniseed, loading init.fnl
vim.g["aniseed#env"] = { module = "config" }

-- Leader must be set before loading Lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " m"
