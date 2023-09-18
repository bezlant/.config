local wezterm = require("wezterm")
local action = wezterm.action

return {
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
    { key = "=", mods = "CTRL", action = action.ResetFontSize },
    { key = "-", mods = "CTRL", action = action.DecreaseFontSize },
    { key = "=", mods = "CTRL", action = action.IncreaseFontSize },
    { key = "P", mods = "CTRL", action = action.ActivateCommandPalette },
    { key = "V", mods = "CTRL", action = action.PasteFrom("Clipboard") },
  }
}
