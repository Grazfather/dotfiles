(import-macros {: call-module-func
                : nmap!
                : setup} :macros)
(local lib (require :lib))

(fn on-attach [client bufnr]
  (fn buf-nmap [desc lhs rhs]
    (vim.keymap.set "n" lhs rhs {:buffer bufnr :desc desc}))
  (fn buf-set-option [...]
    (vim.api.nvim_buf_set_option bufnr ...))

  (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")

  ; Mappings
  (buf-nmap "Go to declaration"
            "gD" vim.lsp.buf.declaration)
  (buf-nmap "Go to definition"
            "gd" #(call-module-func "fzf-lua" "lsp_definitions" {:jump1 true}))
  (buf-nmap "Go to implementation"
            "gi" #(call-module-func "fzf-lua" "lsp_implementations" {:jump1 true}))
  (buf-nmap "Get references"
            "gr" #(call-module-func "fzf-lua" "lsp_references" {:jump1 true
                                                                :ignore_current_line true}))
  (buf-nmap "Hover documentation"
            "K" vim.lsp.buf.hover)
  (buf-nmap "Go to previous diagnostic"
            "[d" vim.diagnostic.goto_prev)
  (buf-nmap "Go to next diagnostic"
            "]d" vim.diagnostic.goto_next)
  (buf-nmap "Show diagnostics"
            "<leader>D" #(call-module-func "fzf-lua"
                                           "diagnostics_document" {:bufnr 0}))
  (buf-nmap "Add diagnostics to quickfix"
            "<leader>ld" vim.diagnostic.setqflist)
  (buf-nmap "Rename symbol"
            "<leader>rn" vim.lsp.buf.rename)
  (buf-nmap "Code action"
            "<leader>ca" vim.lsp.buf.code_action)

  ; Set some keybinds conditional on server capabilities
  (when client.server_capabilities.documentFormattingProvider
    (buf-nmap "Format buffer"
              "<leader>ef" #(vim.lsp.buf.format {:async true})))

  ; Set autocommands conditional on server_capabilities
  (when client.server_capabilities.documentHighlightProvider
    (vim.api.nvim_set_hl 0 "LspReferenceRead" {:reverse true})
    (vim.api.nvim_set_hl 0 "LspReferenceText" {:reverse true})
    (vim.api.nvim_set_hl 0 "LspReferenceWrite" {:reverse true})

    (vim.api.nvim_create_autocmd :CursorHold
                                 {:buffer bufnr
                                  :group group
                                  :callback vim.lsp.buf.document_highlight})
    (vim.api.nvim_create_autocmd :CursorMoved
                                 {:buffer bufnr
                                  :group group
                                  :callback vim.lsp.buf.clear_references})))

(vim.api.nvim_create_autocmd :LspAttach
                             {:group (vim.api.nvim_create_augroup :UserLspConfig {})
                              :callback (fn [ev]
                                          (let [client (vim.lsp.get_client_by_id ev.data.client_id)
                                                bufnr ev.buf]
                                            (on-attach client bufnr)))})

[{1 "williamboman/mason-lspconfig.nvim"
  :opts {:ensure_installed ["bashls"
                            "clangd"
                            "gopls"
                            "pyright"
                            "zls"]}
  :dependencies [{1 "williamboman/mason.nvim" :build ":MasonUpdate" :config true}
                 "neovim/nvim-lspconfig"]}]
