(import-macros {: setup} :macros)

[{1 "nvim-treesitter/nvim-treesitter" :build ":TSUpdate"
  :config #(setup :nvim-treesitter
                  {
                   :ensure_installed [; These must be present to override neovim builtins
                                      "c" "lua" "vim" "vimdoc" "query"

                                      "bash" "clojure" "cpp" "fennel" "go" "gomod" "gosum"
                                      "html" "javascript" "json" "make" "markdown" "proto"
                                      "python" "toml" "typescript" "regex" "yaml"
                                      "zig"]
                   :highlight {:enable true
                               :additional_vim_regex_highlighting ["clojure" "fennel"]}
                   :indent {:enable false}
                   :incremental_selection {:enable true
                                           :keymaps {:init_selection "<leader>ss"
                                                     :node_incremental "<leader>si"
                                                     :node_decremental "<leader>sd"
                                                     :scope_incremental "<leader>ss"}}
                   :swap {:enable true
                          :swap_next {"<M-l>" "@parameter.inner"}
                          :swap_previous {"<M-h>" "@parameter.inner"}}})}
 {1 "nvim-treesitter/nvim-treesitter-context"
  :config true}]
