(module code.treesitter
  {require-macros [core.macros]})

(setup-module!
  :nvim-treesitter.configs
  {:playground {:enable true}
   :highlight {:enable true}
   :indent {:enable false}
   :incremental_selection {:enable true
                           :keymaps {:init_selection "gh"
                                     :node_incremental "ghe"
                                     :node_decremental "ghi"
                                     :scope_incremental "ghu"}}
   :rainbow {:enable true
             :disable []
             :extended_mode false}
   :textobjects {:select {:enable true
                          :keymaps {:aa "@parameter.outer"
                                    :ia "@parameter.inner"
                                    :af "@function.outer"
                                    :if "@function.inner"}}}
   :ensure_installed ["bash" "c" "clojure" "javascript"
                      "fennel" "json" "lua" "go" "python"
                      "toml" "yaml"]
   })
