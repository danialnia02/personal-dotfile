local wezterm = require("wezterm")
-- local tabline = require("https://github.com/michaelbrusegard/tabline.wez")

local config = wezterm.config_builder()

config = {
	default_cwd = os.getenv("USERPROFILE") .. "\\Desktop",
	default_prog = { "pwsh.exe" },
	automatically_reload_config = true,
	enable_kitty_graphics = true,
	window_close_confirmation = "NeverPrompt",
	initial_cols = 130,
	initial_rows = 33,
	-- window_decorations = "RESIZE",
	-- default_cursor_style = "BlinkingBar",
	color_scheme = "One Half Dark",
	-- font = wezterm.font("JetBrainsMono NFM Medium"),
	font = wezterm.font("Cascadia Mono"),
	font_size = 11,
	-- font_size = 14,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	colors = {
		background = "black",
		compose_cursor = "orange",

		-- tab bar styles
		tab_bar = {
			background = "rgba(0,0,0,0)",
		},
	},
	window_background_opacity = 0.80,
	-- tab bars
	-- enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = false,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	tab_max_width = 17,

	foreground_text_hsb = {
		hue = 1.0,
		saturation = 1.0,
		brightness = 1.1,
	},
	-- enable_csi_u_key_encoding = true,
	-- default_domain = 'WSL:Ubuntu',
}

raw_input_mode = true

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via tab:set_title()
-- or wezterm cli set-tab-title, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#333333"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#2b2042"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = wezterm.nerdfonts.pl_right_hard_divider },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = wezterm.nerdfonts.pl_left_hard_divider },
	}
end)
-- keybindings
config.leader = { key = "\\", timeout_millisceonds = 2000 }

config.keys = {
	{ action = wezterm.action.SendKey({ key = "CapsLock" }), mods = "NONE", key = "CapsLock" },
	-- { action = wezterm.action.Nop, mods = "NONE", key = "CapsLock" },
	{ action = wezterm.action.SendKey({ key = "Control" }), mods = "NONE", key = "Control" },
	{ action = wezterm.action.CopyTo("Clipboard"), mods = "CTRL|SHIFT", key = "C" }, -- copy paste (not sure why not working)
	{ action = wezterm.action.PasteFrom("Clipboard"), mods = "CTRL|SHIFT", key = "V" }, -- copy paste (not sure why not working)
	{ action = wezterm.action.SpawnTab("CurrentPaneDomain"), mods = "LEADER", key = "c" },
	{ action = wezterm.action.CloseCurrentPane({ confirm = true }), mods = "LEADER", key = "x" },
	{ action = wezterm.action.ActivateTabRelative(-1), mods = "LEADER", key = "b" },
	{ action = wezterm.action.ActivateTabRelative(1), mods = "LEADER", key = "n" },
	{ action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }), mods = "LEADER", key = "v" }, -- create vertical pane
	{ action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }), mods = "LEADER", key = "-" }, -- create horizontal pane
	{ action = wezterm.action.ActivatePaneDirection("Left"), mods = "LEADER", key = "h" }, -- moving pane left
	{ action = wezterm.action.ActivatePaneDirection("Down"), mods = "LEADER", key = "j" }, -- moving pane down
	{ action = wezterm.action.ActivatePaneDirection("Up"), mods = "LEADER", key = "k" }, -- moving pane up
	{ action = wezterm.action.ActivatePaneDirection("Right"), mods = "LEADER", key = "l" }, -- moving pane right
	{ action = wezterm.action.AdjustPaneSize({ "Left", 5 }), mods = "LEADER", key = "LeftArrow" }, -- changing pane size
	{ action = wezterm.action.AdjustPaneSize({ "Right", 5 }), mods = "LEADER", key = "RightArrow" }, -- changing pane size
	{ action = wezterm.action.AdjustPaneSize({ "Down", 5 }), mods = "LEADER", key = "DownArrow" }, -- changing pane size
	{ action = wezterm.action.AdjustPaneSize({ "Up", 5 }), mods = "LEADER", key = "UpArrow" }, -- changing pane size
	{ action = wezterm.action.SendKey({ key = "\\" }), mods = "CTRL", key = "\\" }, -- send \ string
	{ action = wezterm.action.MoveTabRelative(1), mods = "LEADER", key = "." }, -- shift tab to right
	{ action = wezterm.action.MoveTabRelative(-1), mods = "LEADER", key = "," }, -- shift tab to left

	{
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 0.80 then
				overrides.window_background_opacity = 1
			else
				overrides.window_background_opacity = 0.80
			end
			window:set_config_overrides(overrides)
		end),
		mods = "LEADER",
		key = "`",
	}, -- moving pane right
}

--tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#000000" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

for i = 0, 9 do
	-- leader + number to activate that tab
	local number = i - 1
	table.insert(config.keys, { action = wezterm.action.ActivateTab(number), mods = "LEADER", key = tostring(i) })
end

return config
