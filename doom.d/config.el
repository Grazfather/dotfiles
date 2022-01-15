;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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
(setq doom-theme 'doom-gruvbox)

(setq org-directory "~/org/")

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
;;
;; Use `SPC c e` to eval these settings to apply them without restarting Emacs

;; Disable smart parens
;; (remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; Default to soft wrapping long lines
(global-visual-line-mode t)

;; Maximise the window on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

; Open new split panes to the right and bottom
(setq evil-vsplit-window-right t
      evil-split-window-below t)

(setq lsp-file-watch-threshold 5000)

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

;; Make line-join keep the cursor in place
(evil-define-operator join-line-nomove (beg end)
  :motion evil-forward-char
  (evil-set-marker 122)
  (evil-join beg end)
  (evil-goto-mark 122))
(map! :n "J" #'join-line-nomove)

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

;; Similarly, for avy/evil-easymotion I want the keys under my fingers
(after! avy
  (setq avy-keys '(?a ?r ?s ?t ?n ?e ?i ?o)))

;; Buffer nav
(map! :n "C-n" #'next-buffer
      :n "C-p" #'previous-buffer)

;; Workspace (tab) nav
(map! :leader :prefix "TAB"
      :desc "Next workspace" "n" #'+workspace/switch-right
      :desc "Previous workspace" "p" #'+workspace/switch-left
      :desc "New workspace" "c" #'+workspace/new)
;; -- Unbind C-t which is normally new workspace
(undefine-key! evil-normal-state-map "C-t")

; I don't use Evil's evil-respect-visual-line-mode, but I still want the
; behaviour for navigating lines
(map! :n "k" #'evil-previous-visual-line
      :n "gk" #'evil-previous-line
      :n "j" #'evil-next-visual-line
      :n "gj" #'evil-next-line)

(after! orderless
  (setq orderless-matching-styles '(orderless-flex)))

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

; Map expand & contract -region
(map! :nv "ghe" #'er/expand-region)
(map! :nv "ghi" #'er/contract-region)

; Quick toggle line comment
(map! :leader :prefix "c"
      :desc "Toggle line comment" "SPC" "gcc")

;; LANGUAGE SPECIFIC
; Don't autoformat python -- Black is too aggressive
(add-to-list '+format-on-save-enabled-modes 'python-mode t)

; Tell the LSP to not monitor Go vendor files
(after! lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]vendor\\'" t))

; Add easier binding to move between sexps
(map! (:after smartparens
       :map smartparens-mode-map
       "M-f" #'sp-forward-sexp
       "M-b" #'sp-backward-sexp))

; Lispyville needs Lispy, but I don't want to ever use the insane lispy-mode
; bindings.
(use-package! lispy)
(use-package! lispyville
  :hook ((lisp-mode . lispyville-mode)
         (emacs-lisp-mode . lispyville-mode)
         (ielm-mode . lispyville-mode)
         (scheme-mode . lispyville-mode)
         (racket-mode . lispyville-mode)
         (hy-mode . lispyville-mode)
         (lfe-mode . lispyville-mode)
         (dune-mode . lispyville-mode)
         (clojure-mode . lispyville-mode)
         (fennel-mode . lispyville-mode))
  :init
  (setq
   lispyville-key-theme
   '(; Make some operators smarter
     ; - D/C will delete/change to the end of the line but not delete closing
     ;   parens if it'll make them unbalanced
     ; - x will delete the matching paren/bracket/curly brace
     (operators normal)
     ; Ctrl-w and Ctrl-u are sexp aware
     ; For example, Ctrl-w will delete a whole sexp if it's the previous word
     c-w c-u
     (atom-movement t)
     ; >/< to 'grow' and 'shrink' sexps
     slurp/barf-lispy
     ; M-j/k to swap (drag) atoms forward/back
     ; M-s to splice (remove surrounding)
     ; M-S to join
     additional
     ; M-{i,a,o,O} for sexp-aware enter insert
     ; For example, if the sexp is split over multiple lines, it'll enter insert
     ; mode before or after the sexp, instead of next to that exact line.
     additional-insert))
  :config (lispyville-set-key-theme))

(after! evil-goggles
  (setq evil-goggles-enable-delete t
        evil-goggles-enable-change t))
