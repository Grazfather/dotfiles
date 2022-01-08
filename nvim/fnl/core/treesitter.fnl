(module code.treesitter
  {autoload {utils core.utils}})

(utils.call-module-setup
  :nvim-treesitter.configs
  {:playground {
                :enable true
                :disable []
                ; Debounced time for highlighting nodes in the playground from
                ; source code
                :updatetime 25
                ; Whether the query persists across vim sessions
                :persist_queries false
                :keybindings {:toggle_query_editor "o"
                              :toggle_hl_groups "i"
                              :toggle_injected_languages "t"
                              :toggle_anonymous_nodes "a"
                              :toggle_language_display "I"
                              :focus_language "f"
                              :unfocus_language "F"
                              :update "R"
                              :goto_node "<cr>"
                              :show_help "?"}}
   :highlight {:enable true}
   :indent {:enable false}
   :incremental_selection {:enable true
                           :keymaps {:init_selection "gh"
                                     :node_incremental "ghe"
                                     :node_decremental "ghi"
                                     :scope_incremental "ghu"}}
   :ensure_installed ["bash" "c" "clojure" "javascript"
                      "fennel" "json" "lua" "go" "python"
                      "toml" "yaml"]
   :rainbow {:enable true
             :disable []
             :extended_mode false}})
