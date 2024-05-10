local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local act = wezterm.action

-- Visual
config.font = wezterm.font('Operator Mono SSm Lig')
config.color_scheme = 'N0tch2k'

config.audible_bell = 'Disabled'

-- Key bindings
config.leader = { key = ',', mods = 'CTRL' }
config.keys = {
  -- CTRL-SHIFT-L: Debug overlay (logging + REPL)
  -- CMD-R: Reload config
  -- CMD-F: Search
  -- Use `action = wezterm.action_callback(func)` to assign callback
  { key = ':', mods = 'LEADER', action = act.ActivateCommandPalette },
  { key = 's', mods = 'LEADER', action = act.SplitVertical },
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane({ confirm = true }) },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'a', mods = 'LEADER|CTRL', action = act.ActivateLastTab },
}

return config
