;; Copyright (c) 2017-2020 Ag Ibragimov & Contributors
;;
;;; Author: Ag Ibragimov <agzam.ibragimov@gmail.com>
;;
;;; Contributors:
;;   Jay Zawrotny <jayzawrotny@gmail.com>
;;
;;; URL: https://github.com/agzam/spacehammer
;;
;;; License: MIT
;;


(require-macros :lib.macros)
(require-macros :lib.advice.macros)
(local windows (require :windows))
(local emacs (require :emacs))
(local slack (require :slack))
(local vim (require :vim))

(local {:concat concat
        :logf logf} (require :lib.functional))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WARNING
;; Make sure you are customizing ~/.spacehammer/config.fnl and not
;; ~/.hammerspoon/config.fnl
;; Otherwise you will lose your customizations on upstream changes.
;; A copy of this file should already exist in your ~/.spacehammer directory.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Table of Contents
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; [x] w - windows
;; [x] |-- w - Last window
;; [x] |-- cmd + hjkl - jumping
;; [x] |-- hjkl - halves
;; [x] |-- alt + hjkl - increments
;; [x] |-- shift + hjkl - resize
;; [x] |-- n, p - next, previous screen
;; [x] |-- shift + n, p - up, down screen
;; [x] |-- g - grid
;; [x] |-- arstneio - grid presets
;; [x] |-- space - maximize
;; [x] |-- c - center
;; [x] |-- u - undo
;;
;; [x] a - apps
;; [x] |-- e - emacs
;; [x] |-- b - browser
;; [x] |-- i - iTerm
;; [x] |-- s - Slack
;;
;; [x] j - jump
;;
;; [x] m - media
;; [x] |-- h - previous track
;; [x] |-- l - next track
;; [x] |-- k - volume up
;; [x] |-- j - volume down
;; [x] |-- s - play\pause
;; [x] |-- a - launch player
;;
;; [x] x - emacs
;; [x] |-- c - capture
;; [x] |-- z - note
;; [x] |-- f - fullscreen
;; [x] |-- v - split
;;
;; [x] alt-n - next-app
;; [x] alt-p - prev-app


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Actions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(fn activator
  [app-name]
  "
  A higher order function to activate a target app. It's useful for quickly
  binding a modal menu action or hotkey action to launch or focus on an app.
  Takes a string application name
  Returns a function to activate that app.

  Example:
  (local launch-emacs (activator \"Emacs\"))
  (launch-emacs)
  "
  (fn activate []
    (windows.activate-app app-name)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If you would like to customize this we recommend copying this file to
;; ~/.spacehammer/config.fnl. That will be used in place of the default
;; and will not be overwritten by upstream changes when spacehammer is updated.
(local music-app "Spotify")
(local browser-app
       (hs.application.nameForBundleID (hs.urlevent.getDefaultHandler "http")))

(local return
       {:key :space
        :title "Back"
        :action :previous})

(local hyper-mods [:alt :cmd :ctrl])

;; Make window resizes instant
(tset hs.window "animationDuration" 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Windows
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local window-jumps
       [{:mods [:cmd]
         :key "hjkl"
         :title "Jump"}
        {:mods [:cmd]
         :key :h
         :action "windows:jump-window-left"
         :repeatable true}
        {:mods [:cmd]
         :key :j
         :action "windows:jump-window-above"
         :repeatable true}
        {:mods [:cmd]
         :key :k
         :action "windows:jump-window-below"
         :repeatable true}
        {:mods [:cmd]
         :key :l
         :action "windows:jump-window-right"
         :repeatable true}])

(local window-halves
       [{:key "hjkl"
         :title "Halves"}
        {:key :h
         :action "windows:resize-half-left"
         :repeatable true}
        {:key :j
         :action "windows:resize-half-bottom"
         :repeatable true}
        {:key :k
         :action "windows:resize-half-top"
         :repeatable true}
        {:key :l
         :action "windows:resize-half-right"
         :repeatable true}])

(local window-increments
       [{:mods [:alt]
         :key "hjkl"
         :title "Increments"}
        {:mods [:alt]
         :key :h
         :action "windows:resize-inc-left"
         :repeatable true}
        {:mods [:alt]
         :key :j
         :action "windows:resize-inc-bottom"
         :repeatable true}
        {:mods [:alt]
         :key :k
         :action "windows:resize-inc-top"
         :repeatable true}
        {:mods [:alt]
         :key :l
         :action "windows:resize-inc-right"
         :repeatable true}])

(local window-resize
       [{:mods [:shift]
         :key "hjkl"
         :title "Resize"}
        {:mods [:shift]
         :key :h
         :action "windows:resize-left"
         :repeatable true}
        {:mods [:shift]
         :key :j
         :action "windows:resize-down"
         :repeatable true}
        {:mods [:shift]
         :key :k
         :action "windows:resize-up"
         :repeatable true}
        {:mods [:shift]
         :key :l
         :action "windows:resize-right"
         :repeatable true}])

(local window-move-screens
       [{:key "n, p"
         :title "Move next\\previous screen"}
        {:mods [:shift]
         :key "n, p"
         :title "Move up\\down screens"}
        {:key :n
         :action "windows:move-south"
         :repeatable true}
        {:key :p
         :action "windows:move-north"
         :repeatable true}
        {:mods [:shift]
         :key :n
         :action "windows:move-west"
         :repeatable true}
        {:mods [:shift]
         :key :p
         :action "windows:move-east"
         :repeatable true}])

(local window-presets
       [{:key "arst"
         :title "left side presets"}
        {:key :a
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "0,0 3x4"))
         :repeatable true}
        {:key :r
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "0,0 4x4"))
         :repeatable true}
        {:key :s
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "0,0 5x4"))
         :repeatable true}
        {:key :t
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "0,0 6x4"))
         :repeatable true}
        {:key "neio"
         :title "right side presets"}
        {:key :n
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "3,0 6x4"))
         :repeatable true}
        {:key :e
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "4,0 5x4"))
         :repeatable true}
        {:key :i
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "5,0 4x4"))
         :repeatable true}
        {:key :o
         :action (fn [] (hs.grid.set (hs.window.focusedWindow) "6,0 3x4"))
         :repeatable true}
        ])

(local window-bindings
       (concat
        [{:key :w
          :title "Last Window"
          :action "windows:jump-to-last-window"}]
        window-jumps
        window-halves
        window-increments
        window-resize
        window-move-screens
        window-presets
        [{:key :space
          :title "Maximize"
          :action "windows:maximize-window-frame"
          :repeatable true}
         {:key :c
          :title "Center"
          :action "windows:center-window-frame"
          :repeatable true}
         {:key :g
          :title "Grid"
          :action "windows:show-grid"}
         {:key :u
          :title "Undo"
          :action "windows:undo-action"
          :repeatable true}]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apps Menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local app-bindings
       [return
        {:key :e
         :title "Emacs"
         :action (activator "Emacs")}
        {:key :b
         :title "Browser"
         :action (activator browser-app)}
        {:key :t
         :title "iTerm"
         :action (activator "iTerm2")}
        {:key :s
         :title "Slack"
         :action (activator "Slack")}
        {:key :r
         :title music-app
         :action (activator music-app)}])

(local media-bindings
       [return
        {:key :s
         :title "Play or Pause"
         :action "multimedia:play-or-pause"}
        {:key :h
         :title "Prev Track"
         :action "multimedia:prev-track"}
        {:key :l
         :title "Next Track"
         :action "multimedia:next-track"}
        {:key :j
         :title "Volume Down"
         :action "multimedia:volume-down"
         :repeatable true}
        {:key :k
         :title "Volume Up"
         :action "multimedia:volume-up"
         :repeatable true}
        {:key :a
         :title (.. "Launch " music-app)
         :action (activator music-app)}])

(local emacs-bindings
       [return
        {:key :c
         :title "Capture"
         :action (fn [] (emacs.capture))}
        {:key :z
         :title "Note"
         :action (fn [] (emacs.note))}
        {:key :v
         :title "Split"
         :action "emacs:vertical-split-with-emacs"}
        {:key :f
         :title "Full Screen"
         :action "emacs:full-screen"}])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; App hotkeys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local app-keys
       [{:mods hyper-mods
         :key :r
         :action (activator "Spotify")}
        {:mods hyper-mods
         :key :s
         :action (activator "Slack")}
        {:mods hyper-mods
         :key :t
         :action (activator "iTerm2")}
        {:mods hyper-mods
         :key :c
         :action (activator "Whatsapp")}
        {:mods hyper-mods
         :key :d
         :action (activator "Discord")}
        {:mods hyper-mods
         :key :b
         :action (activator browser-app)}
        {:mods hyper-mods
         :key :q
         :action (activator "Roam Research")}
        {:mods hyper-mods
         :key :f
         :action (activator "Finder")}
        {:mods hyper-mods
         :key :p
         :action (activator "Preview")}
        {:mods hyper-mods
         :key :o
         :action (activator "Obsidian")}
        {:mods hyper-mods
         :key :e
         :action (activator "Emacs")}
        ])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Repl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local repl (require :repl))
(local repl-keys
       [{:mods [:alt :cmd]
         :key :r
         :action (fn []
                   (alert "creating repl server")
                   (global repl-server (repl.start {:host "127.0.0.1"})))}
        {:mods [:alt :cmd]
         :key :s
         :action (fn []
                   (alert "running repl server")
                   (repl.run repl-server))}
        {:mods [:alt :cmd]
         :key :t
         :action (fn []
                   (alert "stopping repl server")
                   (repl.stop repl-server))}])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Menu & Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local menu-items
       [{:key   :w
         :title "Window"
         :enter "windows:enter-window-menu"
         :exit "windows:exit-window-menu"
         :items window-bindings}
        {:key   :a
         :title "Apps"
         :items app-bindings}
        {:key    :j
         :title  "Jump"
         :action "windows:jump"}
        {:key   :m
         :title "Media"
         :items media-bindings}
        {:key   :e
         :title "Emacs"
         :items emacs-bindings}])

(local common-keys
       (concat app-keys
               repl-keys
               [{:mods hyper-mods
                 :key :w
                 :action "lib.modal:activate-modal"}
                {:mods [:alt]
                 :key :n
                 :action "apps:next-app"}
                {:mods [:alt]
                 :key :p
                 :action "apps:prev-app"}
                {:mods [:cmd :ctrl]
                 :key "`"
                 :action hs.toggleConsole}
                {:mods [:cmd :ctrl]
                 :key :o
                 :action "emacs:edit-with-emacs"}]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; App Specific Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local browser-keys
       [{:mods [:cmd :shift]
         :key :l
         :action "chrome:open-location"}
        {:mods hyper-mods
         :key :n
         :action "chrome:next-tab"
         :repeat true}
        {:mods hyper-mods
         :key :p
         :action "chrome:prev-tab"
         :repeat true}])

(local browser-items
       (concat
        menu-items
        [{:key "'"
          :title "Edit with Emacs"
          :action "emacs:edit-with-emacs"}]))

(local browser-config
       {:key browser-app
        :keys browser-keys
        :items browser-items})

(local emacs-config
       {:key "Emacs"
        :activate (fn [] (vim.disable))
        :deactivate (fn [] (vim.enable))
        :launch "emacs:maximize"
        :items []
        :keys []})

(local hammerspoon-config
       {:key "Hammerspoon"
        :items (concat
                menu-items
                [{:key :r
                  :title "Reload Console"
                  :action hs.reload}
                 {:key :c
                  :title "Clear Console"
                  :action hs.console.clearConsole}])
        :keys []})

(local slack-config
       {:key "Slack"
        :keys [{:mods [:cmd]
                :key  :g
                :action "slack:scroll-to-bottom"}
               {:mods [:ctrl]
                :key :r
                :action "slack:add-reaction"}
               {:mods [:ctrl]
                :key :t
                :action "slack:thread"}
               {:mods [:ctrl]
                :key :p
                :action "slack:up"}
               {:mods [:ctrl]
                :key :n
                :action "slack:down"}
               {:mods [:alt]
                :key :f
                :action "slack:scroll-down"
                :repeat true}
               {:mods [:alt]
                :key :b
                :action "slack:scroll-up"
                :repeat true}
               {:mods [:alt]
                :key :d
                :action (fn []
                          (slack.scroll-down)
                          (slack.scroll-down))
                :repeat true}
               {:mods [:alt]
                :key :u
                :action (fn []
                          (slack.scroll-up)
                          (slack.scroll-up))
                :repeat true}
               {:mods [:ctrl]
                :key :i
                :action "slack:next-history"
                :repeat true}
               {:mods [:ctrl]
                :key :o
                :action "slack:prev-history"
                :repeat true}
               {:mods [:ctrl]
                :key :j
                :action "slack:next-day"
                :repeat true}
               {:mods [:ctrl]
                :key :k
                :action "slack:prev-day"
                :repeat true}]})

(local obsidian-config
       {:key "Obsidian"
        :keys [{:mods [:ctrl]
                :key  :p
                :action "slack:up"}
               {:mods [:ctrl]
                :key  :n
                :action "slack:down"}]})

(local apps
       [browser-config
        emacs-config
        hammerspoon-config
        slack-config
        obsidian-config])

(local config
       {:title "Main Menu"
        :items menu-items
        :keys  common-keys
        :enter (fn [] (windows.hide-display-numbers))
        :exit  (fn [] (windows.hide-display-numbers))
        :apps  apps
        :grid {:size "9x4"}
        :hyper {:key :F18}})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Make alerts show on all screens
(defadvice alert-all
           [str style seconds]
           :override alert
           "Replace core.alert with one that alerts on all screens"
           (each [_ screen (pairs  (hs.screen.allScreens))]
             (hs.alert.show str
                            (or style 1)
                            screen
                            seconds)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spoons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(hs.loadSpoon "SpoonInstall")
(local Install spoon.SpoonInstall)

;; Simple clipboard manager
(Install:andUse "TextClipboardHistory"
                {:config {:show_in_menubar false
                          :paste_on_select true}
                 :hotkeys {:toggle_clipboard [hyper-mods "v"] }
                 :start true})

;; Show a cheatsheet of hotkeys for the current app
(Install:andUse "KSheet"
                {:hotkeys {:toggle [hyper-mods "/"]}})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Exports
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

config
