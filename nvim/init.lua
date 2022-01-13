local execute = vim.api.nvim_command
local fn = vim.fn

local pack_path = fn.stdpath("data") .. "/site/pack"

-- Manually clones a <user>/<repo> from github into the pack directory. Used to
-- bootstrap.
local function ensure (user, repo)
    local install_path = string.format("%s/packer/start/%s", pack_path, repo, repo)
    if fn.empty(fn.glob(install_path)) > 0 then
        execute(string.format("!git clone https://github.com/%s/%s %s", user, repo, install_path))
        execute(string.format("packadd %s", repo))
    end
end

-- Packer is our plugin manager.
ensure("wbthomason", "packer.nvim")
-- Impatient speeds up startup
ensure("lewis6991", "impatient.nvim")
-- Aniseed compiles our Fennel code to Lua and loads it automatically.
ensure("Olical", "aniseed")

local ok, packer = pcall(require, "packer")
if not ok then
    return
end

-- Load impatient, but don't bail if we can't
local ok, _ = pcall(require, "impatient")
if not ok then
    print("Cannot load impatient")
end

-- Make packer UI in a popup instead of a split
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({border = "rounded"})
        end,
    },
})

-- Do not source the default filetype.vim, use filetype.nvim
vim.g.did_load_filetypes = 1

-- Enable Aniseed
vim.g["aniseed#env"] = { module = "core.init" }
