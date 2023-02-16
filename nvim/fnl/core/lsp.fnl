(module core.lsp
  {require-macros [core.macros]})

(local lspconfig (require :lspconfig))
(local servers ["gopls" "clojure_lsp" "pyright"])

(defn- on-attach [client bufnr]
  (defn- buf-nmap [keys func desc]
    (vim.keymap.set "n" keys func {:buffer bufnr :desc desc}))
  (defn- buf-set-option [...] (vim.api.nvim_buf_set_option bufnr ...))

  (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")

  ; Mappings
  (buf-nmap "gD" "<cmd>lua vim.lsp.buf.declaration()<CR>" "Go to declaration")
  (buf-nmap "gd" "<cmd>lua vim.lsp.buf.definition()<CR>" "Go to definition")
  (buf-nmap "gi" "<cmd>lua vim.lsp.buf.implementation()<CR>" "Go to implementation")
  (buf-nmap "gr" "<cmd>lua vim.lsp.buf.references()<CR>" "Go to references")
  (buf-nmap "K" "<cmd>lua vim.lsp.buf.hover()<CR>" "Hover documentation")
  (buf-nmap "[d" "<cmd>lua vim.diagnostic.goto_prev()<CR>" "Go to previous diagnostic")
  (buf-nmap "]d" "<cmd>lua vim.diagnostic.goto_next()<CR>" "Go to next diagnostic")
  (buf-nmap "<leader>rn" "<cmd>lua vim.lsp.buf.rename()<CR>" "Rename symbol")

  ; Set some keybinds conditional on server capabilities
  (if client.server_capabilities.documentFormattingProvider
    (buf-nmap "<leader>ef" "<cmd>lua vim.lsp.buf.format({async = true})<CR>" "Format buffer"))

  ; Set autocommands conditional on server_capabilities
  (if client.server_capabilities.documentHighlightProvider
    (do
      (vim.api.nvim_set_hl 0 "LspReferenceRead" {:reverse true})
      (vim.api.nvim_set_hl 0 "LspReferenceText" {:reverse true})
      (vim.api.nvim_set_hl 0 "LspReferenceWrite" {:reverse true})

      (let [group (vim.api.nvim_create_augroup "lsp-document-highlight" {:clear true})]
        (vim.api.nvim_create_autocmd
          :CursorHold
          {:buffer bufnr
           :group group
           :callback (fn [] (vim.lsp.buf.document_highlight))})
        (vim.api.nvim_create_autocmd
          :CursorMoved
          {:buffer bufnr
           :group group
           :callback (fn [] (vim.lsp.buf.clear_references))})
        )
      )))

; Add capabilities from cmp_nvim_lsp
(local capabilities
  (call-module-method! :cmp_nvim_lsp :default_capabilities
   (vim.lsp.protocol.make_client_capabilities)))

; Setup the above for each server specified
(each [_ lsp (ipairs servers)]
  ((. (. lspconfig lsp) :setup) {:on_attach on-attach
                                 :capabilities capabilities}))
