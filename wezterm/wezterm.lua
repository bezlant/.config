local wezterm = require("wezterm")
return {
	color_scheme = "Dracula (Official)",
	font = wezterm.font("Victor Mono"),
	font_size = 14,
	enable_tab_bar = false,
	window_padding = {
		bottom = 0,
	},
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
}
