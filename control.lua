local mod_gui = require("mod-gui")
local gui = require("gui")
local util = require("utilities")
local map_gen_gui = require("map_gen_settings_gui")
local map_settings_gui = require("map_settings_gui")

-- ensures the current state, if not already stored, is persisted
-- use this before changing settings
local function store_default(player)
  if global.original_settings == nil then
    global.original_settings = game.map_settings
    global.original_peaceful = player.surface.peaceful_mode
  end
  local surface_id = player.surface.index
  map_gen_settings = global.surface_defaults[surface_id]
  if map_gen_settings == nil then
    map_gen_settings = game.surfaces[surface_id].map_gen_settings
    global.surface_defaults[surface_id] = map_gen_settings
  end
end

local function reset_to_default(player)
  store_default(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local config_table = frame_flow["change-map-settings-main-flow"]["change-map-settings-config-frame"]["change-map-settings-config-subframe"]["change-map-settings-config-table"]

  local map_settings = nil
  local peaceful_mode = nil
  local dropdown = frame_flow["change-map-settings-main-flow"]["change-map-settings-config-frame"]["change-map-settings-map-flow-1"]["change-map-settings-map-preset-drop-down"]
  if dropdown.selected_index == 1 then
    if global.original_settings == nil then
      global.original_settings = game.map_settings
      global.original_peaceful = player.surface.peaceful_mode
    end
    local surface_id = player.surface.index
    map_settings = global.original_settings
    peaceful_mode = global.original_peaceful
  else
    local selected_preset = dropdown.items[dropdown.selected_index]
    for name, preset in pairs(game.map_gen_presets) do
      local t = {"map-gen-preset-name." .. name}
      if util.compare_localized_strings(t, selected_preset) then
        map_settings = util.get_map_settings_from_preset(preset)
        peaceful_mode = map_settings.peaceful_mode
        break
      end
    end
  end

  --General
  local general_table = config_table["change-map-settings-config-more-general-flow"]["change-map-settings-config-more-general-table"]
  general_table["change-map-settings-peaceful-checkbox"].state = peaceful_mode

  -- MAP SETTINGS --
  map_settings_gui.expansion_set_to_current(config_table, map_settings)
  map_settings_gui.evolution_set_to_current(config_table, map_settings)
  map_settings_gui.pollution_set_to_current(config_table, map_settings)
end

local function set_to_current_map_gen_settings(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local map_gen_settings = player.surface.map_gen_settings
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]

  --seed
  map_gen_frame["change-map-settings-map-gen-flow-1"]["change-map-settings-seed-textfield"].text = tostring(map_gen_settings.seed)

  --the rest
  map_gen_gui.set_to_current(map_gen_frame["change-map-settings-map-gen-flow-2"], map_gen_settings)
end

local function set_to_current_map_settings(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local config_table = frame_flow["change-map-settings-main-flow"]["change-map-settings-config-frame"]["change-map-settings-config-subframe"]["change-map-settings-config-table"]
  --General
  local general_table = config_table["change-map-settings-config-more-general-flow"]["change-map-settings-config-more-general-table"]
  general_table["change-map-settings-peaceful-checkbox"].state = player.surface.peaceful_mode

  -- MAP SETTINGS --
  local map_settings = game.map_settings
  map_settings_gui.expansion_set_to_current(config_table, map_settings)
  map_settings_gui.evolution_set_to_current(config_table, map_settings)
  map_settings_gui.pollution_set_to_current(config_table, map_settings)
end

local function set_to_current_all(player)
  set_to_current_map_gen_settings(player)
  set_to_current_map_settings(player)
end

local function change_map_settings(player)
  store_default(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local config_table = frame_flow["change-map-settings-main-flow"]["change-map-settings-config-frame"]["change-map-settings-config-subframe"]["change-map-settings-config-table"]

  -- Reading everything out
  local general_table = config_table["change-map-settings-config-more-general-flow"]["change-map-settings-config-more-general-table"]
  local peaceful_mode = general_table["change-map-settings-peaceful-checkbox"].state

  local status, enemy_expansion = pcall(map_settings_gui.expansion_read, config_table)
  if not status then
    player.print(enemy_expansion)
    player.print({"msg.change-map-settings-apply-failed"})
    return
  end
  local status2, enemy_evolution = pcall(map_settings_gui.evolution_read, config_table)
  if not status2 then
    player.print(enemy_evolution)
    player.print({"msg.change-map-settings-apply-failed"})
    return
  end
  local status3, pollution = pcall(map_settings_gui.pollution_read, config_table)
  if not status3 then
    player.print(pollution)
    player.print({"msg.change-map-settings-apply-failed"})
    return
  end

  -- And now to apply it all
  for _, surface in pairs(game.surfaces) do
    surface.peaceful_mode = peaceful_mode
  end

  local map_settings = game.map_settings
  if (pollution.enabled ~= map_settings.pollution.enabled) and (pollution.enabled == false) then
    for _, surface in pairs(game.surfaces) do
      surface.clear_pollution()
    end
  end
  for k, v in pairs(pollution) do -- fucking structs
    map_settings.pollution[k] = v
  end
  for k, v in pairs(enemy_expansion) do
    map_settings.enemy_expansion[k] = v
  end
  for k, v in pairs(enemy_evolution) do
    map_settings.enemy_evolution[k] = v
  end
  game.forces["enemy"].evolution_factor = enemy_evolution.evolution_factor

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

  local map_gen_settings = nil
  local dropdown = map_gen_frame["change-map-settings-map-gen-flow-1"]["change-map-settings-mapgen-preset-drop-down"]
  if dropdown.selected_index == 1 then
    local surface_id = player.surface.index
    map_gen_settings = global.surface_defaults[surface_id]
    if map_gen_settings == nil then
      -- we have not seen this surface yet, so we did not yet change its settings and can still save them
      -- Mod compat note:
      -- Keep the check and add here instead of on_surface_created to work with mods that change the generation after surface creation.
      -- Example: Space Exploration changes the settings of nauvis after on_init() of this mod is called, so we would store the wrong (old) settings.
      map_gen_settings = game.surfaces[surface_id].map_gen_settings
      global.surface_defaults[surface_id] = map_gen_settings
    end
  elseif dropdown.selected_index == 2 then
    map_gen_settings = game.default_map_gen_settings
  else
    local selected_preset = dropdown.items[dropdown.selected_index]
    for name, preset in pairs(game.map_gen_presets) do
      local t = {"map-gen-preset-name." .. name}
      if util.compare_localized_strings(t, selected_preset) then
        map_gen_settings = util.get_map_gen_settings_from_preset(preset)
        break
      end
    end
    map_gen_settings.seed = player.surface.map_gen_settings.seed
  end

  --seed
  map_gen_frame["change-map-settings-map-gen-flow-1"]["change-map-settings-seed-textfield"].text = tostring(map_gen_settings.seed)

  --the rest
  map_gen_gui.set_to_current(map_gen_frame["change-map-settings-map-gen-flow-2"], map_gen_settings)
end

local function change_map_gen_settings(player)
  store_default(player)
  local frame_flow = mod_gui.get_frame_flow(player)
  local map_gen_frame = frame_flow["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"]

  --all the stuff
  local status, settings = pcall(map_gen_gui.read, map_gen_frame["change-map-settings-map-gen-flow-2"])
  if not status then
    player.print(settings)
    player.print({"msg.change-map-settings-apply-failed"})
    return
  end

  -- fill out missing fields with the current settings
  settings.peaceful_mode = player.surface.peaceful_mode
  settings.starting_points = player.surface.map_gen_settings.starting_points
  settings.width = player.surface.map_gen_settings.width
  settings.height = player.surface.map_gen_settings.height
  settings.default_enable_all_autoplace_controls = player.surface.map_gen_settings.default_enable_all_autoplace_controls
  settings.autoplace_settings = player.surface.map_gen_settings.autoplace_settings

  --seed
  local seed = util.textfield_to_uint(map_gen_frame["change-map-settings-map-gen-flow-1"]["change-map-settings-seed-textfield"])
  if seed and seed == 0 then
    settings.seed = math.random(0, 4294967295)
  elseif seed then
    settings.seed = seed
  else
    player.print({"msg.change-map-settings-invalid-seed"})
    return
  end

  --apply
  player.surface.map_gen_settings = settings
  player.print({"msg.change-map-settings-applied"})

    -- Update the values shown in everyones gui
  for _, plyr in pairs(game.players) do
    gui.regen(plyr)
    set_to_current_all(plyr)
    local frame_flow = mod_gui.get_frame_flow(plyr)
    frame_flow["change-map-settings-main-flow"].visible = true
  end
end

script.on_event({defines.events.on_gui_click}, function(event)
  local player = game.get_player(event.player_index)
  local frame_flow = mod_gui.get_frame_flow(player)
  local clicked_name = event.element.name
  if clicked_name == "change-map-settings-toggle-config" then
    local main_flow = frame_flow["change-map-settings-main-flow"]
    if not main_flow then
      gui.regen(player)
      set_to_current_all(player)
      main_flow = frame_flow["change-map-settings-main-flow"]
    end
    main_flow.visible = not main_flow.visible
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
  end
end)

script.on_configuration_changed(function() --migration
  for _, player in pairs(game.players) do
    gui.regen(player)
    set_to_current_all(player)
  end
end)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  gui.regen(player)
  set_to_current_all(player)
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
  local player = game.get_player(event.player_index)
  gui.regen(player)
  set_to_current_all(player)
end)

script.on_init(function()
  -- surfaces are indexed by their ID (index) in this table
  global.surface_defaults = {}
  global.original_settings = nil
  global.original_peaceful = nil

  for _, player in pairs(game.players) do
    gui.regen(player)
    set_to_current_all(player)
  end
end)

script.on_event(defines.events.on_surface_deleted, function(event)
  -- a surface was deleted, so we can remove its data from our store
  local deleted_id = event.surface_index
  global.surface_defaults[deleted_id] = nil
end)
