local mod_gui = require("mod-gui")
local gui = require("gui")
local util = require("utilities")
local map_gen_gui = require("map_gen_settings_gui")

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
  evo_table["change-map-settings-evolution-time-textfield"].text = "0.000400"
  evo_table["change-map-settings-evolution-destroy-textfield"].text = "0.200000"
  evo_table["change-map-settings-evolution-pollution-textfield"].text = "0.000090"
  --Pollution
  local pollution_table = config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
  pollution_table["change-map-settings-pollution-checkbox"].state = true
  pollution_table["change-map-settings-pollution-dissipation-textfield"].text = "1"
  pollution_table["change-map-settings-enemy-attack-pollution-consumption-textfield"].text = "1"
  pollution_table["change-map-settings-pollution-tree-dmg-textfield"].text = "60"
  pollution_table["change-map-settings-pollution-tree-absorb-textfield"].text = "10"
  pollution_table["change-map-settings-pollution-diffusion-textfield"].text = "2"
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
  local map_gen_settings = player.surface.map_gen_settings
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]
  
  --seed
  map_gen_frame["change-map-settings-seed-table"]["change-map-settings-seed-textfield"].text = tostring(map_gen_settings.seed)
  
  --the rest
  map_gen_gui.set_to_current(map_gen_frame, map_gen_settings)
  
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
  evo_table["change-map-settings-evolution-time-textfield"].text = util.float_to_string(map_settings.enemy_evolution.time_factor * 100)
  evo_table["change-map-settings-evolution-destroy-textfield"].text = util.float_to_string(map_settings.enemy_evolution.destroy_factor * 100)
  evo_table["change-map-settings-evolution-pollution-textfield"].text = util.float_to_string(map_settings.enemy_evolution.pollution_factor * 100)
  --Pollution
  local pollution_table = config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
  pollution_table["change-map-settings-pollution-checkbox"].state = map_settings.pollution.enabled
  pollution_table["change-map-settings-pollution-dissipation-textfield"].text = tostring(map_settings.pollution.ageing)
  pollution_table["change-map-settings-enemy-attack-pollution-consumption-textfield"].text = tostring(map_settings.pollution.enemy_attack_pollution_consumption_modifier)
  pollution_table["change-map-settings-pollution-tree-dmg-textfield"].text = tostring(map_settings.pollution.min_pollution_to_damage_trees)
  pollution_table["change-map-settings-pollution-tree-absorb-textfield"].text = tostring(map_settings.pollution.pollution_restored_per_tree_damage)
  pollution_table["change-map-settings-pollution-diffusion-textfield"].text = tostring(map_settings.pollution.diffusion_ratio * 100)
  --Enemy expansion
  local expansion_table = config_table["change-map-settings-config-more-expansion-flow"]["change-map-settings-config-more-expansion-table"]
  expansion_table["change-map-settings-enemy-expansion-checkbox"].state = map_settings.enemy_expansion.enabled
  expansion_table["change-map-settings-expansion-distance-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_distance)
  expansion_table["change-map-settings-expansion-min-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_min_size)
  expansion_table["change-map-settings-expansion-max-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_max_size)
  expansion_table["change-map-settings-expansion-min-cd-textfield"].text = tostring(map_settings.enemy_expansion.min_expansion_cooldown / 3600)
  expansion_table["change-map-settings-expansion-max-cd-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_cooldown / 3600)
end

local function set_to_current_all(player)
  set_to_current_map_gen_settings(player)
  set_to_current_map_settings(player)
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
                                           0, 0.01,
                                           player, {"msg.change-map-settings-invalid-evolution-time"})
  if not evolution_time then return end
  local evolution_destroy = util.check_bounds(util.textfield_to_number(evo_table["change-map-settings-evolution-destroy-textfield"]),
                                              0, 1,
                                              player, {"msg.change-map-settings-invalid-evolution-destroy"})
  if not evolution_destroy then return end
  local evolution_pollution = util.check_bounds(util.textfield_to_number(evo_table["change-map-settings-evolution-pollution-textfield"]),
                                                0, 0.01,
                                                player, {"msg.change-map-settings-invalid-evolution-pollution"})
  if not evolution_pollution then return end
  -- Pollution
  local pollution_table = config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
  local pollution_enabled = pollution_table["change-map-settings-pollution-checkbox"].state
  local pollution_dissipation = util.check_bounds(util.textfield_to_number(pollution_table["change-map-settings-pollution-dissipation-textfield"]),
                                                  0.1, 4,
                                                  player, {"msg.change-map-settings-invalid-pollution-absorption"})
  if not pollution_dissipation then return end
  local enemy_attack_pollution_consumption = util.check_bounds(util.textfield_to_number(pollution_table["change-map-settings-enemy-attack-pollution-consumption-textfield"]),
                                                               0.1, 4,
                                                               player, {"msg.change-map-settings-invalid-enemy-attack-pollution-consumption"})
  if not enemy_attack_pollution_consumption then return end  
  local pollution_tree_dmg = util.check_bounds(util.textfield_to_uint(pollution_table["change-map-settings-pollution-tree-dmg-textfield"]),
                                               0, 9999,
                                               player, {"msg.change-map-settings-invalid-pollution-tree-dmg"})
  if not pollution_tree_dmg then return end
  local pollution_tree_absorb = util.check_bounds(util.textfield_to_uint(pollution_table["change-map-settings-pollution-tree-absorb-textfield"]),
                                                  0, 9999,
                                                  player, {"msg.change-map-settings-invalid-pollution-tree-absorb"})
  if not pollution_tree_absorb then return end
  local pollution_diffusion = util.check_bounds(util.textfield_to_uint(pollution_table["change-map-settings-pollution-diffusion-textfield"]),
                                                0, 25,
                                                player, {"msg.change-map-settings-invalid-pollution-diffusion"})
  if not pollution_diffusion then return end
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
  map_settings.enemy_evolution.time_factor = (evolution_time / 100)
  map_settings.enemy_evolution.destroy_factor = (evolution_destroy / 100)
  map_settings.enemy_evolution.pollution_factor = (evolution_pollution / 100)
  
  if (pollution_enabled ~= map_settings.pollution.enabled) and (pollution_enabled == false) then
    for _, surface in pairs(game.surfaces) do
      surface.clear_pollution()
    end
  end
  map_settings.pollution.enabled = pollution_enabled
  map_settings.pollution.ageing = pollution_dissipation
  map_settings.pollution.enemy_attack_pollution_consumption_modifier = enemy_attack_pollution_consumption
  map_settings.pollution.min_pollution_to_damage_trees = pollution_tree_dmg
  map_settings.pollution.pollution_restored_per_tree_damage = pollution_tree_absorb
  map_settings.pollution.diffusion_ratio = (pollution_diffusion / 100)
  
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
    set_to_current_all(plyr)
    local frame_flow = mod_gui.get_frame_flow(plyr)
    frame_flow["change-map-settings-main-flow"].visible = true
  end
end

local function reset_map_gen_to_default(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]
  
  --seed
  map_gen_frame["change-map-settings-seed-table"]["change-map-settings-seed-textfield"].text = 0
  
  --the rest
  map_gen_gui.reset_to_defaults(map_gen_frame)
end

local function change_map_gen_settings(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]
  
  --all the stuff
  local settings = map_gen_gui.read(map_gen_frame, player)
  
  --seed
  local seed = util.textfield_to_uint(map_gen_frame["change-map-settings-seed-table"]["change-map-settings-seed-textfield"])
  if seed and seed == 0 then
    settings.seed = math.random(0, 4294967295)
  elseif seed then
    settings.seed = seed
  else
    player.print({"msg.change-map-settings-invalid-seed"})
    return
  end
  
  --apply
  local status, err = pcall(function(player, settings)
      player.surface.map_gen_settings = settings
    end, player, settings)
    
  if not status then
    player.print("Failed to apply map gen settings.")
  else
    player.print({"msg.change-map-settings-applied"})
  end
  
    -- Update the values shown in everyones gui
  for _, plyr in pairs(game.players) do
    gui.regen(plyr)
    set_to_current_all(plyr)
    local frame_flow = mod_gui.get_frame_flow(plyr)
    frame_flow["change-map-settings-main-flow"].visible = true
  end
end

script.on_event({defines.events.on_gui_click}, function(event)
  local player = game.players[event.player_index]
  local frame_flow = mod_gui.get_frame_flow(player)
  local clicked_name = event.element.name
  if clicked_name == "change-map-settings-toggle-config" then
    frame_flow["change-map-settings-main-flow"].visible = not frame_flow["change-map-settings-main-flow"].visible
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
  -- elseif clicked_name == "change-map-settings-map-gen-tab-button" then
    -- local resource_scroll_pane = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]["change-map-settings-resource-scroll-pane"]
    -- resource_scroll_pane["change-map-settings-terrain-table"].visible = not resource_scroll_pane["change-map-settings-terrain-table"].visible
    -- resource_scroll_pane["change-map-settings-resource-table"].visible = not resource_scroll_pane["change-map-settings-resource-table"].visible
  end
end)

script.on_configuration_changed(function() --migration
  for _, player in pairs(game.players) do
    gui.regen(player)
    set_to_current_all(player)
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  gui.regen(player)
  set_to_current_all(player)
end)

script.on_init(function()
  for _, player in pairs(game.players) do
    gui.regen(player)
    set_to_current_all(player)
  end
end)
