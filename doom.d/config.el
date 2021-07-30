;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 12))
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Use `SPC c e` to eval these settings to apply them without restarting Emacs

;; Disable smart parens
;; (remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; This mapping is so that I can see what expression was run for what I just did
(map! :leader :prefix "h" "z" #'repeat-complex-command)

;; Default to soft wrapping long lines
(global-visual-line-mode t)

;; Maximise the window on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

; Open new split panes to the right and bottom
(setq evil-vsplit-window-right t
      evil-split-window-below t)

(setq lsp-file-watch-threshold 5000)

; Don't have yanks/delete overwrite what I have in the system clipboard
(setq x-select-enable-clipboard nil)

;; Unbind C-z, which normally toggles emacs mode. This way I can background
;; emacs when run in the terminal.
(undefine-key! evil-insert-state-map "C-z")
(undefine-key! evil-motion-state-map "C-z")
(undefine-key! evil-normal-state-map "C-z")

;; This mapping is so that I can see what expression was run for what I just did
(map! :leader :prefix "h"
      :desc "Show/rerun last expression" "z" #'repeat-complex-command)

;; Map C-h to backspace in insert mode
(map! :i "C-h" #'backward-delete-char)

;; NAVIGATION
;; Disable arrow keys in evil mode
(map! :map override
      :nvi [left] #'ignore
      :nvi [down] #'ignore
      :nvi [up] #'ignore
      :nvi [right] #'ignore)

;; Window nav
(map! :map general-override-mode-map
      :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right)

;; Since I use colemak and I want the window switch keys under my fingers
(after! switch-window
  (setq switch-window-shortcut-style 'qwerty
        switch-window-qwerty-shortcuts '("a" "r" "s" "t" "n" "e" "i" "o")
        switch-window-shortcut-appearance 'asciiart))

;; Buffer nav
(map! :n "C-n" #'next-buffer
      :n "C-p" #'previous-buffer)

; I don't use Evil's evil-respect-visual-line-mode, but I still want the
; behaviour for navigating lines
(map! :n "k" #'evil-previous-visual-line
      :n "gk" #'evil-previous-line
      :n "j" #'evil-next-visual-line
      :n "gj" #'evil-next-line)

;; Highlight DELETEME in my code
(after! hl-todo
  (pushnew! hl-todo-keyword-faces '("DELETEME" error bold)))
; SPC d m to add a DELETEME comment
(map! :leader :prefix "d"
      :desc "Add DELETEME" "m" (kbd! "A SPC D E L E T E M E C-g b g c A")
      :desc "Delete all DELETEME lines" "d" ":g/DELETEME/d")


(map! :leader :prefix "e"
      :desc "Clear trailing whitespace" "W"
      (kbd! "m x : % s / \\ s + $ / / RET ` x")
      :desc "Convert tabs to spaces" "T"
      (kbd! "m x : % s / \\ t / SPC SPC SPC SPC SPC SPC SPC SPC / g RET ` x"))

(map! :leader :prefix "f"
      :desc "Toggle neotree" "t" #'+neotree/open)

; Map expand-region
(map! :nv "C-q" #'er/expand-region)

;; LANGUAGE SPECIFIC
; Don't autoformat python -- Black is too aggressive
(add-to-list '+format-on-save-enabled-modes 'python-mode t)

; Tell the LSP to not monitor Go vendor files
(after! lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]vendor\\'" t))
