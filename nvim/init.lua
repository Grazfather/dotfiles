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

-- Aniseed compiles our Fennel code to Lua and loads it automatically.
ensure("Olical", "aniseed")

-- Enable Aniseed
vim.g["aniseed#env"] = { module = "core.init" }
