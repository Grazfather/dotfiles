(module core.completion
  {require-macros [core.macros]})

; Completion via nvim-cmp
(call-module-method! :luasnip.loaders.from_vscode :lazy_load)

(local lspkind (require :lspkind))
(local luasnip (require :luasnip))
(local cmp (require :cmp))

(setup-module! :luasnip {:updateevents "TextChanged,TextChangedI"})

(setup-module!
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
             {:name :luasnip}]
   :experimental {:native_menu false
                  :ghost_text true}})
