local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local act = wezterm.action

-- Visual
config.font = wezterm.font('OperatorMonoNerdFontPlusFontAwesomePlusOcticons Nerd Font')
config.color_scheme = 'N0tch2k'

-- Key bindings
config.leader = { key = 'i', mods = "CMD|CTRL|OPT" }
config.keys = {
  -- CTRL-SHIFT-L: Debug overlay (logging + REPL)
  -- CMD-R: Reload config
  -- CMD-F: Search
  -- Use `action = wezterm.action_callback(func)` to assign callback
  {
    key = 's',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'v',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane({ confirm = true })},
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState},
}

return config
