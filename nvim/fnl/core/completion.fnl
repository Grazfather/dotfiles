(import-macros {: call-module-func
                : setup
                : set-true!
                : map!
                : nmap!
                : noremap!
                : descnmap!} :macros)

[{1 "hrsh7th/nvim-cmp"
  :lazy true
  :event "InsertEnter"
  :dependencies ["hrsh7th/cmp-buffer" "hrsh7th/cmp-nvim-lsp" "hrsh7th/cmp-path"
                 "saadparwaiz1/cmp_luasnip" "L3MON4D3/LuaSnip"
                 "rafamadriz/friendly-snippets"]
  :config (fn []
            ; Completion via nvim-cmp
            (call-module-func :luasnip.loaders.from_vscode :lazy_load)

            (local lspkind (require :lspkind))
            (local luasnip (require :luasnip))
            (local cmp (require :cmp))

            (setup :luasnip {:updateevents "TextChanged,TextChangedI"})

            (setup
              :cmp
              {:snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
               :mapping {"<C-Y>" (cmp.mapping.confirm {:select true})
                         ; For snippets with params, C-N/C-P can be used to move within them
                         "<C-N>" (cmp.mapping
                                   (fn [fallback]
                                     (if
                                       (cmp.visible) (cmp.select_next_item)
                                       (luasnip.jumpable 1) (luasnip.jump 1)
                                       (fallback)))
                                   [:i :s])
                         "<C-P>" (cmp.mapping
                                   (fn [fallback]
                                     (if
                                       (cmp.visible) (cmp.select_prev_item)
                                       (luasnip.jumpable -1) (luasnip.jump -1)
                                       (fallback)))
                                   [:i :s])}
               ; Show icons for the type of completion, and show where it came from
               :formatting {:format (lspkind.cmp_format {:with_text true
                                                         :menu {:nvim_lsp "[lsp]"
                                                                :buffer "[buf]"
                                                                :luasnip "[LuaSnip]"}})}
               :sources [{:name :nvim_lsp :keyword_length 3}
                         {:name :buffer :keyword_length 3}
                         {:name :luasnip}
                         {:name :path}]
               :experimental {:native_menu false
                              :ghost_text true}}))}]
