(require-macros :lib.macros)
(require-macros :lib.advice.macros)
(local windows (require :windows))
(local emacs (require :emacs))
(local slack (require :slack))
(local vim (require :vim))

(local {: concat
        : logf} (require :lib.functional))

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
;; [x] |-- arstzxcd - grid presets
;; [x] |-- 678 - thirds
;; [x] |-- p - maximize
;; [x] |-- u - undo
;;
;; [x] a - apps
;; [x] |-- b - browser
;; [x] |-- i - WezTerm
;; [x] |-- s - Slack
;; [x] |-- r - Spotify
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

;; Make the grid hints look like my keyboard layout
(set hs.grid.HINTS
     [[ "f1" "f2" "f3" "f4" "f5" "f6" "f7" "f8" "f9" "f10" ]
      [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ]
      [ "Q" "W" "F" "P" "V" "J" "L" "U" "Y" ";" ]
      [ "A" "R" "S" "T" "G" "M" "N" "E" "I" "O" ]
      [ "Z" "X" "C" "D" "B" "K" "H" "," "." "/" ]])

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
         :action #(windows.resize-to-grid "0,0 3x4")
         :repeatable true}
        {:key :r
         :action #(windows.resize-to-grid "0,0 4x4")
         :repeatable true}
        {:key :s
         :action #(windows.resize-to-grid "0,0 5x4")
         :repeatable true}
        {:key :t
         :action #(windows.resize-to-grid "0,0 6x4")
         :repeatable true}
        {:key "zxcd"
         :title "right side presets"}
        {:key :z
         :action #(windows.resize-to-grid "3,0 6x4")
         :repeatable true}
        {:key :x
         :action #(windows.resize-to-grid "4,0 5x4")
         :repeatable true}
        {:key :c
         :action #(windows.resize-to-grid "5,0 4x4")
         :repeatable true}
        {:key :d
         :action #(windows.resize-to-grid "6,0 3x4")
         :repeatable true}
        {:key "678"
         :title "thirds"}
        {:key :6
         :action #(windows.resize-to-grid "0,0 3x4")
         :repeatable true}
        {:key :7
         :action #(windows.resize-to-grid "3,0 3x4")
         :repeatable true}
        {:key :8
         :action #(windows.resize-to-grid "6,0 3x4")
         :repeatable true}])

(local window-bindings
       (concat
        [return
         {:key :w
          :title "Last Window"
          :action "windows:jump-to-last-window"}]
        window-jumps
        window-halves
        window-increments
        window-resize
        window-move-screens
        window-presets
        [{:key :p
          :title "Maximize"
          :action "windows:maximize-window-frame"
          :repeatable true}
         {:key :f
          :title "Center"
          :action "windows:center-window-frame"
          :repeatable true}
         {:key :g
          :title "Grid"
          :action "windows:show-grid"}
         {:key :u
          :title "Undo"
          :action "windows:undo"
          :repeatable true}]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apps Menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; These are behind the 'a' submenu
(local app-bindings
       [return
        {:key :r
         :title music-app
         :action (activator music-app)}
        {:key :s
         :title "Slack"
         :action (activator "Slack")}
        {:key :t
         :title "WezTerm"
         :action (activator "WezTerm")}
        {:key :c
         :title "Whatsapp"
         :action (activator "Whatsapp")}
        {:key :d
         :title "Discord"
         :action (activator "Discord")}
        {:key :b
         :title browser-app
         :action (activator browser-app)}
        {:key :q
         :title "Roam Research"
         :action (activator "Roam Research")}
        {:key :f
         :title "Finder"
         :action (activator "Finder")}
        {:key :p
         :title "Preview"
         :action (activator "Preview")}
        {:key :o
         :title "Obsidian"
         :action (activator "Obsidian")}])

; These are behind the 'm' submenu
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; App hotkeys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local app-keys
       [{:mods hyper-mods
         :key :r
         :action (activator music-app)}
        {:mods hyper-mods
         :key :s
         :action (activator "Slack")}
        {:mods hyper-mods
         :key :t
         :action (activator "WezTerm")}
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
         :key :x
         :action (activator "Visual Studio Code")}])

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
       [{:key :w
         :title "Window"
         :enter "windows:enter-window-menu"
         :exit "windows:exit-window-menu"
         :items window-bindings}
        {:key :a
         :title "Apps"
         :items app-bindings}
        {:key :j
         :title "Jump"
         :action "windows:jump"}
        {:key :m
         :title "Media"
         :items media-bindings}
        {:key :v
         :title "Clipboard"
         :action #(: (require :TextClipboardHistory) :toggleClipboard)}
        {:key "/"
         :title "KSheet"
         :action #(: (require :KSheet) :toggle)}])

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
                 :action hs.toggleConsole}]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; App Specific Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(local browser-config
       {:key browser-app})

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
                :key :g
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
                :key :p
                :action "slack:up"}
               {:mods [:ctrl]
                :key :n
                :action "slack:down"}]})

(local roam-config
       {:key "Roam Research"
        :keys [{:mods [:ctrl]
                :key :p
                :action "slack:up"}
               {:mods [:ctrl]
                :key :n
                :action "slack:down"}]})

(local apps
       [browser-config
        hammerspoon-config
        slack-config
        obsidian-config
        roam-config])

(local config
       {:title "Main Menu"
        :items menu-items
        :keys common-keys
        :enter #(windows.hide-display-numbers)
        :exit #(windows.hide-display-numbers)
        :apps apps
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
           (each [_ screen (pairs (hs.screen.allScreens))]
             (hs.alert.show str
                            (or style 1)
                            screen
                            seconds)))

;; Make window highlights smaller and faster
(defadvice my-highlight-active-window
           []
           :override windows.highlight-active-window
           "Highlight selected windows for a shorter amount of time, and in red"
           (let [rect (hs.drawing.rectangle (: (hs.window.focusedWindow) :frame))]
             (: rect :setStrokeColor {:red 1 :blue 0 :green 0 :alpha 1})
             (: rect :setStrokeWidth 3)
             (: rect :setFill false)
             (: rect :show)
             (hs.timer.doAfter .1 #(: rect :delete))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spoons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(hs.loadSpoon "SpoonInstall")
(local Install spoon.SpoonInstall)

;; Simple clipboard manager
(Install:andUse "TextClipboardHistory"
                {:config {:show_in_menubar true
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
