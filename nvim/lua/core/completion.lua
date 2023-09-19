-- [nfnl] Compiled from fnl/core/completion.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  do end (require("luasnip.loaders.from_vscode")).lazy_load()
  local lspkind = require("lspkind")
  local luasnip = require("luasnip")
  local cmp = require("cmp")
  do end (require("luasnip")).setup({updateevents = "TextChanged,TextChangedI"})
  local function _2_(args)
    return luasnip.lsp_expand(args.body)
  end
  local function _3_(fallback)
    if cmp.visible() then
      return cmp.select_next_item()
    elseif luasnip.jumpable(1) then
      return luasnip.jump(1)
    else
      return fallback()
    end
  end
  local function _5_(fallback)
    if cmp.visible() then
      return cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      return luasnip.jump(-1)
    else
      return fallback()
    end
  end
  return (require("cmp")).setup({snippet = {expand = _2_}, mapping = {["<C-Y>"] = cmp.mapping.confirm({select = true}), ["<C-N>"] = cmp.mapping(_3_, {"i", "s"}), ["<C-P>"] = cmp.mapping(_5_, {"i", "s"})}, formatting = {format = lspkind.cmp_format({with_text = true, menu = {nvim_lsp = "[lsp]", buffer = "[buf]", luasnip = "[LuaSnip]"}})}, sources = {{name = "nvim_lsp", keyword_length = 3}, {name = "buffer", keyword_length = 3}, {name = "luasnip"}}, experimental = {ghost_text = true, native_menu = false}})
end
return {{"hrsh7th/nvim-cmp", lazy = true, event = "InsertEnter", dependencies = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets"}, config = _1_}}
