local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

config = {
  color_scheme                                = "Dracula (Official)",
  native_macos_fullscreen_mode                = true,
  font                                        = wezterm.font("VictorMono Nerd Font Mono"),
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

wezterm.on('user-var-changed', function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while (number_value > 0) do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

return config
