(import-macros {: call-module-func
                : nmap!
                : setup} :macros)
(local lib (require :lib))

[{1 "neovim/nvim-lspconfig"
  :event ["BufReadPre"]
  :dependencies ["williamboman/mason-lspconfig.nvim"
                 "j-hui/fidget.nvim"
                 "onsails/lspkind-nvim"
                 "hrsh7th/cmp-nvim-lsp"]
  :config #(let [lspconfig (require :lspconfig)
                 ; If any of the servers are paired with a table, it will get merged into the config
                 servers [["arduino_language_server" {:cmd ["arduino-language-server"
                                                            "-cli" "/opt/homebrew/bin/arduino-cli"
                                                            "-cli-config" "~/Library/Arduino15/arduino-cli.yaml"]}]
                          "clojure_lsp"
                          "gopls"
                          "bashls"
                          "zls"]
                 group (vim.api.nvim_create_augroup :LspHighlighting {})]
             ; Blackhole the mappings by default, so that if I hit them in
             ; files with no lsp they just do nothing
             (nmap! "gD" "<nop>"
                    "gd" "<nop>"
                    "gi" "<nop>"
                    "gr" "<nop>"
                    "K" "<nop>"
                    "[d" "<nop>"
                    "]d" "<nop>"
                    "<leader>D" "<nop>"
                    "<leader>rn" "<nop>"
                    "<leader>ca" "<nop>"
                    "<leader>ef" "<nop>")

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

             ; Add capabilities from cmp_nvim_lsp
             (local capabilities
               (call-module-func :cmp_nvim_lsp :default_capabilities
                                 (vim.lsp.protocol.make_client_capabilities)))

             ; Use Mason to auto-install the lsp servers
             (let [server-names (icollect [_ s (ipairs servers)]
                                  (if (lib.seq? s) (. s 1) s))]
               (setup :mason-lspconfig
                      {:ensure_installed server-names
                       :automatic_enable false}))

             ; Setup each server, using the on-attach and capabilities set
             (each [_ lsp (ipairs servers)]
               (let [[server-name extra-config] (if (lib.seq? lsp)
                                                  [(unpack lsp)]
                                                  [lsp {}])
                     ; Merge base config with optional extra config
                     base-config {:on_attach on-attach
                                  :capabilities capabilities}
                     config (lib.merge extra-config base-config)]

                 ; Set up the server
                 ((. (. lspconfig server-name) :setup) config))))}]
