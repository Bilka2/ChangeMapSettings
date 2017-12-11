local mod_gui = require("mod-gui")
local util = require("utilities")
local gui = {}

-- GUI --
gui.kill = function(player)
	local button_flow = mod_gui.get_button_flow(player)
	local frame_flow = mod_gui.get_frame_flow(player)		
	if button_flow["change-map-settings-toggle-config"] then
		button_flow["change-map-settings-toggle-config"].destroy()
	end
	if frame_flow["change-map-settings-config-more-frame"] then
		frame_flow["change-map-settings-config-more-frame"].destroy()
	end
end

gui.make_config_option = function(parent, name, caption, tooltip, default, max_width)
	parent.add{
		type = "label",
		caption = caption,
		tooltip = tooltip,
		name = "change-map-settings-" .. name .. "-label",
	}
	local child = parent.add{
		type = "textfield",
		name = "change-map-settings-" .. name .. "-textfield",
	}
	child.text = default
	if max_width then child.style.maximal_width = max_width end
	return child
end

gui.make_general_settings = function(config_more_table)
	local config_more_option_general_flow = config_more_table.add{
		type = "flow",
		name = "change-map-settings-config-more-general-flow",
		direction = "vertical"
	}
	config_more_option_general_flow.add{
		type = "label",
		caption = {"gui.change-map-settings-general-title"},
		style = "caption_label",
		name = "change-map-settings-general-title-label",
	}
	local config_more_option_general_table = config_more_option_general_flow.add{
		type = "table",
		name = "change-map-settings-config-more-general-table",
		column_count = 2
	}
	
	config_more_option_general_table.add{
		type = "label",
		caption = {"gui-map-generator.peaceful-mode"},
		name = "change-map-settings-peaceful-label",
	}
	config_more_option_general_table.add{
		type = "checkbox",
		name = "change-map-settings-peaceful-checkbox",
		state = false,
	}
end

gui.make_expansion_settings = function(config_more_table, map_settings)
	local config_more_option_expansion_flow = config_more_table.add{
		type = "flow",
		name = "change-map-settings-config-more-expansion-flow",
		direction = "vertical"
	}
	config_more_option_expansion_flow.add{
		type = "label",
		caption = {"gui-map-generator.enemy-expansion-group-tile"},
		style = "caption_label",
		name = "change-map-settings-expansion-title-label",
	}
	local config_more_option_expansion_table = config_more_option_expansion_flow.add{
		type = "table",
		name = "change-map-settings-config-more-expansion-table",
		column_count = 2
	}
	
	config_more_option_expansion_table.add{
		type = "label",
		caption = {"gui-map-generator.enemy-expansion-group-tile"},
		name = "change-map-settings-enemy-expansion-label",
	}
	config_more_option_expansion_table.add{
		type = "checkbox",
		name = "change-map-settings-enemy-expansion-checkbox",
		state = map_settings.enemy_expansion.enabled,
	}
	local thirty = 30
	gui.make_config_option(config_more_option_expansion_table, "expansion-distance", {"gui-map-generator.enemy-expansion-maximum-expansion-distance"}, {"gui-map-generator.enemy-expansion-maximum-expansion-distance-description"}, tostring(map_settings.enemy_expansion.max_expansion_distance), thirty)
	gui.make_config_option(config_more_option_expansion_table, "expansion-min-size", {"gui-map-generator.enemy-expansion-minimum-expansion-group-size"}, {"gui-map-generator.enemy-expansion-minimum-expansion-group-size-description"}, tostring(map_settings.enemy_expansion.settler_group_min_size), thirty)
	gui.make_config_option(config_more_option_expansion_table, "expansion-max-size", {"gui-map-generator.enemy-expansion-maximum-expansion-group-size"}, {"gui-map-generator.enemy-expansion-maximum-expansion-group-size-description"}, tostring(map_settings.enemy_expansion.settler_group_max_size), thirty)
	gui.make_config_option(config_more_option_expansion_table, "expansion-min-cd", {"gui.change-map-settings-in-unit", {"gui-map-generator.enemy-expansion-minimum-expansion-cooldown"}, {"minute5+"}}, {"gui-map-generator.enemy-expansion-minimum-expansion-cooldown-description"},  tostring(map_settings.enemy_expansion.min_expansion_cooldown / 3600), thirty)
	gui.make_config_option(config_more_option_expansion_table, "expansion-max-cd", {"gui.change-map-settings-in-unit", {"gui-map-generator.enemy-expansion-maximum-expansion-cooldown"}, {"minute5+"}}, {"gui-map-generator.enemy-expansion-maximum-expansion-cooldown-description"}, tostring(map_settings.enemy_expansion.max_expansion_cooldown / 3600), thirty)
end

gui.make_pollution_settings = function(config_more_table, map_settings)
	local config_more_option_pollution_flow = config_more_table.add{
		type = "flow",
		name = "change-map-settings-config-more-pollution-flow",
		direction = "vertical"
	}
	config_more_option_pollution_flow.add{
		type = "label",
		caption = {"gui-map-generator.pollution"},
		style = "caption_label",
		name = "change-map-settings-pollution-title-label",
	}
	local config_more_option_pollution_table = config_more_option_pollution_flow.add{
		type = "table",
		name = "change-map-settings-config-more-pollution-table",
		column_count = 2
	}
	
	config_more_option_pollution_table.add{
		type = "label",
		caption = {"gui-map-generator.pollution"},
		name = "change-map-settings-pollution-label",
	}
	config_more_option_pollution_table.add{
		type = "checkbox",
		name = "change-map-settings-pollution-checkbox",
		state = map_settings.pollution.enabled,
	}
	gui.make_config_option(config_more_option_pollution_table, "pollution-diffusion", {"gui.change-map-settings-in-unit", {"gui-map-generator.pollution-diffusion-ratio"}, {"gui.change-map-settings-percent"}}, {"gui-map-generator.pollution-diffusion-ratio-description"}, tostring(map_settings.pollution.diffusion_ratio * 100), 50)
	gui.make_config_option(config_more_option_pollution_table, "pollution-dissipation", {"gui-map-generator.pollution-dissipation-rate"}, {"gui-map-generator.pollution-dissipation-rate-description"}, tostring(map_settings.pollution.ageing), 50)
	gui.make_config_option(config_more_option_pollution_table, "pollution-tree-dmg", {"gui-map-generator.minimum-pollution-to-damage-trees"}, {"gui-map-generator.minimum-pollution-to-damage-trees-description"}, tostring(map_settings.pollution.min_pollution_to_damage_trees), 50)
	gui.make_config_option(config_more_option_pollution_table, "pollution-tree-absorb", {"gui-map-generator.pollution-absorbed-per-tree-damaged"}, {"gui-map-generator.pollution-absorbed-per-tree-damaged-description"}, tostring(map_settings.pollution.pollution_restored_per_tree_damage), 50)
end

gui.make_evolution_settings = function(config_more_table, map_settings)
	local config_more_option_evo_flow = config_more_table.add{
		type = "flow",
		name = "change-map-settings-config-more-evo-flow",
		direction = "vertical"
	}
	config_more_option_evo_flow.add{
		type = "label",
		caption = {"gui-map-generator.evolution"},
		style = "caption_label",
		name = "change-map-settings-evolution-title-label",
	}
	local config_more_option_evo_table = config_more_option_evo_flow.add{
		type = "table",
		name = "change-map-settings-config-more-evo-table",
		column_count = 2
	}
	
	config_more_option_evo_table.add{
		type = "label",
		caption = {"gui-map-generator.evolution"},
		name = "change-map-settings-evolution-label",
	}
	config_more_option_evo_table.add{
		type = "checkbox",
		name = "change-map-settings-evolution-checkbox",
		state = map_settings.enemy_evolution.enabled,
	}
	gui.make_config_option(config_more_option_evo_table, "evolution-factor", {"gui-map-generator.evolution"}, {"gui.change-map-settings-evolution-factor-tooltip"}, util.float_to_string(game.forces["enemy"].evolution_factor), 80)
	gui.make_config_option(config_more_option_evo_table, "evolution-time", {"gui-map-generator.evolution-time-factor"}, {"gui-map-generator.evolution-time-factor-description"}, util.float_to_string(map_settings.enemy_evolution.time_factor), 80)
	gui.make_config_option(config_more_option_evo_table, "evolution-destroy", {"gui-map-generator.evolution-destroy-factor"}, {"gui-map-generator.evolution-destroy-factor-description"}, util.float_to_string(map_settings.enemy_evolution.destroy_factor), 80)
	gui.make_config_option(config_more_option_evo_table, "evolution-pollution", {"gui-map-generator.evolution-pollution-factor"}, {"gui-map-generator.evolution-pollution-factor-description"}, util.float_to_string(map_settings.enemy_evolution.pollution_factor), 80)
end

gui.make_advanced_settings = function(config_more_frame)
	local config_more_table = config_more_frame.add{
		type = "table",
		name = "change-map-settings-config-more-table",
		column_count = 2
	}
	config_more_table.style.horizontal_spacing = 20
	local map_settings = game.map_settings
	--make different advanced option groups
	gui.make_pollution_settings(config_more_table, map_settings)
	gui.make_evolution_settings(config_more_table, map_settings)
	gui.make_expansion_settings(config_more_table, map_settings)
	gui.make_general_settings(config_more_table)
end

function gui.regen(player)
	gui.kill(player)
	--toggle button
	local button_flow = mod_gui.get_button_flow(player)
	local button = button_flow.add{
		type = "button",
		name = "change-map-settings-toggle-config",
		style = mod_gui.button_style,
		tooltip = {"gui.change-map-settings-toggle-tooltip", {"gui.change-map-settings-toggle-config-caption"}},
		caption = {"gui.change-map-settings-toggle-config-caption"}
	}
	button.style.visible = true
	-- general gui frame setup --
	local frame_flow = mod_gui.get_frame_flow(player)
	local config_more_frame = frame_flow.add{
		type = "frame",
		caption = {"gui.change-map-settings-toggle-config-caption"},
		name = "change-map-settings-config-more-frame",
		direction = "vertical"
	}
	config_more_frame.style.visible = false
	
	local button_table = config_more_frame.add{
		type = "table",
		name = "change-map-settings-config-button-table",
		column_count = 2
	}
	button_table.add{
		type = "button",
		name = "change-map-settings-use-current-button",
		style = mod_gui.button_style,
		caption = {"gui.change-map-settings-use-current-button-caption"}
	}
	button_table.add{
		type = "button",
		name = "change-map-settings-default-button",
		style = mod_gui.button_style,
		caption = {"gui.change-map-settings-default-button-caption"}
	}
	--make gui sections
	gui.make_advanced_settings(config_more_frame)
	
	-- start button at the bottom
	local start_button = config_more_frame.add{
		type = "button",
		name = "change-map-settings-start-button",
		--style = mod_gui.button_style,
		tooltip = {"gui.change-map-settings-start-button-tooltip"},
		caption = {"gui.change-map-settings-start-button-caption"}
	}
	start_button.style.font_color = { r=1, g=0.75, b=0.22}
end

return gui