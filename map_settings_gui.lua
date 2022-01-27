local util = require("__ChangeMapSettings__/utilities")
local MOD_PREFIX = "change-map-settings-"
local GUI_PREFIX = "map-settings-"
local ENTIRE_PREFIX = MOD_PREFIX .. GUI_PREFIX
local map_settings_gui = {}

map_settings_gui.make_pollution_settings = function(parent, map_settings)
  local WIDGET_PREFIX = "pollution-"
  local flow = parent.add{
    type = "flow",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow",
    direction = "vertical"
  }
  flow.add{
    type = "label",
    caption = {"gui-map-generator.pollution"},
    style = "caption_label"
  }
  local table = flow.add{
    type = "table",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "table",
    column_count = 2,
    style = "bordered_table"
  }
  table.style.column_alignments[2] = "center"

  table.add{
    type = "label",
    caption = {"gui-map-generator.pollution"}
  }
  table.add{
    type = "checkbox",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox",
    state = map_settings.pollution.enabled,
  }
  table.children[1].style.horizontally_stretchable = true
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "dissipation", {"gui-map-generator.pollution-absorption-modifier"}, {"gui-map-generator.pollution-absorption-modifier-description"}, tostring(map_settings.pollution.ageing), 50)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "consumption", {"gui-map-generator.enemy-attack-pollution-consumption-modifier"}, {"gui-map-generator.enemy-attack-pollution-consumption-modifier-description"}, tostring(map_settings.pollution.enemy_attack_pollution_consumption_modifier), 50)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "tree-dmg", {"gui-map-generator.minimum-pollution-to-damage-trees"}, {"gui-map-generator.minimum-pollution-to-damage-trees-description"}, tostring(map_settings.pollution.min_pollution_to_damage_trees), 50)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "tree-absorb", {"gui-map-generator.pollution-absorbed-per-tree-damaged"}, {"gui-map-generator.pollution-absorbed-per-tree-damaged-description"}, tostring(map_settings.pollution.pollution_restored_per_tree_damage), 50)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "diffusion", {"gui." .. MOD_PREFIX .. "in-unit", {"gui-map-generator.pollution-diffusion-ratio"}, {"gui." .. MOD_PREFIX .. "percent"}}, {"gui-map-generator.pollution-diffusion-ratio-description"}, tostring(map_settings.pollution.diffusion_ratio * 100), 50)
end

map_settings_gui.make_evolution_settings = function(parent, map_settings)
  local WIDGET_PREFIX = "evolution-"
  local flow = parent.add{
    type = "flow",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow",
    direction = "vertical"
  }
  flow.add{
    type = "label",
    caption = {"gui-map-generator.evolution"},
    style = "caption_label"
  }
  local table = flow.add{
    type = "table",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "table",
    column_count = 2,
    style = "bordered_table"
  }
  table.style.column_alignments[2] = "center"

  table.add{
    type = "label",
    caption = {"gui-map-generator.evolution"}
  }
  table.add{
    type = "checkbox",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox",
    state = map_settings.enemy_evolution.enabled,
  }
  table.children[1].style.horizontally_stretchable = true
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "factor", {"gui-map-generator.evolution"}, {"gui." .. MOD_PREFIX .. "evolution-factor-tooltip"}, util.number_to_string(game.forces["enemy"].evolution_factor), 80)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "time", {"gui-map-generator.evolution-time-factor"}, {"gui-map-generator.evolution-time-factor-description"}, util.number_to_string(map_settings.enemy_evolution.time_factor * 100), 80)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "destroy", {"gui-map-generator.evolution-destroy-factor"}, {"gui-map-generator.evolution-destroy-factor-description"}, util.number_to_string(map_settings.enemy_evolution.destroy_factor * 100), 80)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "pollution", {"gui-map-generator.evolution-pollution-factor"}, {"gui-map-generator.evolution-pollution-factor-description"}, util.number_to_string(map_settings.enemy_evolution.pollution_factor * 100), 80)
end

map_settings_gui.make_expansion_settings = function(parent, map_settings)
  local WIDGET_PREFIX = "expansion-"
  local flow = parent.add{
    type = "flow",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow",
    direction = "vertical"
  }
  flow.add{
    type = "label",
    caption = {"gui-map-generator.enemy-expansion-group-tile"},
    style = "caption_label"
  }
  local table = flow.add{
    type = "table",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "table",
    column_count = 2,
    style = "bordered_table"
  }
  table.style.column_alignments[2] = "center"

  table.add{
    type = "label",
    caption = {"gui-map-generator.enemy-expansion-group-tile"}
  }
  table.add{
    type = "checkbox",
    name = ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox",
    state = map_settings.enemy_expansion.enabled,
  }
  table.children[1].style.horizontally_stretchable = true
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "distance", {"gui-map-generator.enemy-expansion-maximum-expansion-distance"}, {"gui-map-generator.enemy-expansion-maximum-expansion-distance-description"}, tostring(map_settings.enemy_expansion.max_expansion_distance), 30)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "min-size", {"gui-map-generator.enemy-expansion-minimum-expansion-group-size"}, {"gui-map-generator.enemy-expansion-minimum-expansion-group-size-description"}, tostring(map_settings.enemy_expansion.settler_group_min_size), 30)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "max-size", {"gui-map-generator.enemy-expansion-maximum-expansion-group-size"}, {"gui-map-generator.enemy-expansion-maximum-expansion-group-size-description"}, tostring(map_settings.enemy_expansion.settler_group_max_size), 30)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "min-cd", {"gui." .. MOD_PREFIX .. "in-unit", {"gui-map-generator.enemy-expansion-minimum-expansion-cooldown"}, {"gui." .. MOD_PREFIX .. "minutes"}}, {"gui-map-generator.enemy-expansion-minimum-expansion-cooldown-description"},  tostring(map_settings.enemy_expansion.min_expansion_cooldown / 3600), 30)
  map_settings_gui.make_config_option(table, WIDGET_PREFIX .. "max-cd", {"gui." .. MOD_PREFIX .. "in-unit", {"gui-map-generator.enemy-expansion-maximum-expansion-cooldown"}, {"gui." .. MOD_PREFIX .. "minutes"}}, {"gui-map-generator.enemy-expansion-maximum-expansion-cooldown-description"}, tostring(map_settings.enemy_expansion.max_expansion_cooldown / 3600), 30)
end

map_settings_gui.make_config_option = function(parent, name, caption, tooltip, default, max_width)
  parent.add{
    type = "label",
    caption = util.add_info_icon_to_string(caption),
    tooltip = tooltip
  }
  local child = parent.add{
    type = "textfield",
    name = ENTIRE_PREFIX .. name .. "-textfield",
    text = default,
    numeric = true,
    allow_decimal = true,
    allow_negative = false
  }
  if max_width then child.style.maximal_width = max_width end
  return child
end

map_settings_gui.expansion_reset_to_defaults = function(parent)
  local WIDGET_PREFIX = "expansion-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state = true
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "distance-textfield"].text = "7"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "min-size-textfield"].text = "5"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "max-size-textfield"].text = "20"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "min-cd-textfield"].text = "4"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "max-cd-textfield"].text = "60"
end

map_settings_gui.evolution_reset_to_defaults = function(parent)
  local WIDGET_PREFIX = "evolution-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state = true
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "factor-textfield"].text = "0"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "time-textfield"].text = "0.0004"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "destroy-textfield"].text = "0.2"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "pollution-textfield"].text = "0.000090"
end

map_settings_gui.pollution_reset_to_defaults = function(parent)
  local WIDGET_PREFIX = "pollution-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state = true
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "dissipation-textfield"].text = "1"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "consumption-textfield"].text = "1"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "tree-dmg-textfield"].text = "60"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "tree-absorb-textfield"].text = "10"
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "diffusion-textfield"].text = "2"
end

map_settings_gui.expansion_set_to_current = function(parent, map_settings)
  local WIDGET_PREFIX = "expansion-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state = map_settings.enemy_expansion.enabled
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "distance-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_distance)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "min-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_min_size)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "max-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_max_size)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "min-cd-textfield"].text = tostring(map_settings.enemy_expansion.min_expansion_cooldown / 3600)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "max-cd-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_cooldown / 3600)
end

map_settings_gui.evolution_set_to_current = function(parent, map_settings)
  local WIDGET_PREFIX = "evolution-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state = map_settings.enemy_evolution.enabled
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "factor-textfield"].text = util.number_to_string(game.forces["enemy"].evolution_factor)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "time-textfield"].text = util.number_to_string(map_settings.enemy_evolution.time_factor * 100)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "destroy-textfield"].text = util.number_to_string(map_settings.enemy_evolution.destroy_factor * 100)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "pollution-textfield"].text = util.number_to_string(map_settings.enemy_evolution.pollution_factor * 100)
end

map_settings_gui.pollution_set_to_current = function(parent, map_settings)
  local WIDGET_PREFIX = "pollution-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state = map_settings.pollution.enabled
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "dissipation-textfield"].text = tostring(map_settings.pollution.ageing)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "consumption-textfield"].text = tostring(map_settings.pollution.enemy_attack_pollution_consumption_modifier)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "tree-dmg-textfield"].text = tostring(map_settings.pollution.min_pollution_to_damage_trees)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "tree-absorb-textfield"].text = tostring(map_settings.pollution.pollution_restored_per_tree_damage)
  table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "diffusion-textfield"].text = tostring(map_settings.pollution.diffusion_ratio * 100)
end

-- can throw!
map_settings_gui.expansion_read = function(parent)
  local WIDGET_PREFIX = "expansion-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  local enemy_expansion = {}

  enemy_expansion.enabled = table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state
  enemy_expansion.max_expansion_distance = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "distance-textfield"]),
                                                             2, 20,
                                                             {"msg." .. MOD_PREFIX .. "invalid-expansion-distance"})
  enemy_expansion.settler_group_min_size = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "min-size-textfield"]),
                                                             1, 20,
                                                             {"msg." .. MOD_PREFIX .. "invalid-expansion-min-size"})
  enemy_expansion.settler_group_max_size = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "max-size-textfield"]),
                                                             math.max(enemy_expansion.settler_group_min_size, 1), 50,
                                                             {"msg." .. MOD_PREFIX .. "invalid-expansion-max-size"})
  enemy_expansion.min_expansion_cooldown = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "min-cd-textfield"]),
                                                             1, 60,
                                                             {"msg." .. MOD_PREFIX .. "invalid-expansion-min-cd"}) * 3600
  enemy_expansion.max_expansion_cooldown = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "max-cd-textfield"]),
                                                             math.max(enemy_expansion.min_expansion_cooldown / 3600, 5), 180,
                                                             {"msg." .. MOD_PREFIX .. "invalid-expansion-max-cd"}) * 3600
  return enemy_expansion
end

-- can throw!
map_settings_gui.evolution_read = function(parent)
  local WIDGET_PREFIX = "evolution-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  local enemy_evolution = {}

  enemy_evolution.enabled = table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state
  enemy_evolution.evolution_factor = util.check_bounds(util.textfield_to_number(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "factor-textfield"]),
                                                            0, 1,
                                                            {"msg." .. MOD_PREFIX .. "invalid-evolution-factor"})
  enemy_evolution.time_factor = util.check_bounds(util.textfield_to_number(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "time-textfield"]),
                                                  0, 0.01,
                                                  {"msg." .. MOD_PREFIX .. "invalid-evolution-time"}) / 100
  enemy_evolution.destroy_factor = util.check_bounds(util.textfield_to_number(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "destroy-textfield"]),
                                                     0, 1,
                                                     {"msg." .. MOD_PREFIX .. "invalid-evolution-destroy"}) / 100
  enemy_evolution.pollution_factor = util.check_bounds(util.textfield_to_number(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "pollution-textfield"]),
                                                       0, 0.01,
                                                       {"msg." .. MOD_PREFIX .. "invalid-evolution-pollution"}) / 100
  return enemy_evolution
end

-- can throw!
map_settings_gui.pollution_read = function(parent)
  local WIDGET_PREFIX = "pollution-"
  local table = parent[ENTIRE_PREFIX .. WIDGET_PREFIX .. "flow"][ENTIRE_PREFIX .. WIDGET_PREFIX .. "table"]
  local pollution = {}

  pollution.enabled = table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "checkbox"].state
  pollution.ageing = util.check_bounds(util.textfield_to_number(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "dissipation-textfield"]),
                                       0.1, 4,
                                       {"msg." .. MOD_PREFIX .. "invalid-pollution-absorption"})
  pollution.enemy_attack_pollution_consumption_modifier = util.check_bounds(util.textfield_to_number(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "consumption-textfield"]),
                                                                            0.1, 4,
                                                                            {"msg." .. MOD_PREFIX .. "invalid-enemy-attack-pollution-consumption"})
  pollution.min_pollution_to_damage_trees = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "tree-dmg-textfield"]),
                                                              0, 9999,
                                                              {"msg." .. MOD_PREFIX .. "invalid-pollution-tree-dmg"})
  pollution.pollution_restored_per_tree_damage = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "tree-absorb-textfield"]),
                                                                   0, 9999,
                                                                   {"msg." .. MOD_PREFIX .. "invalid-pollution-tree-absorb"})
  pollution.diffusion_ratio = util.check_bounds(util.textfield_to_uint(table[ENTIRE_PREFIX .. WIDGET_PREFIX .. "diffusion-textfield"]),
                                                0, 25,
                                                {"msg." .. MOD_PREFIX .. "invalid-pollution-diffusion"}) / 100
  return pollution
end

return map_settings_gui
