local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

config = {
  color_scheme                                = "Dracula (Official)",
  font                                        = wezterm.font("Victor Mono"),
  font_size                                   = 14,
  window_decorations                          = 'RESIZE',
  enable_tab_bar                              = false,
  window_padding                              = {
    left = 0,
    right = 0,
    top = 2,
    bottom = 0,
  },
  send_composed_key_when_left_alt_is_pressed  = true,
  send_composed_key_when_right_alt_is_pressed = true,
  disable_default_key_bindings                = true,
  keys                                        = {
    { key = "=",     mods = "CMD",  action = action.ResetFontSize },
    { key = "-",     mods = "CMD",  action = action.DecreaseFontSize },
    { key = "+",     mods = "CMD",  action = action.IncreaseFontSize },
    { key = "c",     mods = "CMD",  action = action.CopyTo("Clipboard") },
    { key = "v",     mods = "CMD",  action = action.PasteFrom("Clipboard") },
    { key = "Copy",  mods = "NONE", action = action.CopyTo("Clipboard") },
    { key = "Paste", mods = "NONE", action = action.PasteFrom("Clipboard") },
    { key = "q",     mods = "CMD",  action = action.CloseCurrentPane { confirm = true } },
  }
}

return config
