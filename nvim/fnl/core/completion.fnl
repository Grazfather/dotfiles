(import-macros {: call-module-func
                : map!
                : setup} :macros)

[{1 "hrsh7th/nvim-cmp"
  :event ["InsertEnter"]
  :dependencies ["hrsh7th/cmp-buffer" "hrsh7th/cmp-nvim-lsp" "hrsh7th/cmp-path"
                 "saadparwaiz1/cmp_luasnip" "L3MON4D3/LuaSnip"
                 "rafamadriz/friendly-snippets"]
  :config #(let [lspkind (require :lspkind)
                 luasnip (require :luasnip)
                 cmp (require :cmp)]
             ; Load snippets into luasnip
             (call-module-func :luasnip.loaders.from_vscode :lazy_load)

             (setup :luasnip {:updateevents "TextChanged,TextChangedI"})

             ; Setup Luasnip-specific bindings
             (map! "is" "<C-K>" (fn [] (if (luasnip.expand_or_jumpable)
                                         (luasnip.expand_or_jump)))
                   "is" "<C-J>" (fn [] (if (luasnip.jumpable -1)
                                         (luasnip.jump -1))))

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
                :formatting {:format (lspkind.cmp_format {})}
                :window {:completion (cmp.config.window.bordered)
                         :documentation (cmp.config.window.bordered)}
                :sources [{:name :nvim_lsp :keyword_length 3}
                          {:name :buffer :keyword_length 4}
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
