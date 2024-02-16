(import-macros {: call-module-func
                : nmap!
                : setup} :macros)

[{1 "neovim/nvim-lspconfig"
  :event ["BufReadPre" "BufNewFile"]
  :dependencies ["williamboman/mason-lspconfig.nvim"
                 "j-hui/fidget.nvim"
                 "onsails/lspkind-nvim"
                 "hrsh7th/cmp-nvim-lsp"]
  :config #(let [lspconfig (require :lspconfig)
                 servers ["gopls" "clojure_lsp" "bashls"]
                 group (vim.api.nvim_create_augroup :LspHighlighting {})]
             ; Blackhole the mappings by default, so that if I hit them in
             ; files with no lsp they just do nothing
             (nmap! "gD" "<nop>")
             (nmap! "gd" "<nop>")
             (nmap! "gi" "<nop>")
             (nmap! "gr" "<nop>")
             (nmap! "K" "<nop>")
             (nmap! "[d" "<nop>")
             (nmap! "]d" "<nop>")
             (nmap! "<leader>D" "<nop>")
             (nmap! "<leader>rn" "<nop>")
             (nmap! "<leader>ca" "<nop>")
             (nmap! "<leader>ef" "<nop>")

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
                         "gd" #(call-module-func "fzf-lua" "lsp_definitions"))
               (buf-nmap "Go to implementation"
                         "gi" vim.lsp.buf.implementation)
               (buf-nmap "Get references"
                         "gr" #(call-module-func "fzf-lua" "lsp_references"))
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
 {1 "nvimtools/none-ls.nvim"
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
