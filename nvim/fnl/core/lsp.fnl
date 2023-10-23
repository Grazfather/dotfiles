(import-macros {: call-module-func
                : setup} :macros)

[{1 "neovim/nvim-lspconfig"
  :event ["BufReadPre" "BufNewFile"]
  :dependencies ["williamboman/mason-lspconfig.nvim"
                 "j-hui/fidget.nvim"
                 "onsails/lspkind-nvim"
                 "hrsh7th/cmp-nvim-lsp"]
  :config (fn []
            (local lspconfig (require :lspconfig))
            (local servers ["gopls" "clojure_lsp" "pyright" "bashls"])
            (local group (vim.api.nvim_create_augroup :LspHighlighting {}))

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
                        "gd" #(call-module-func "telescope.builtin" "lsp_definitions"))
              (buf-nmap "Go to implementation"
                        "gi" vim.lsp.buf.implementation)
              (buf-nmap "Get references"
                        "gr" #(call-module-func "telescope.builtin" "lsp_references"))
              (buf-nmap "Hover documentation"
                        "K" vim.lsp.buf.hover)
              (buf-nmap "Go to previous diagnostic"
                        "[d" vim.diagnostic.goto_prev)
              (buf-nmap "Go to next diagnostic"
                        "]d" vim.diagnostic.goto_next)
              (buf-nmap "Show diagnostics"
                        "<leader>D" #(call-module-func "telescope.builtin"
                                                       "diagnostics" {bufnr 0}))
              (buf-nmap "Rename symbol"
                        "<leader>rn" vim.lsp.buf.rename)

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
                                             :capabilities capabilities})))}
 {1 "jose-elias-alvarez/null-ls.nvim"
  :ft ["go"]
  :config #(let [null-ls (require :null-ls)
                 group (vim.api.nvim_create_augroup :LspFormatting {})]
             (setup :null-ls
                    {:sources [null-ls.builtins.formatting.gofmt
                               null-ls.builtins.formatting.goimports]
                     :on_attach (fn [client bufnr]
                                  (vim.api.nvim_create_autocmd :BufWritePre
                                                               {:group group
                                                                :buffer bufnr
                                                                :callback #(vim.lsp.buf.format {:bufnr bufnr})}))}))}]
