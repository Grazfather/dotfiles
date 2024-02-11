(import-macros {: call-module-func
                : setup} :macros)

[{1 "hrsh7th/nvim-cmp"
  :event ["InsertEnter"]
  :dependencies ["hrsh7th/cmp-buffer" "hrsh7th/cmp-nvim-lsp" "hrsh7th/cmp-path"
                 "saadparwaiz1/cmp_luasnip" "L3MON4D3/LuaSnip"
                 "rafamadriz/friendly-snippets"]
  :config #(let [lspkind (require :lspkind)
                 luasnip (require :luasnip)
                 cmp (require :cmp)]
             ; Completion via nvim-cmp
             (call-module-func :luasnip.loaders.from_vscode :lazy_load)

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
                               :ghost_text true}}))}
 {1 "hrsh7th/cmp-cmdline"
  :dependencies ["hrsh7th/cmp-buffer" "hrsh7th/nvim-cmp"]
  :config #(let [cmp (require :cmp)]
             (cmp.setup.cmdline "/"
                                {:mapping (cmp.mapping.preset.cmdline)
                                 :sources (cmp.config.sources [{:name :buffer}])}))}]
