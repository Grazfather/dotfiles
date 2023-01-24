(module code.treesitter
  {require-macros [core.macros]})

(setup-module!
  :nvim-treesitter.configs
  {:playground {:enable true}
   :highlight {:enable true
               :additional_vim_regex_highlighting ["clojure" "fennel"]}
   :indent {:enable false}
   :incremental_selection {:enable true
                           :keymaps {:init_selection "gh"
                                     :node_incremental "gh"
                                     :node_decremental "ghd"
                                     :scope_incremental "ghu"}}
   :rainbow {:enable true
             :disable []
             :extended_mode false}
   :textobjects {:select {:enable true
                          :keymaps {:aa "@parameter.outer"
                                    :ia "@parameter.inner"
                                    :af "@function.outer"
                                    :if "@function.inner"
                                    :ac "@class.outer"
                                    :ic "@class.inner"}}
                 :swap {:enable true
                        :swap_next {"<M-l>" "@parameter.inner"}
                        :swap_previous {"<M-h>" "@parameter.inner"}}}
   :ensure_installed ["bash" "clojure" "javascript" "fennel" "json" "go"
                      "python" "toml" "yaml"
                      ; These must be present to override neovim builtins
                      "c" "help" "lua" "vim"]
   })
