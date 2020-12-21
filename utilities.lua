local util = {}
local tableutil = require("util").table

util.textfield_to_uint = function(textfield)
  local number = util.textfield_to_number(textfield)
  if number and (number >= 0) and (number <= 4294967295) and (math.floor(number) == number) then
    return number
  end
  return false
end

util.textfield_to_number = function(textfield)
  local number = tonumber(textfield.text)
  if textfield.text and number then
    return number
  elseif textfield.text and textfield.text == "inf" then
    return 1/0
  elseif textfield.text and textfield.text == "-inf" then
    return -(1/0)
  end
  return false
end

util.textfield_to_number_with_error = function(textfield)
  local number = util.textfield_to_number(textfield)
  if not number then
    error(textfield.name .. " must be a number.")
  end
  return number
end

util.number_to_string = function(number) -- shows up to 6 decimal places
  if number == math.huge then
    return "inf"
  elseif number == -math.huge then
    return "-inf"
  elseif number < 0.0001 then
    return string.format("%.6f", tostring(number))
  elseif number > 999 then
    if number > 99999 then
      return string.format("%.f", tostring(number))
    end
    return string.format("%.3f", tostring(number))
  end
  return tostring(math.floor(number * 1000000 + 0.5) / 1000000) -- 0.5 for "rounding"
end

util.check_bounds = function(input, min, max, err)
  if input and (input >= min) and (input <= max) then
    return input
  end
  error(err)
  return false
end

-- returns table = {["intended-property"] = {name = "expression-name", order = "order"}, ...}
util.get_relevant_noise_expressions = function()
  local expressions = {}
  for name, named_noise_expression in pairs(game.named_noise_expressions) do
    local intended_property = named_noise_expression.intended_property
    if intended_property ~= "" then
      expressions[intended_property] = expressions[intended_property] or {}
      table.insert(expressions[intended_property], {name = name, order = named_noise_expression.order})
    end
  end
  return expressions
end

util.add_info_icon_to_string = function(string)
  return {"", string, " [img=info]"}
end

util.get_possible_noise_expression_properties = function()
  return { "elevation", "temperature", "moisture", "aux", "starting-lake-noise-amplitude"}
end

util.compare_localized_strings = function(string1, string2)
  if type(string1) == "string" then
    string1 = {"", string1}
  end
  if type(string2) == "string" then
    string2 = {"", string2}
  end
  return tableutil.compare(string1, string2)
end

util.size_to_number = function(size)
  local t = tonumber(size)
  if t ~= nil then
    return t
  end
  -- source: https://wiki.factorio.com/Types/MapGenSize
  local s = size:lower()
  if s == "none" then
    return 0
  end
  if s == "very-low" or s == "very-small" or s == "very-poor" then
    return 0.5
  end
  if s == "low" or s == "small" or s == "poor" then
    return 0.70710678118
  end
  if s == "normal" or s == "medium" or s == "regular" then
    return 1
  end
  if s == "high" or s == "big" or s == "good" then
    return 1.41421356237
  end
  if s == "very-high" or s == "very-big" or s == "very-good" then
    return 2
  end
end

-- Used to generate MapGenSettings from a MapGenPreset
-- A MapGenPreset stores essentiall the diff to the default settings
util.get_map_gen_settings_from_preset = function(preset)
  local map_gen_settings = {}
  local property_expression_names_mine = {}
  local autoplace_controls_mine = {}
  local autoplace_settings_mine = {}
  local cliff_settings_mine = {}

  -- general settings
  map_gen_settings.peaceful_mode = util.get_val_or_default(false, preset, "basic_settings", "peaceful_mode")

  map_gen_settings.starting_points = util.get_val_or_default({x=0, y=0}, preset, "basic_settings", "starting_points")
  map_gen_settings.width = util.get_val_or_default(0, preset, "basic_settings", "width")
  map_gen_settings.height = util.get_val_or_default(0, preset, "basic_settings", "height")
  map_gen_settings.seed = util.get_val_or_default(0, preset, "basic_settings", "seed")
  map_gen_settings.default_enable_all_autoplace_controls = util.get_val_or_default(true, preset, "basic_settings", "default_enable_all_autoplace_controls")

  -- water stuff
  map_gen_settings.terrain_segmentation = util.get_val_or_default(1, preset, "basic_settings", "terrain_segmentation")
  map_gen_settings.water = util.get_val_or_default(1, preset, "basic_settings", "water")

  -- starting area
  map_gen_settings.starting_area = util.size_to_number(util.get_val_or_default(1, preset, "basic_settings", "starting_area"))

  -- resources and terrain and enemies
  local autoplace_control_prototypes = game.autoplace_control_prototypes
  local my_autoplace_controls = {}
  for name, control in pairs(util.get_val_or_default({}, preset, "basic_settings", "autoplace_controls")) do
    control.frequency = util.size_to_number(util.get_val_or_default(1, control.frequency))
    control.size = util.size_to_number(util.get_val_or_default(1, control.size))
    control.richness = util.size_to_number(util.get_val_or_default(1, control.richness))
    my_autoplace_controls[name] = control
  end
  for _, control in pairs(autoplace_control_prototypes) do
    if my_autoplace_controls[control.name] ~= nil then
      autoplace_controls_mine[control.name] = my_autoplace_controls[control.name]
      -- continue
    else
      if control.category == "resource" then
        autoplace_controls_mine[control.name] = {
          frequency = 1,
          size = 1,
          richness = 1
        }
      elseif control.category == "terrain" and control.name ~= "planet-size" then -- planet size is a space exploration thing, we don't want the player to change it
        autoplace_controls_mine[control.name] = {
          frequency = 1,
          size = 1
        }
      elseif control.category == "enemy" then
        autoplace_controls_mine[control.name] = {
          frequency = 1,
          size = 1
        }
      end
    end
  end

  -- autoplace settings
  autoplace_settings_mine = util.get_val_or_default({}, preset, "basic_settings", "autoplace_settings")

  property_expression_names_mine = util.get_val_or_default({}, preset, "basic_settings", "property_expression_names")
  -- moisture and terrain type
  property_expression_names_mine["control-setting:moisture:frequency:multiplier"] = util.get_val_or_default(1, property_expression_names_mine["control-setting:moisture:frequency:multiplier"])
  property_expression_names_mine["control-setting:moisture:bias"] = tostring(util.get_val_or_default("0", property_expression_names_mine["control-setting:moisture:bias"]))
  property_expression_names_mine["control-setting:aux:frequency:multiplier"] = util.get_val_or_default(1, property_expression_names_mine["control-setting:aux:frequency:multiplier"])
  property_expression_names_mine["control-setting:aux:bias"] = tostring(util.get_val_or_default("0", property_expression_names_mine["control-setting:aux:bias"]))

  -- cliffs
  cliff_settings_mine.name = util.get_val_or_default("cliff", preset, "basic_settings", "cliff_settings", "name")
  cliff_settings_mine.cliff_elevation_interval = util.get_val_or_default(40, preset, "basic_settings", "cliff_settings", "cliff_elevation_interval")
  cliff_settings_mine.richness = util.get_val_or_default(1, preset, "basic_settings", "cliff_settings", "richness")
  cliff_settings_mine.cliff_elevation_0 = util.get_val_or_default(10, preset, "basic_settings", "cliff_settings", "cliff_elevation_0")
  map_gen_settings.cliff_settings = cliff_settings_mine

  map_gen_settings.autoplace_controls = autoplace_controls_mine
  map_gen_settings.autoplace_settings = autoplace_settings_mine
  map_gen_settings.property_expression_names = property_expression_names_mine
  return map_gen_settings
end

-- Used to generate MapSettings from a MapGenPreset
-- A MapGenPreset stores essentiall the diff to the default settings
util.get_map_settings_from_preset = function(preset)
  local map_settings = {}

  map_settings.peaceful_mode = util.get_val_or_default(false, preset, "basic_settings", "peaceful_mode")
  
  map_settings.enemy_expansion = {}
  map_settings.enemy_expansion.enabled = util.get_val_or_default(true, preset, "advanced_settings", "enemy_expansion", "enabled")
  map_settings.enemy_expansion.max_expansion_distance = util.get_val_or_default(7, preset, "advanced_settings", "enemy_expansion", "max_expansion_distance")
  map_settings.enemy_expansion.settler_group_min_size = util.get_val_or_default(5, preset, "advanced_settings", "enemy_expansion", "settler_group_min_size")
  map_settings.enemy_expansion.settler_group_max_size = util.get_val_or_default(20, preset, "advanced_settings", "enemy_expansion", "settler_group_max_size")
  map_settings.enemy_expansion.min_expansion_cooldown = util.get_val_or_default(4 * 3600, preset, "advanced_settings", "enemy_expansion", "min_expansion_cooldown")
  map_settings.enemy_expansion.max_expansion_cooldown = util.get_val_or_default(60 * 3600, preset, "advanced_settings", "enemy_expansion", "max_expansion_cooldown")

  map_settings.enemy_evolution = {}
  map_settings.enemy_evolution.enabled = util.get_val_or_default(true, preset, "advanced_settings", "enemy_evolution", "enabled")
  map_settings.enemy_evolution.evolution_factor = 0
  map_settings.enemy_evolution.time_factor = util.get_val_or_default(0.0004 / 100, preset, "advanced_settings", "enemy_evolution", "time_factor")
  map_settings.enemy_evolution.destroy_factor = util.get_val_or_default(0.2 / 100, preset, "advanced_settings", "enemy_evolution", "destroy_factor")
  map_settings.enemy_evolution.pollution_factor = util.get_val_or_default(0.000090 / 100, preset, "advanced_settings", "enemy_evolution", "pollution_factor")

  map_settings.pollution = {}
  map_settings.pollution.enabled = util.get_val_or_default(true, preset, "advanced_settings", "pollution", "enabled")
  map_settings.pollution.ageing = util.get_val_or_default(1, preset, "advanced_settings", "pollution", "diffusion_ratio")
  map_settings.pollution.enemy_attack_pollution_consumption_modifier = util.get_val_or_default(1, preset, "advanced_settings", "pollution", "ageing")
  map_settings.pollution.min_pollution_to_damage_trees = util.get_val_or_default(60, preset, "advanced_settings", "pollution", "enemy_attack_pollution_consumption_modifier")
  map_settings.pollution.pollution_restored_per_tree_damage = util.get_val_or_default(10, preset, "advanced_settings", "pollution", "min_pollution_to_damage_trees")
  map_settings.pollution.diffusion_ratio = util.get_val_or_default(2 / 100, preset, "advanced_settings", "pollution", "pollution_restored_per_tree_damage")
  
  return map_settings
end

util.get_val_or_default = function(default, root, component1, component2, component3)
  if root == nil then
    return default
  end
  if component1 == nil then
    return root
  end
  if root[component1] == nil then
    return default
  end
  if component2 == nil then
    return root[component1]
  end
  if root[component1][component2] == nil then
    return default
  end
  if component3 == nil then
    return root[component1][component2]
  end
  if root[component1][component2][component3] == nil then
    return default
  end
  return root[component1][component2][component3]
end

return util
