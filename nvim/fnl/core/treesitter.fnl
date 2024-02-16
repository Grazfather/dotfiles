(import-macros {: setup} :macros)

[{1 "nvim-treesitter/nvim-treesitter" :build ":TSUpdate"
  :config #(setup
             :nvim-treesitter.configs
             {
              :playground {:enable true}
              :highlight {:enable true
                          :additional_vim_regex_highlighting ["clojure" "fennel"]}
              :indent {:enable false}
              :incremental_selection {:enable true
                                      :keymaps {:init_selection "gh"
                                                :node_incremental "gh"
                                                :node_decremental "<BS>"
                                                :scope_incremental "ghu"}}
              ; nvim-ts-rainbow
              :rainbow {:enable true
                        :disable []
                        :extended_mode false}
              ; nvim-treesitter-textobjects
              :textobjects {:select {:enable true
                                     :keymaps {:a= "@assignment.outer"
                                               :i= "@assignment.inner"
                                               :aa "@parameter.outer"
                                               :ia "@parameter.inner"
                                               :af "@function.outer"
                                               :if "@function.inner"
                                               :ac "@class.outer"
                                               :ic "@class.inner"}}
                            :swap {:enable true
                                   :swap_next {"<M-l>" "@parameter.inner"}
                                   :swap_previous {"<M-h>" "@parameter.inner"}}}

              :ensure_installed ["bash" "clojure" "cpp" "fennel" "go" "gomod" "gosum"
                                 "html" "javascript" "json" "make" "markdown" "proto"
                                 "python" "query" "toml" "typescript" "regex" "yaml"
                                 "zig"
                                 ; These must be present to override neovim builtins
                                 "c" "vimdoc" "lua" "vim"]
              })}
 {1 "nvim-treesitter/nvim-treesitter-context"
  :config true}
 "nvim-treesitter/nvim-treesitter-textobjects"
 "nvim-treesitter/playground"
 "p00f/nvim-ts-rainbow"]
