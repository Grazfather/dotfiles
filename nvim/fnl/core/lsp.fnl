(import-macros {: call-module-func : descnmap!} :macros)
(local lib (require :lib))

(local lsp-highlight-group (vim.api.nvim_create_augroup :LspHighlight {}))

(fn on-attach [client bufnr]
  (fn buf-set-option [...]
    (vim.api.nvim_buf_set_option bufnr ...))

  (buf-set-option "omnifunc" "v:lua.vim.lsp.omnifunc")

  ; Mappings
  (descnmap!
    "Go to declaration"
    "gD" vim.lsp.buf.declaration

    "Go to definition"
    "gd" #(call-module-func "fzf-lua" "lsp_definitions" {:jump1 true})

    "Go to implementation"
    "gi" #(call-module-func "fzf-lua" "lsp_implementations" {:jump1 true})

    "Get references"
    "gr" #(call-module-func "fzf-lua" "lsp_references" {:jump1 true :ignore_current_line true})

    "Hover documentation"
    "K" vim.lsp.buf.hover

    "Go to previous diagnostic"
    "[d" vim.diagnostic.goto_prev

    "Go to next diagnostic"
    "]d" vim.diagnostic.goto_next

    "Show diagnostics"
    "<leader>D" #(call-module-func "fzf-lua" "diagnostics_document" {:bufnr 0})

    "Add diagnostics to quickfix"
    "<leader>ld" vim.diagnostic.setqflist

    "Rename symbol"
    "<leader>rn" vim.lsp.buf.rename

    "Code action"
    "<leader>ca" vim.lsp.buf.code_action
    {:buffer bufnr})

  ; Set some keybinds conditional on server capabilities
  (when client.server_capabilities.documentFormattingProvider
    (descnmap! "Format buffer"
               "<leader>ef" #(vim.lsp.buf.format {:async true})
               {:buffer bufnr}))

  ; Set autocommands conditional on server_capabilities
  (when client.server_capabilities.documentHighlightProvider
    (vim.api.nvim_set_hl 0 "LspReferenceRead" {:reverse true})
    (vim.api.nvim_set_hl 0 "LspReferenceText" {:reverse true})
    (vim.api.nvim_set_hl 0 "LspReferenceWrite" {:reverse true})

    (vim.api.nvim_create_autocmd :CursorHold
                                 {:buffer bufnr
                                  :group lsp-highlight-group
                                  :callback vim.lsp.buf.document_highlight})
    (vim.api.nvim_create_autocmd :CursorMoved
                                 {:buffer bufnr
                                  :group lsp-highlight-group
                                  :callback vim.lsp.buf.clear_references})))

(vim.api.nvim_create_autocmd :LspAttach
                             {:group (vim.api.nvim_create_augroup :UserLspConfig {:clear false})
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
