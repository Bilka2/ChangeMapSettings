local gui = require("__ChangeMapSettings__/gui")
local util = require("__ChangeMapSettings__/utilities")
local map_gen_gui = require("__ChangeMapSettings__/map_gen_settings_gui")
local map_settings_gui = require("__ChangeMapSettings__/map_settings_gui")

local function reset_to_default_map_gen_settings(player)
  --seed
  gui.get_seed_field(player).text = "0"

  --select no preset
  gui.get_preset_dropdown(player).selected_index = 0

  --the rest
  map_gen_gui.reset_to_defaults(gui.get_map_gen_settings_container(player))
end

local function reset_to_default_map_settings(player)
  -- peaceful mode
  gui.get_peaceful_mode_checkbox(player).state = false

  -- MAP SETTINGS --
  local config_table = gui.get_map_settings_container(player)
  map_settings_gui.expansion_reset_to_defaults(config_table)
  map_settings_gui.evolution_reset_to_defaults(config_table)
  map_settings_gui.pollution_reset_to_defaults(config_table)
end

local function set_to_current_map_gen_settings(player)
  local map_gen_settings = player.surface.map_gen_settings

  --seed
  gui.get_seed_field(player).text = tostring(map_gen_settings.seed)

  --select no preset
  gui.get_preset_dropdown(player).selected_index = 0

  --the rest
  map_gen_gui.set_to_current(gui.get_map_gen_settings_container(player), map_gen_settings)
end

local function set_to_current_map_settings(player)
  -- peaceful mode
  gui.get_peaceful_mode_checkbox(player).state = player.surface.peaceful_mode

  -- MAP SETTINGS --
  local config_table = gui.get_map_settings_container(player)
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
  local config_table = gui.get_map_settings_container(player)

  -- Reading everything out
  local peaceful_mode = gui.get_peaceful_mode_checkbox(player).state

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
    set_to_current_all(plyr)
    plyr.gui.screen["change-map-settings-main-flow"].visible = true
  end
end

local function change_map_gen_settings(player)
  --all the stuff
  local status, settings = pcall(map_gen_gui.read, gui.get_map_gen_settings_container(player), player.surface.map_gen_settings)
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
  local seed = util.textfield_to_uint(gui.get_seed_field(player))
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
    set_to_current_all(plyr)
    plyr.gui.screen["change-map-settings-main-flow"].visible = true
  end
end

script.on_event({defines.events.on_gui_click}, function(event)
  local player = game.get_player(event.player_index)
  local screen_flow = player.gui.screen
  local clicked_name = event.element.name
  if clicked_name == "change-map-settings-toggle-config" then
    local main_flow = screen_flow["change-map-settings-main-flow"]
    if not main_flow then
      gui.regen(player)
      set_to_current_all(player)
      main_flow = screen_flow["change-map-settings-main-flow"]
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
    reset_to_default_map_settings(player)
  elseif clicked_name == "change-map-settings-default-map-gen-button" then
    reset_to_default_map_gen_settings(player)
  end
end)

script.on_event(defines.events.on_gui_selection_state_changed, function(event)
  if event.element.name ~= "change-map-settings-preset-dropdown" then return end

  local dropdown = event.element
  local item = dropdown.items[dropdown.selected_index]
  local player = game.get_player(event.player_index)

  -- reset to default first
  -- gui.get_seed_field(player).text = "0" -- not for now, makes it hard to keep the seed the same when browsing settings
  map_gen_gui.reset_to_defaults(gui.get_map_gen_settings_container(player))

  -- then set up the preset
  -- {"map-gen-preset-name." .. preset_name}
  local preset_name = item[1]:sub(string.len("map-gen-preset-name.") + 1)
  local preset = game.map_gen_presets[preset_name]

  map_gen_gui.set_to_current(gui.get_map_gen_settings_container(player), preset.basic_settings)
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
  for _, player in pairs(game.players) do
    gui.regen(player)
    set_to_current_all(player)
  end
end)
