-- [nfnl] Compiled from fnl/core/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local lspconfig = require("lspconfig")
  local servers = {"gopls", "clojure_lsp", "pyright", "bashls", "fennel_language_server"}
  local group
  do
    local group0 = vim.api.nvim_create_augroup("LspHighlighting", {clear = true})
    vim.api.nvim_create_autocmd({"CursorHold"}, {buffer = 0, callback = print, group = group0})
    group = nil
  end
  local on_attach
  local function _2_(client, bufnr)
    local on_attach0
    local function _3_(keys, func, desc)
      return vim.keymap.set("n", keys, func, {buffer = bufnr, desc = desc})
    end
    on_attach0 = _3_
    local buf_set_option
    local function _4_(...)
      return vim.api.nvim_buf_set_option(bufnr, ...)
    end
    buf_set_option = _4_
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    __fnl_global__buf_2dnmap("gD", vim.lsp.buf.declaration, "Go to declaration")
    __fnl_global__buf_2dnmap("gd", vim.lsp.buf.definition, "Go to definition")
    __fnl_global__buf_2dnmap("gi", vim.lsp.buf.implementation, "Go to implementation")
    __fnl_global__buf_2dnmap("gr", vim.lsp.buf.references, "Go to references")
    __fnl_global__buf_2dnmap("K", vim.lsp.buf.hover, "Hover documentation")
    __fnl_global__buf_2dnmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
    __fnl_global__buf_2dnmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
    __fnl_global__buf_2dnmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    if client.server_capabilities.documentFormattingProvider then
      local function _5_()
        return vim.lsp.buf.format({async = true})
      end
      __fnl_global__buf_2dnmap("<leader>ef", _5_, "Format buffer")
    else
    end
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_set_hl(0, "LspReferenceRead", {reverse = true})
      vim.api.nvim_set_hl(0, "LspReferenceText", {reverse = true})
      vim.api.nvim_set_hl(0, "LspReferenceWrite", {reverse = true})
      vim.api.nvim_create_autocmd({"CursorHold"}, {buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight})
      vim.api.nvim_create_autocmd({"CursorMoved"}, {buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references})
      return nil
    else
      return nil
    end
  end
  on_attach = _2_
  local capabilities = (require("cmp_nvim_lsp")).default_capabilities(vim.lsp.protocol.make_client_capabilities())
  do end (require("mason-lspconfig")).setup({ensure_installed = servers})
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({on_attach = on_attach, capabilities = capabilities})
  end
  return nil
end
local function _8_()
  local null_ls = require("null-ls")
  local group = vim.api.nvim_create_augroup("LspFormatting", {})
  local function _9_(client, bufnr)
    local function _10_()
      return vim.lsp.buf.format({bufnr = bufnr})
    end
    return autocmd({"BufWritePre"}, {group = group, buffer = bufnr, callback = _10_})
  end
  return (require("null-ls")).setup({sources = {null_ls.builtins.formatting.gofmt, null_ls.builtins.formatting.goimports}, on_attach = _9_})
end
return {{"neovim/nvim-lspconfig", dependencies = {"williamboman/mason-lspconfig.nvim", "j-hui/fidget.nvim", "onsails/lspkind-nvim", "hrsh7th/cmp-nvim-lsp"}, config = _1_}, {"jose-elias-alvarez/null-ls.nvim", ft = {"go"}, config = _8_}}
