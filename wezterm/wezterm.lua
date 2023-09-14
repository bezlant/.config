local wezterm = require("wezterm")
return {
	color_scheme = "Dracula (Official)",
	font = wezterm.font("Victor Mono"),
	font_size = 14,
	window_decorations = 'RESIZE',
	enable_tab_bar = false,
	window_padding = {
        left = 0,
        right = 0,
        top = 0,
		bottom = 0,
	},
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
}
