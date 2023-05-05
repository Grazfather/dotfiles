(module core.lsp
        {require-macros [core.macros
                         aniseed.macros.autocmds]})

(local lspconfig (require :lspconfig))
(local servers ["gopls" "clojure_lsp" "pyright" "bashls"])

(defn- on-attach [client bufnr]
  (defn- buf-nmap [keys func desc]
    (vim.keymap.set "n" keys func {:buffer bufnr :desc desc}))
  (defn- buf-set-option [...] (vim.api.nvim_buf_set_option bufnr ...))

  (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")

  ; Mappings
  (buf-nmap "gD" #(vim.lsp.buf.declaration) "Go to declaration")
  (buf-nmap "gd" #(vim.lsp.buf.definition) "Go to definition")
  (buf-nmap "gi" #(vim.lsp.buf.implementation) "Go to implementation")
  (buf-nmap "gr" #(vim.lsp.buf.references) "Go to references")
  (buf-nmap "K" #(vim.lsp.buf.hover) "Hover documentation")
  (buf-nmap "[d" #(vim.diagnostic.goto_prev) "Go to previous diagnostic")
  (buf-nmap "]d" #(vim.diagnostic.goto_next) "Go to next diagnostic")
  (buf-nmap "<leader>rn" #(vim.lsp.buf.rename) "Rename symbol")

  ; Set some keybinds conditional on server capabilities
  (if client.server_capabilities.documentFormattingProvider
    (buf-nmap "<leader>ef" #(vim.lsp.buf.format {:async true}) "Format buffer"))

  ; Set autocommands conditional on server_capabilities
  (if client.server_capabilities.documentHighlightProvider
    (do
      (vim.api.nvim_set_hl 0 "LspReferenceRead" {:reverse true})
      (vim.api.nvim_set_hl 0 "LspReferenceText" {:reverse true})
      (vim.api.nvim_set_hl 0 "LspReferenceWrite" {:reverse true})

      (augroup "lsp-document-highlight"
               [[:CursorHold] {:buffer bufnr
                               :callback #(vim.lsp.buf.document_highlight)}]
               [[:CursorMoved] {:buffer bufnr
                                :callback #(vim.lsp.buf.clear_references)}]))))

; Add capabilities from cmp_nvim_lsp
(local capabilities
  (call-module-func :cmp_nvim_lsp :default_capabilities
   (vim.lsp.protocol.make_client_capabilities)))

; Use Mason to auto-install the lsp servers for us.
(setup :mason-lspconfig
       {:ensure_installed servers})

; Setup the above for each server specified
(each [_ lsp (ipairs servers)]
  ((. (. lspconfig lsp) :setup) {:on_attach on-attach
                                 :capabilities capabilities}))
