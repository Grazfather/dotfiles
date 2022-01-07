; (module core.completion)
(module core.completion
  {autoload {utils core.utils}})

; Completion via nvim-cmp
((. (require :luasnip.loaders.from_vscode) :lazy_load))

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
   :sources [{:name :buffer :keyword_length 3 }
             {:name :luasnip }
             {:name :nvim_lsp :keyword_length 3 }]
   :experimental {:native_menu false
                  :ghost_text true}})
