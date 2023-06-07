(module code.treesitter
        {require-macros [core.macros]})

(setup
  :nvim-treesitter.configs
  {
   :highlight {:enable true
               :additional_vim_regex_highlighting ["clojure" "fennel"]}
   :indent {:enable false}
   :incremental_selection {:enable true
                           :keymaps {:init_selection "gh"
                                     :node_incremental "gh"
                                     :node_decremental "ghd"
                                     :scope_incremental "ghu"}}
   ; nvim-ts-rainbow
   :rainbow {:enable true
             :disable []
             :extended_mode false}
   ; nvim-treesitter-textobjects
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



   :ensure_installed ["bash" "clojure" "cpp" "fennel" "go" "gomod" "gosum"
                      "javascript" "json" "make" "markdown" "proto" "python"
                      "toml" "regex" "yaml" "zig"
                      ; These must be present to override neovim builtins
                      "c" "help" "lua" "vim"]
   })
(setup :treesitter-context)
