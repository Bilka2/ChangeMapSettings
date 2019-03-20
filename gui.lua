local mod_gui = require("mod-gui")
local util = require("utilities")
local map_gen_gui = require("map_gen_settings_gui")
local gui = {}

-- GUI --
function gui.regen(player)
  gui.kill(player)
  --toggle button
  local button_flow = mod_gui.get_button_flow(player)
  local button = button_flow.add{
    type = "button",
    name = "change-map-settings-toggle-config",
    style = mod_gui.button_style,
    tooltip = {"gui.change-map-settings-toggle-tooltip", {"gui.change-map-settings-title"}},
    caption = {"gui.change-map-settings-toggle-config-caption"}
  }
  button.visible = true
  -- general gui frame setup --
  local frame_flow = mod_gui.get_frame_flow(player)
  local main_flow = frame_flow.add{
    type = "flow",
    name = "change-map-settings-main-flow",
    direction = "horizontal"
  }
  main_flow.visible = false
  local config_frame = main_flow.add{
    type = "frame",
    caption = {"gui.change-map-settings-title"},
    name = "change-map-settings-config-frame",
    direction = "vertical"
  }
  local config_scroll_pane = config_frame.add{
    type = "scroll-pane",
    name = "change-map-settings-config-scroll-pane",
  }
  config_scroll_pane.style.maximal_height = 700
  
  local notice = config_scroll_pane.add{
    type = "label",
    caption = "NOTE:\nThe 0.17 version of this mod is missing configuration options because those are missing from the lua api. Furthermore, frequency of water, trees and cliffs is inverted compared to the base game map generation screen. This is also an issue with the lua api.\nThe mod will remain in this state until the lua api is changed to properly expose everything."
  }
  notice.style.single_line = false
  notice.style.maximal_width = 400
  notice.style.font_color = {r=1, g= 0.1}
  notice.style.font = "default-bold"
  notice.style.bottom_padding = 5
  
  local button_table = config_scroll_pane.add{
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
  gui.make_advanced_settings(config_scroll_pane, player.surface)
  
  -- start button at the bottom
  local start_button_flow = config_frame.add{
    type = "flow",
    direction = "horizontal"
  }
  local start_button_pusher = start_button_flow.add{
    type = "flow",
    direction = "horizontal"
  }
  start_button_pusher.style.horizontally_stretchable = true
  start_button_flow.add{
    type = "button",
    name = "change-map-settings-start-button",
    tooltip = {"gui.change-map-settings-start-button-tooltip"},
    caption = {"gui.change-map-settings-start-button-caption", {"gui.change-map-settings-title"}},
    style = "confirm_button"
  }
  
  -- map gen settings
  local map_gen_frame = main_flow.add{
    type = "frame",
    caption = {"gui.change-map-settings-map-gen-title"},
    name = "change-map-settings-map-gen-frame",
    direction = "vertical"
  }  
  local map_gen_button_table = map_gen_frame.add{
    type = "table",
    name = "change-map-settings-map-gen-button-table",
    column_count = 2
  }
  map_gen_button_table.add{
    type = "button",
    name = "change-map-settings-use-current-map-gen-button",
    style = mod_gui.button_style,
    caption = {"gui.change-map-settings-use-current-button-caption"}
  }
  map_gen_button_table.add{
    type = "button",
    name = "change-map-settings-default-map-gen-button",
    style = mod_gui.button_style,
    caption = {"gui.change-map-settings-default-button-caption"}
  }
  
  --seed
  local seed_table = map_gen_frame.add{
    type = "table",
    name = "change-map-settings-seed-table",
    column_count = 2
  }
  seed_table.add{
    type = "label",
    caption = {"gui.change-map-settings-seed-caption"}
  }
  seed_table.add{
    type = "textfield",
    name = "change-map-settings-seed-textfield",
    text = "0"
  }
  
  -- rest of map gen settings
  map_gen_gui.create(map_gen_frame)
  
  -- start button at the bottom
  local start_button_flow_2 = map_gen_frame.add{
    type = "flow",
    direction = "horizontal"
  }
  local start_button_pusher_2 = start_button_flow_2.add{
    type = "flow",
    direction = "horizontal"
  }
  start_button_pusher_2.style.horizontally_stretchable = true
  start_button_flow_2.add{
    type = "button",  
    name = "change-map-settings-start-map-gen-button",
    tooltip = {"gui.change-map-settings-start-map-gen-button-tooltip"},
    caption = {"gui.change-map-settings-start-button-caption", {"gui.change-map-settings-map-gen-title"}},
    style = "confirm_button"
  }
end

gui.make_advanced_settings = function(parent, surface)
  local config_table = parent.add{
    type = "table",
    name = "change-map-settings-config-table",
    column_count = 2
  }
  config_table.style.horizontal_spacing = 20
  
  local map_settings = game.map_settings
  --make different advanced option groups
  gui.make_pollution_settings(config_table, map_settings)
  gui.make_expansion_settings(config_table, map_settings)
  gui.make_evolution_settings(config_table, map_settings)
  gui.make_general_settings(config_table, surface)
end

gui.make_pollution_settings = function(parent, map_settings)
  local config_more_option_pollution_flow = parent.add{
    type = "flow",
    name = "change-map-settings-config-more-pollution-flow",
    direction = "vertical"
  }
  config_more_option_pollution_flow.add{
    type = "label",
    caption = {"gui-map-generator.pollution"},
    style = "caption_label"
  }
  local config_more_option_pollution_table = config_more_option_pollution_flow.add{
    type = "table",
    name = "change-map-settings-config-more-pollution-table",
    column_count = 2
  }
  
  config_more_option_pollution_table.add{
    type = "label",
    caption = {"gui-map-generator.pollution"}
  }
  config_more_option_pollution_table.add{
    type = "checkbox",
    name = "change-map-settings-pollution-checkbox",
    state = map_settings.pollution.enabled,
  }
  gui.make_config_option(config_more_option_pollution_table, "pollution-dissipation", {"gui-map-generator.pollution-absorption-modifier"}, {"gui-map-generator.pollution-absorption-modifier-description"}, tostring(map_settings.pollution.ageing), 50)
  gui.make_config_option(config_more_option_pollution_table, "enemy-attack-pollution-consumption", {"gui-map-generator.enemy-attack-pollution-consumption-modifier"}, {"gui-map-generator.enemy-attack-pollution-consumption-modifier-description"}, tostring(map_settings.pollution.enemy_attack_pollution_consumption_modifier), 50)
  gui.make_config_option(config_more_option_pollution_table, "pollution-tree-dmg", {"gui-map-generator.minimum-pollution-to-damage-trees"}, {"gui-map-generator.minimum-pollution-to-damage-trees-description"}, tostring(map_settings.pollution.min_pollution_to_damage_trees), 50)
  gui.make_config_option(config_more_option_pollution_table, "pollution-tree-absorb", {"gui-map-generator.pollution-absorbed-per-tree-damaged"}, {"gui-map-generator.pollution-absorbed-per-tree-damaged-description"}, tostring(map_settings.pollution.pollution_restored_per_tree_damage), 50)
  gui.make_config_option(config_more_option_pollution_table, "pollution-diffusion", {"gui.change-map-settings-in-unit", {"gui-map-generator.pollution-diffusion-ratio"}, {"gui.change-map-settings-percent"}}, {"gui-map-generator.pollution-diffusion-ratio-description"}, tostring(map_settings.pollution.diffusion_ratio * 100), 50)
end

gui.make_evolution_settings = function(parent, map_settings)
  local config_more_option_evo_flow = parent.add{
    type = "flow",
    name = "change-map-settings-config-more-evo-flow",
    direction = "vertical"
  }
  config_more_option_evo_flow.add{
    type = "label",
    caption = {"gui-map-generator.evolution"},
    style = "caption_label"
  }
  local config_more_option_evo_table = config_more_option_evo_flow.add{
    type = "table",
    name = "change-map-settings-config-more-evo-table",
    column_count = 2
  }
  
  config_more_option_evo_table.add{
    type = "label",
    caption = {"gui-map-generator.evolution"}
  }
  config_more_option_evo_table.add{
    type = "checkbox",
    name = "change-map-settings-evolution-checkbox",
    state = map_settings.enemy_evolution.enabled,
  }
  gui.make_config_option(config_more_option_evo_table, "evolution-factor", {"gui-map-generator.evolution"}, {"gui.change-map-settings-evolution-factor-tooltip"}, util.float_to_string(game.forces["enemy"].evolution_factor), 80)
  gui.make_config_option(config_more_option_evo_table, "evolution-time", {"gui-map-generator.evolution-time-factor"}, {"gui-map-generator.evolution-time-factor-description"}, util.float_to_string(map_settings.enemy_evolution.time_factor * 100), 80)
  gui.make_config_option(config_more_option_evo_table, "evolution-destroy", {"gui-map-generator.evolution-destroy-factor"}, {"gui-map-generator.evolution-destroy-factor-description"}, util.float_to_string(map_settings.enemy_evolution.destroy_factor * 100), 80)
  gui.make_config_option(config_more_option_evo_table, "evolution-pollution", {"gui-map-generator.evolution-pollution-factor"}, {"gui-map-generator.evolution-pollution-factor-description"}, util.float_to_string(map_settings.enemy_evolution.pollution_factor * 100), 80)
end

gui.make_expansion_settings = function(parent, map_settings)
  local config_more_option_expansion_flow = parent.add{
    type = "flow",
    name = "change-map-settings-config-more-expansion-flow",
    direction = "vertical"
  }
  config_more_option_expansion_flow.add{
    type = "label",
    caption = {"gui-map-generator.enemy-expansion-group-tile"},
    style = "caption_label"
  }
  local config_more_option_expansion_table = config_more_option_expansion_flow.add{
    type = "table",
    name = "change-map-settings-config-more-expansion-table",
    column_count = 2
  }
  
  config_more_option_expansion_table.add{
    type = "label",
    caption = {"gui-map-generator.enemy-expansion-group-tile"}
  }
  config_more_option_expansion_table.add{
    type = "checkbox",
    name = "change-map-settings-enemy-expansion-checkbox",
    state = map_settings.enemy_expansion.enabled,
  }
  gui.make_config_option(config_more_option_expansion_table, "expansion-distance", {"gui-map-generator.enemy-expansion-maximum-expansion-distance"}, {"gui-map-generator.enemy-expansion-maximum-expansion-distance-description"}, tostring(map_settings.enemy_expansion.max_expansion_distance), 30)
  gui.make_config_option(config_more_option_expansion_table, "expansion-min-size", {"gui-map-generator.enemy-expansion-minimum-expansion-group-size"}, {"gui-map-generator.enemy-expansion-minimum-expansion-group-size-description"}, tostring(map_settings.enemy_expansion.settler_group_min_size), 30)
  gui.make_config_option(config_more_option_expansion_table, "expansion-max-size", {"gui-map-generator.enemy-expansion-maximum-expansion-group-size"}, {"gui-map-generator.enemy-expansion-maximum-expansion-group-size-description"}, tostring(map_settings.enemy_expansion.settler_group_max_size), 30)
  gui.make_config_option(config_more_option_expansion_table, "expansion-min-cd", {"gui.change-map-settings-in-unit", {"gui-map-generator.enemy-expansion-minimum-expansion-cooldown"}, {"gui.change-map-settings-minutes"}}, {"gui-map-generator.enemy-expansion-minimum-expansion-cooldown-description"},  tostring(map_settings.enemy_expansion.min_expansion_cooldown / 3600), 30)
  gui.make_config_option(config_more_option_expansion_table, "expansion-max-cd", {"gui.change-map-settings-in-unit", {"gui-map-generator.enemy-expansion-maximum-expansion-cooldown"}, {"gui.change-map-settings-minutes"}}, {"gui-map-generator.enemy-expansion-maximum-expansion-cooldown-description"}, tostring(map_settings.enemy_expansion.max_expansion_cooldown / 3600), 30)
end

gui.make_general_settings = function(parent, surface)
  local config_more_option_general_flow = parent.add{
    type = "flow",
    name = "change-map-settings-config-more-general-flow",
    direction = "vertical"
  }
  config_more_option_general_flow.add{
    type = "label",
    caption = {"gui.change-map-settings-general-title"},
    style = "caption_label"
  }
  local config_more_option_general_table = config_more_option_general_flow.add{
    type = "table",
    name = "change-map-settings-config-more-general-table",
    column_count = 2
  }
  
  config_more_option_general_table.add{
    type = "label",
    caption = {"gui-map-generator.peaceful-mode-checkbox"}
  }
  config_more_option_general_table.add{
    type = "checkbox",
    name = "change-map-settings-peaceful-checkbox",
    state = surface.peaceful_mode,
  }
end

gui.make_config_option = function(parent, name, caption, tooltip, default, max_width)
  parent.add{
    type = "label",
    caption = caption,
    tooltip = tooltip
  }
  local child = parent.add{
    type = "textfield",
    name = "change-map-settings-" .. name .. "-textfield",
  }
  child.text = default
  if max_width then child.style.maximal_width = max_width end
  return child
end

gui.kill = function(player)
  local button_flow = mod_gui.get_button_flow(player)
  local frame_flow = mod_gui.get_frame_flow(player)    
  if button_flow["change-map-settings-toggle-config"] then
    button_flow["change-map-settings-toggle-config"].destroy()
  end
  if frame_flow["change-map-settings-main-flow"] then
    frame_flow["change-map-settings-main-flow"].destroy()
  end
  
  --migration from 2.0.0
  if frame_flow["change-map-settings-config-more-frame"] then
		frame_flow["change-map-settings-config-more-frame"].destroy()
	end
end

return gui
