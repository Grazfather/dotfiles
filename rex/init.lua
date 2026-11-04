-- Same prefix as Tmux
local LEADER = "ctrl+o>"

-- Reload config
rex.bind("cmd+r", "client.config.reload")

-- Use ctrl-o as a prefix, as I use in tmux, hit it twice to send it through
rex.bind(LEADER .. "o", "pane.send_key", { key = "ctrl+o" })

-- Split panes - Vim and Tmux style
rex.bind(LEADER .. "v", "pane.split", { direction = "right" })
rex.bind(LEADER .. "shift+5", "pane.split", { direction = "right" })
rex.bind(LEADER .. "s", "pane.split", { direction = "down" })
rex.bind(LEADER .. "shift+'", "pane.split", { direction = "down" })

-- Jump between panes
rex.bind(LEADER .. "h", "pane.focus.left")
rex.bind(LEADER .. "j", "pane.focus.down")
rex.bind(LEADER .. "k", "pane.focus.up")
rex.bind(LEADER .. "l", "pane.focus.right")

-- Move (swap) panes
rex.bind(LEADER .. "shift+h", "pane.move.left")
rex.bind(LEADER .. "shift+j", "pane.move.down")
rex.bind(LEADER .. "shift+k", "pane.move.up")
rex.bind(LEADER .. "shift+l", "pane.move.right")

-- Zoom pane
rex.bind(LEADER .. "z", "pane.zoom")

-- Close pane
rex.bind(LEADER .. "x", "pane.close")

-- Rename tab
rex.bind(LEADER .. ",", "client.tab.rename")

-- Move between tabs
rex.bind(LEADER .. "n", "client.tab.next")
rex.bind(LEADER .. "p", "client.tab.previous")

-- Clear screen
rex.bind(LEADER .. "ctrl+k", "com.superlogical.terminal.clear")
