(import-macros {: call-module-func
                : xmap!
                : setup} :macros)

[{1 "saghen/blink.cmp"
  :dependencies ["rafamacriz/friendly-snippets" "L3MON4D3/LuaSnip"]
  :version "1.*"
  :opts {:keymap {:preset :default}
         :appearance {:nerd_font_variant :mono}
         :completion {:documentation {:auto_show true}}
         :sources {:default [:lsp :path :snippets :buffer]}}
  :opts_extend ["sources.default"]}
 {1 "stevearc/conform.nvim"
  :opts {:formatters_by_ft {:go [:gofmt :goimports]}
         :format_on_save {:timeout_ms 500
                          :lsp_format :fallback}}}
 {1 "yetone/avante.nvim"
  :dependencies ["nvim-lua/plenary.nvim" "MunifTanjim/nui.nvim"]
  :event ["VeryLazy"]
  :opts {:provider :claude}}
 ]
