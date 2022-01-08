(module code.treesitter
  {autoload {utils core.utils}})

(utils.call-module-setup
  :nvim-treesitter.configs
  {:playground {:enable true}
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
