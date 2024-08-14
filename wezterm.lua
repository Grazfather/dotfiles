local wezterm = require "wezterm"

local config = wezterm.config_builder()
local act = wezterm.action

-- Visual
config.font = wezterm.font("Operator Mono SSm Lig")
config.color_scheme = "N0tch2k"

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 6

config.audible_bell = "Disabled"

-- More aggressively dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}

wezterm.on("update-right-status", function(window, pane)
  status = ""
  if window:leader_is_active() then status = "LEADER" end
  if window:active_key_table() then status = window:active_key_table() end

  window:set_right_status(wezterm.format({
    { Text = status },
  }))
end)

-- Key bindings
-- -- Same prefix as Tmux
config.leader = { key = "o", mods = "CTRL" }
config.keys = {
  -- CTRL-SHIFT-L: Debug overlay (logging + REPL)
  -- CMD-R: Reload config
  -- CMD-F: Search
  -- Use `action = wezterm.action_callback(func)` to assign callback
  -- Hit the prefix again to send it 'through' e.g. to Tmux
  { key = "o", mods = "LEADER", action = act.SendKey({ key = "o", mods = "CTRL" }) },
  { key = ":", mods = "LEADER", action = act.ActivateCommandPalette },
  -- Rename current tab
  {
    key = ",",
    mods = "LEADER", action = act.PromptInputLine {
      description = "Tab name:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- Split panes - Vim and Tmux style
  { key = "s", mods = "LEADER", action = act.SplitVertical },
  { key = "\"", mods = "LEADER", action = act.SplitVertical },
  { key = "v", mods = "LEADER", action = act.SplitHorizontal },
  { key = "%", mods = "LEADER", action = act.SplitHorizontal },
  -- Move panes
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  -- Resize panes
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  -- Move tabs
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "a", mods = "LEADER|CTRL", action = act.ActivateLastTab },
  -- Move word-wise
  { key = "LeftArrow", mods = "OPT", action = wezterm.action.SendString("\x1bb") },
  { key = "RightArrow", mods = "OPT", action = wezterm.action.SendString("\x1bf") },
  -- QuickSelect
  { key = "y", mods = "LEADER", action = act.QuickSelect },
  -- Copy mode
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
}

config.key_tables = {
  resize_pane = {
    { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "Escape", action = act.PopKeyTable },
  },
}

return config
