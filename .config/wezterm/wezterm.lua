local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE" -- disable the title bar but enable the reisizable border
config.color_scheme = "Tokyo Night"
config.font = wezterm.font_with_fallback({
	{family = "JetBrainsMono Nerd Font", weight = "DemiBold" },
	{family = "feather"},
})
config.font_size = 12.5
config.window_padding = {
	left = 3,
	right = 3,
	top = 0,
	bottom = 0,
}

return config
