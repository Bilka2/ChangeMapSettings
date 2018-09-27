local mod_gui = require("mod-gui")
local gui = require("gui")
local util = require("utilities")

local function reset_to_default(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local config_table = frame_flow["change-map-settings-main-flow"]["change-map-settings-config-frame"]["change-map-settings-config-table"]
  --General
  local general_table = config_table["change-map-settings-config-more-general-flow"]["change-map-settings-config-more-general-table"]
  general_table["change-map-settings-peaceful-checkbox"].state = false
  -- MAP SETTINGS --
  --Evolution
  local evo_table = config_table["change-map-settings-config-more-evo-flow"]["change-map-settings-config-more-evo-table"]
  evo_table["change-map-settings-evolution-checkbox"].state = true
  evo_table["change-map-settings-evolution-factor-textfield"].text = "0"
  evo_table["change-map-settings-evolution-time-textfield"].text = "0.000004"
  evo_table["change-map-settings-evolution-destroy-textfield"].text = "0.002000"
  evo_table["change-map-settings-evolution-pollution-textfield"].text = "0.000015"
  --Pollution
  local pollution_table = config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
  pollution_table["change-map-settings-pollution-checkbox"].state = true
  pollution_table["change-map-settings-pollution-diffusion-textfield"].text = "2"
  pollution_table["change-map-settings-pollution-dissipation-textfield"].text = "1"
  pollution_table["change-map-settings-pollution-tree-dmg-textfield"].text = "3500"
  pollution_table["change-map-settings-pollution-tree-absorb-textfield"].text = "500"
  --Enemy expansion
  local expansion_table = config_table["change-map-settings-config-more-expansion-flow"]["change-map-settings-config-more-expansion-table"]
  expansion_table["change-map-settings-enemy-expansion-checkbox"].state = true
  expansion_table["change-map-settings-expansion-distance-textfield"].text = "7"
  expansion_table["change-map-settings-expansion-min-size-textfield"].text = "5"
  expansion_table["change-map-settings-expansion-max-size-textfield"].text = "20"
  expansion_table["change-map-settings-expansion-min-cd-textfield"].text = "4"
  expansion_table["change-map-settings-expansion-max-cd-textfield"].text = "60"
end

local function set_to_current_map_gen_settings(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local surface = player.surface
  local map_gen_settings = surface.map_gen_settings
  -- general options --
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]
  
  map_gen_frame["change-map-settings-seed-table"]["change-map-settings-seed-textfield"].text = tostring(map_gen_settings.seed)

  -- MAP GEN SETTINGS --
  -- resource table --
  local resource_table = map_gen_frame["change-map-settings-resource-scroll-pane"]["change-map-settings-resource-table"]
  local terrain_table = map_gen_frame["change-map-settings-resource-scroll-pane"]["change-map-settings-terrain-table"]
  local resources = util.get_table_of_resources()
  local lookup = {
    ["none"] = 1,
    ["very-low"] = 2,
    ["low"] = 3,
    ["normal"] = 4,
    ["high"] = 5,
    ["very-high"] = 6
  }
  --water stuff
  terrain_table["change-map-settings-map-gen-water-freq"].selected_index = lookup[map_gen_settings.terrain_segmentation]
  terrain_table["change-map-settings-map-gen-water-size"].selected_index = lookup[map_gen_settings.water]
  --starting area
  terrain_table["change-map-settings-map-gen-starting-area-size"].selected_index = lookup[map_gen_settings.starting_area]
  -- resources and terrain
  local autoplace_controls = map_gen_settings.autoplace_controls
  local valid_autoplace_controls = game.autoplace_control_prototypes
  for name, autoplace_control in pairs(autoplace_controls) do
    if valid_autoplace_controls[name] then 
      if resources[name] then
        resource_table["change-map-settings-map-gen-" .. name .. "-freq"].selected_index = lookup[autoplace_control["frequency"]]
        resource_table["change-map-settings-map-gen-" .. name .. "-size"].selected_index = lookup[autoplace_control["size"]]
        resource_table["change-map-settings-map-gen-" .. name .. "-richn"].selected_index = lookup[autoplace_control["richness"]]
      else
        terrain_table["change-map-settings-map-gen-" .. name .. "-freq"].selected_index = lookup[autoplace_control["frequency"]]
        terrain_table["change-map-settings-map-gen-" .. name .. "-size"].selected_index = lookup[autoplace_control["size"]]
        if terrain_table["change-map-settings-map-gen-" .. name .. "-richn"] then
          terrain_table["change-map-settings-map-gen-" .. name .. "-richn"].selected_index = lookup[autoplace_control["richness"]]
        end
      end
    end
  end
  
  local cliff_freq_index_lookup = {
    [40] = 1,
    [20] = 2,
    [10] = 3,
    [5] = 4,
    [2.5] = 5
  }
  local cliff_size_index_lookup = {
    [1024] = 1,
    [40] = 2,
    [20] = 3,
    [10] = 4,
    [5] = 5,
    [2.5] = 6
  }
  local cliff_settings = map_gen_settings.cliff_settings
  terrain_table["change-map-settings-map-gen-cliffs-freq"].selected_index = cliff_freq_index_lookup[math.floor(cliff_settings.cliff_elevation_interval*10)/10] --floor to 1 digit after the decimal point -> 2.55 => 2.5
  terrain_table["change-map-settings-map-gen-cliffs-size"].selected_index = cliff_size_index_lookup[math.floor(cliff_settings.cliff_elevation_0*10)/10]
end

local function set_to_current_map_settings(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local config_table = frame_flow["change-map-settings-main-flow"]["change-map-settings-config-frame"]["change-map-settings-config-table"]
  --General
  local general_table = config_table["change-map-settings-config-more-general-flow"]["change-map-settings-config-more-general-table"]
  general_table["change-map-settings-peaceful-checkbox"].state = player.surface.peaceful_mode
  -- MAP SETTINGS --
  local map_settings = game.map_settings
  --Evolution
  local evo_table = config_table["change-map-settings-config-more-evo-flow"]["change-map-settings-config-more-evo-table"]
  evo_table["change-map-settings-evolution-checkbox"].state = map_settings.enemy_evolution.enabled
  evo_table["change-map-settings-evolution-factor-textfield"].text = util.float_to_string(game.forces["enemy"].evolution_factor)
  evo_table["change-map-settings-evolution-time-textfield"].text = util.float_to_string(map_settings.enemy_evolution.time_factor)
  evo_table["change-map-settings-evolution-destroy-textfield"].text = util.float_to_string(map_settings.enemy_evolution.destroy_factor)
  evo_table["change-map-settings-evolution-pollution-textfield"].text = util.float_to_string(map_settings.enemy_evolution.pollution_factor)
  --Pollution
  local pollution_table = config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
  pollution_table["change-map-settings-pollution-checkbox"].state = map_settings.pollution.enabled
  pollution_table["change-map-settings-pollution-diffusion-textfield"].text = tostring(map_settings.pollution.diffusion_ratio * 100)
  pollution_table["change-map-settings-pollution-dissipation-textfield"].text = tostring(map_settings.pollution.ageing)
  pollution_table["change-map-settings-pollution-tree-dmg-textfield"].text = tostring(map_settings.pollution.min_pollution_to_damage_trees)
  pollution_table["change-map-settings-pollution-tree-absorb-textfield"].text = tostring(map_settings.pollution.pollution_restored_per_tree_damage)
  --Enemy expansion
  local expansion_table = config_table["change-map-settings-config-more-expansion-flow"]["change-map-settings-config-more-expansion-table"]
  expansion_table["change-map-settings-enemy-expansion-checkbox"].state = map_settings.enemy_expansion.enabled
  expansion_table["change-map-settings-expansion-distance-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_distance)
  expansion_table["change-map-settings-expansion-min-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_min_size)
  expansion_table["change-map-settings-expansion-max-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_max_size)
  expansion_table["change-map-settings-expansion-min-cd-textfield"].text = tostring(map_settings.enemy_expansion.min_expansion_cooldown / 3600)
  expansion_table["change-map-settings-expansion-max-cd-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_cooldown / 3600)
end

local function change_map_settings(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local config_table = frame_flow["change-map-settings-main-flow"]["change-map-settings-config-frame"]["change-map-settings-config-table"]
  
  -- Reading everything out
  local general_table = config_table["change-map-settings-config-more-general-flow"]["change-map-settings-config-more-general-table"]
  local peaceful_mode = general_table["change-map-settings-peaceful-checkbox"].state
  local map_settings = game.map_settings
  -- Evolution
  local evo_table = config_table["change-map-settings-config-more-evo-flow"]["change-map-settings-config-more-evo-table"]
  local evolution_enabled = evo_table["change-map-settings-evolution-checkbox"].state
  local evolution_factor = util.check_bounds(util.textfield_to_number(evo_table["change-map-settings-evolution-factor-textfield"]),
                                             0, 1,
                                             player, {"msg.change-map-settings-invalid-evolution-factor"})
  if not evolution_factor then return end
  local evolution_time = util.check_bounds(util.textfield_to_number(evo_table["change-map-settings-evolution-time-textfield"]),
                                           0, 0.0001,
                                           player, {"msg.change-map-settings-invalid-evolution-time"})
  if not evolution_time then return end
  local evolution_destroy = util.check_bounds(util.textfield_to_number(evo_table["change-map-settings-evolution-destroy-textfield"]),
                                              0, 0.01,
                                              player, {"msg.change-map-settings-invalid-evolution-destroy"})
  if not evolution_destroy then return end
  local evolution_pollution = util.check_bounds(util.textfield_to_number(evo_table["change-map-settings-evolution-pollution-textfield"]),
                                                0, 0.0001,
                                                player, {"msg.change-map-settings-invalid-evolution-pollution"})
  if not evolution_pollution then return end
  -- Pollution
  local pollution_table = config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
  local pollution_enabled = pollution_table["change-map-settings-pollution-checkbox"].state
  local pollution_diffusion = util.check_bounds(util.textfield_to_uint(pollution_table["change-map-settings-pollution-diffusion-textfield"]),
                                                0, 25,
                                                player, {"msg.change-map-settings-invalid-pollution-diffusion"})
  if not pollution_diffusion then return end
  local pollution_dissipation = util.check_bounds(util.textfield_to_uint(pollution_table["change-map-settings-pollution-dissipation-textfield"]),
                                                  0, 1000,
                                                  player, {"msg.change-map-settings-invalid-pollution-dissipation"})
  if not pollution_dissipation then return end 
  local pollution_tree_dmg = util.check_bounds(util.textfield_to_uint(pollution_table["change-map-settings-pollution-tree-dmg-textfield"]),
                                               0, 9999,
                                               player, {"msg.change-map-settings-invalid-pollution-tree-dmg"})
  if not pollution_tree_dmg then return end
  local pollution_tree_absorb = util.check_bounds(util.textfield_to_uint(pollution_table["change-map-settings-pollution-tree-absorb-textfield"]),
                                                  0, 9999,
                                                  player, {"msg.change-map-settings-invalid-pollution-tree-absorb"})
  if not pollution_tree_absorb then return end
  -- Enemy expansion
  local expansion_table = config_table["change-map-settings-config-more-expansion-flow"]["change-map-settings-config-more-expansion-table"]
  local expansion_enabled = expansion_table["change-map-settings-enemy-expansion-checkbox"].state
  local expansion_distance = util.check_bounds(util.textfield_to_uint(expansion_table["change-map-settings-expansion-distance-textfield"]),
                                               2, 20,
                                               player, {"msg.change-map-settings-invalid-expansion-distance"})
  if not expansion_distance then return end
  local expansion_min_size = util.check_bounds(util.textfield_to_uint(expansion_table["change-map-settings-expansion-min-size-textfield"]),
                                               1, 20,
                                               player, {"msg.change-map-settings-invalid-expansion-min-size"})
  if not expansion_min_size then return end
  local expansion_max_size = util.check_bounds(util.textfield_to_uint(expansion_table["change-map-settings-expansion-max-size-textfield"]),
                                               math.max(expansion_min_size, 1), 50,
                                               player, {"msg.change-map-settings-invalid-expansion-max-size"})
  if not expansion_max_size then return end
  local expansion_min_cd = util.check_bounds(util.textfield_to_uint(expansion_table["change-map-settings-expansion-min-cd-textfield"]),
                                                  1, 60,
                                                  player, {"msg.change-map-settings-invalid-expansion-min-cd"})
  if not expansion_min_cd then return end
  local expansion_max_cd = util.check_bounds(util.textfield_to_uint(expansion_table["change-map-settings-expansion-max-cd-textfield"]),
                                             math.max(expansion_min_cd, 5), 180,
                                             player, {"msg.change-map-settings-invalid-expansion-max-cd"})
  if not expansion_max_cd then return end

  -- And now to apply it all
  for _, surface in pairs(game.surfaces) do
    surface.peaceful_mode = peaceful_mode
  end
  
  map_settings.enemy_evolution.enabled = evolution_enabled
  game.forces["enemy"].evolution_factor = evolution_factor
  map_settings.enemy_evolution.time_factor = evolution_time
  map_settings.enemy_evolution.destroy_factor = evolution_destroy
  map_settings.enemy_evolution.pollution_factor = evolution_pollution
  
  if (pollution_enabled ~= map_settings.pollution.enabled) and (pollution_enabled == false) then
    for _, surface in pairs(game.surfaces) do
      surface.clear_pollution()
    end
  end
  map_settings.pollution.enabled = pollution_enabled
  map_settings.pollution.diffusion_ratio = (pollution_diffusion / 100)
  map_settings.pollution.ageing = pollution_dissipation
  map_settings.pollution.min_pollution_to_damage_trees = pollution_tree_dmg
  map_settings.pollution.pollution_restored_per_tree_damage = pollution_tree_absorb
  
  map_settings.enemy_expansion.enabled = expansion_enabled
  map_settings.enemy_expansion.max_expansion_distance = expansion_distance
  map_settings.enemy_expansion.settler_group_min_size = expansion_min_size
  map_settings.enemy_expansion.settler_group_max_size = expansion_max_size
  map_settings.enemy_expansion.min_expansion_cooldown = (expansion_min_cd * 3600)
  map_settings.enemy_expansion.max_expansion_cooldown = (expansion_max_cd * 3600)
  
  player.print({"msg.change-map-settings-applied"})
  
  -- Update the values shown in everyones gui
  for _, plyr in pairs(game.players) do
    gui.regen(plyr)
    set_to_current_map_gen_settings(plyr)
    local frame_flow = mod_gui.get_frame_flow(plyr)
    frame_flow["change-map-settings-main-flow"].style.visible = true
  end
end

local function reset_map_gen_to_default(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  -- general options --
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]

  map_gen_frame["change-map-settings-seed-table"]["change-map-settings-seed-textfield"].text = 0

  -- MAP GEN SETTINGS --
  -- resource table --
  local resource_table = map_gen_frame["change-map-settings-resource-scroll-pane"]["change-map-settings-resource-table"]
  local terrain_table = map_gen_frame["change-map-settings-resource-scroll-pane"]["change-map-settings-terrain-table"]
  local resources = util.get_table_of_resources()
  --water stuff
  terrain_table["change-map-settings-map-gen-water-freq"].selected_index = 4
  terrain_table["change-map-settings-map-gen-water-size"].selected_index = 4
  --starting area
  terrain_table["change-map-settings-map-gen-starting-area-size"].selected_index = 4
  -- resources and terrain
  local autoplace_control_prototypes = game.autoplace_control_prototypes
  for _, control in pairs(autoplace_control_prototypes) do
    if resources[control.name] then
      resource_table["change-map-settings-map-gen-" .. control.name .. "-freq"].selected_index = 4
      resource_table["change-map-settings-map-gen-" .. control.name .. "-size"].selected_index = 4
      resource_table["change-map-settings-map-gen-" .. control.name .. "-richn"].selected_index = 4
    else
      terrain_table["change-map-settings-map-gen-" .. control.name .. "-freq"].selected_index = 4
      terrain_table["change-map-settings-map-gen-" .. control.name .. "-size"].selected_index = 4
      if control.richness then terrain_table["change-map-settings-map-gen-" .. control.name .. "-richn"].selected_index = 4 end
    end
  end
  --cliffs
  terrain_table["change-map-settings-map-gen-cliffs-freq"].selected_index = 4
  terrain_table["change-map-settings-map-gen-cliffs-size"].selected_index = 4
end

local function change_map_gen_settings(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]
  
  local map_gen_settings = {}
  --general things
  local seed = util.textfield_to_uint(map_gen_frame["change-map-settings-seed-table"]["change-map-settings-seed-textfield"])
  if seed and seed == 0 then
    map_gen_settings.seed = math.random(0, 4294967295)
  elseif seed then
    map_gen_settings.seed = seed
  else
    player.print({"msg.change-map-settings-invalid-seed"})
    return nil
  end

  -- Autoplace controls --
  local freq_options = {"none", "very-low", "low", "normal", "high", "very-high"}
  local size_options = {"none", "very-small", "small", "medium", "big", "very-big"}
  local richn_options = {"none", "very-poor", "poor", "regular", "good", "very-good"}
  local autoplace_control_prototypes = game.autoplace_control_prototypes
  local resource_table = map_gen_frame["change-map-settings-resource-scroll-pane"]["change-map-settings-resource-table"]
  local autoplace_controls_mine = {}
  local resources = util.get_table_of_resources()
  --Resource settings--
  --resources
  for _, control in pairs(autoplace_control_prototypes) do
    if resources[control.name] then
      autoplace_controls_mine[control.name] = {
        frequency = freq_options[resource_table["change-map-settings-map-gen-" .. control.name .. "-freq"].selected_index],
        size = size_options[resource_table["change-map-settings-map-gen-" .. control.name .. "-size"].selected_index],
        richness = richn_options[resource_table["change-map-settings-map-gen-" .. control.name .. "-richn"].selected_index]
      }
    end
  end
  --Terrain settings--
  local terrain_table = map_gen_frame["change-map-settings-resource-scroll-pane"]["change-map-settings-terrain-table"]
  --water stuff
  map_gen_settings.terrain_segmentation = freq_options[terrain_table["change-map-settings-map-gen-water-freq"].selected_index]
  map_gen_settings.water = size_options[terrain_table["change-map-settings-map-gen-water-size"].selected_index]
  --starting area
  local starting_area_options = {"very-small", "small", "medium", "big", "very-big"}
  map_gen_settings.starting_area = starting_area_options[terrain_table["change-map-settings-map-gen-starting-area-size"].selected_index]
  --biters
  --terrain
  for _, control in pairs(autoplace_control_prototypes) do
    if not resources[control.name] then
      if control.richness then
        autoplace_controls_mine[control.name] = {
          frequency = freq_options[terrain_table["change-map-settings-map-gen-" .. control.name .. "-freq"].selected_index],
          size = size_options[terrain_table["change-map-settings-map-gen-" .. control.name .. "-size"].selected_index],
          richness = richn_options[terrain_table["change-map-settings-map-gen-" .. control.name .. "-richn"].selected_index]
        }
      else
        autoplace_controls_mine[control.name] = {
          frequency = freq_options[terrain_table["change-map-settings-map-gen-" .. control.name .. "-freq"].selected_index],
          size = size_options[terrain_table["change-map-settings-map-gen-" .. control.name .. "-size"].selected_index]
        }
      end
    end
  end
  map_gen_settings.autoplace_controls = autoplace_controls_mine
  
  local cliff_freq_lookup = {
    [1] = 40,
    [2] = 20,
    [3] = 10,
    [4] = 5,
    [5] = 2.5
  }
  local cliff_size_lookup = {
    [1] = 1024, 
    [2] = 40,
    [3] = 20,
    [4] = 10,
    [5] = 5,
    [6] = 2.5
  }
  local cliff_settings = {}
  cliff_settings.name = "cliff"
  cliff_settings.cliff_elevation_interval = cliff_freq_lookup[terrain_table["change-map-settings-map-gen-cliffs-freq"].selected_index]
  cliff_settings.cliff_elevation_0 = cliff_size_lookup[terrain_table["change-map-settings-map-gen-cliffs-size"].selected_index]
  map_gen_settings.cliff_settings = cliff_settings
  
  -- Apply
  player.surface.map_gen_settings = map_gen_settings
  player.print({"msg.change-map-settings-applied"})
  
  -- Update the values shown in everyones gui
  for _, plyr in pairs(game.players) do
    gui.regen(plyr)
    set_to_current_map_gen_settings(plyr)
    local frame_flow = mod_gui.get_frame_flow(plyr)
    frame_flow["change-map-settings-main-flow"].style.visible = true
  end
end

script.on_event({defines.events.on_gui_click}, function(event)
  local player = game.players[event.player_index]
  local frame_flow = mod_gui.get_frame_flow(player)
  local clicked_name = event.element.name
  if clicked_name == "change-map-settings-toggle-config" then
    frame_flow["change-map-settings-main-flow"].style.visible = not frame_flow["change-map-settings-main-flow"].style.visible
  elseif clicked_name == "change-map-settings-start-button" then
    if player.admin then
      change_map_settings(player)
    else
      player.print({"msg.change-map-settings-start-admin-restriction", {"gui.change-map-settings-title"}})
    end
  elseif clicked_name == "change-map-settings-start-map-gen-button" then
    if player.admin then
      change_map_gen_settings(player)
    else
      player.print({"msg.change-map-settings-start-admin-restriction", {"gui.change-map-settings-map-gen-title"}})
    end
  elseif clicked_name == "change-map-settings-use-current-button" then
    set_to_current_map_settings(player)
  elseif clicked_name == "change-map-settings-use-current-map-gen-button" then
    set_to_current_map_gen_settings(player)
  elseif clicked_name == "change-map-settings-default-button" then
    reset_to_default(player)
  elseif clicked_name == "change-map-settings-default-map-gen-button" then
    reset_map_gen_to_default(player)
  elseif clicked_name == "change-map-settings-map-gen-tab-button" then
    local resource_scroll_pane = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]["change-map-settings-resource-scroll-pane"]
    resource_scroll_pane["change-map-settings-terrain-table"].style.visible = not resource_scroll_pane["change-map-settings-terrain-table"].style.visible
    resource_scroll_pane["change-map-settings-resource-table"].style.visible = not resource_scroll_pane["change-map-settings-resource-table"].style.visible
  end
end)

script.on_configuration_changed(function() --migration
  for _, player in pairs(game.players) do
    gui.regen(player)
    set_to_current_map_gen_settings(player)
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  gui.regen(player)
  set_to_current_map_gen_settings(player)
end)

script.on_init(function()
  for _, player in pairs(game.players) do
    gui.regen(player)
    set_to_current_map_gen_settings(player)
  end
end)
