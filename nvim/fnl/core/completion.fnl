; (module core.completion)
(module core.completion
  {autoload {utils core.utils}})

; Completion via nvim-cmp
((. (require :luasnip.loaders.from_vscode) :lazy_load))

(local lspkind (require :lspkind))
(local luasnip (require :luasnip))
(local cmp (require :cmp))

(utils.call-module-setup
  :cmp
  {
   :snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
   :mapping {"<CR>" (cmp.mapping.confirm { :select true })
             ; For snippets with params, tab jumps to next, or expand doc
             "<Tab>" (cmp.mapping
                       (fn [fallback]
                         (if
                           (luasnip.expandable) (luasnip.expand)
                           (luasnip.expand_or_jumpable) (luasnip.expand_or_jump)
                           (fallback)))
                       [:i :s])}
   ; Show icons for the type of completion, and show where it came from
   :formatting {:format (lspkind.cmp_format {:with_text true
                                             :menu {:nvim_lsp "[lsp]"
                                                    :buffer "[buf]"
                                                    :luasnip "[LuaSnip]"}})}
   :sources [{:name :nvim_lsp :keyword_length 3}
             {:name :buffer :keyword_length 3}
             {:name :luasnip }]
   :experimental {:native_menu false
                  :ghost_text true}})
