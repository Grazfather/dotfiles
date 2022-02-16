(module core.lsp
  {require-macros [core.macros]})

(local lspconfig (require :lspconfig))

(local servers ["gopls" "clojure_lsp" "pyright"])

(defn on-attach [client bufnr]
  (defn buf-set-keymap [...] (vim.api.nvim_buf_set_keymap bufnr ...))
  (defn buf-set-option [...] (vim.api.nvim_buf_set_option bufnr ...))

  (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")

  ; Mappings
  (local opts {:noremap true :silent true})
  (buf-set-keymap "n" "gD" "<cmd>lua vim.lsp.buf.declaration()<CR>" opts)
  (buf-set-keymap "n" "gd" "<cmd>lua vim.lsp.buf.definition()<CR>" opts)
  (buf-set-keymap "n" "K" "<cmd>lua vim.lsp.buf.hover()<CR>" opts)
  (buf-set-keymap "n" "gi" "<cmd>lua vim.lsp.buf.implementation()<CR>" opts)
  (buf-set-keymap "n" "gr" "<cmd>lua vim.lsp.buf.references()<CR>" opts)
  (buf-set-keymap "n" "[d" "<cmd>lua vim.diagnostic.goto_prev()<CR>" opts)
  (buf-set-keymap "n" "]d" "<cmd>lua vim.diagnostic.goto_next()<CR>" opts)
  (buf-set-keymap "n" "<leader>rn" "<cmd>lua vim.lsp.buf.rename()<CR>" opts)

  ; Set some keybinds conditional on server capabilities
  (if client.resolved_capabilities.document_formatting
    (buf-set-keymap "n" "<leader>ef" "<cmd>lua vim.lsp.buf.formatting()<CR>" opts))
  (if client.resolved_capabilities.document_range_formatting
    (buf-set-keymap "v" "<leader>ef" "<cmd>lua vim.lsp.buf.range_formatting()<CR>" opts))

  ; Set autocommands conditional on server_capabilities
  (if client.resolved_capabilities.document_highlight
    (vim.api.nvim_command
      "hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END")))

; Add capabilities from cmp_nvim_lsp
(local capabilities
  (call-module-method! :cmp_nvim_lsp :update_capabilities
   (vim.lsp.protocol.make_client_capabilities)))

; Use a loop to conveniently both setup defined servers and map buffer local
; keybindings when the language server attaches
(each [_ lsp (ipairs servers)]
  ((. (. lspconfig lsp) :setup) {:on_attach on-attach
                                 :capabilities capabilities}))
