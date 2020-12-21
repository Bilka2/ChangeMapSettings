local mod_gui = require("mod-gui")
local util = require("utilities")
local map_gen_gui = require("map_gen_settings_gui")
local map_settings_gui = require("map_settings_gui")
local gui = {}

-- GUI --
gui.regen = function(player)
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

  local button_flow = config_frame.add{
    type = "flow",
    direction = "horizontal",
    name = "change-map-settings-map-flow-1",
  }
  button_flow.add{
    type = "button",
    name = "change-map-settings-use-current-button",
    style = mod_gui.button_style,
    caption = {"gui.change-map-settings-use-current-button-caption"}
  }
  button_flow.add{
    type = "button",
    name = "change-map-settings-default-button",
    style = mod_gui.button_style,
    caption = {"gui.change-map-settings-default-button-caption"}
  }


  -- build the reset dropdown, on top is the original setting
  local items = {}
  items[1] = {"gui.change-map-settings-game-default"}
  for name, _ in pairs(game.map_gen_presets) do
    items[#items+1] = {"map-gen-preset-name." .. name}
  end

  button_flow.add{
    type = "drop-down",
    name =  "change-map-settings-map-preset-drop-down",
    items = items,
    selected_index = 1
  }

  local config_subframe = config_frame.add{
    type = "frame",
    name = "change-map-settings-config-subframe",
    style = "b_inner_frame"
  }
  --make gui sections
  gui.make_advanced_settings(config_subframe, player.surface)

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
  local map_gen_flow1 = map_gen_frame.add{
    type = "flow",
    name = "change-map-settings-map-gen-flow-1",
    direction = "horizontal"
  }
  map_gen_flow1.add{
    type = "button",
    name = "change-map-settings-use-current-map-gen-button",
    style = mod_gui.button_style,
    caption = {"gui.change-map-settings-use-current-button-caption"}
  }
  map_gen_flow1.add{
    type = "button",
    name = "change-map-settings-default-map-gen-button",
    style = mod_gui.button_style,
    caption = {"gui.change-map-settings-default-button-caption"}
  }

  -- build the reset dropdown, on top are the default map generation settings from the new map GUI and the surface defaults
  local items = {}
  items[1] = {"gui.change-map-settings-surface-default"}
  items[2] = {"gui.change-map-settings-map-default"}
  for name, _ in pairs(game.map_gen_presets) do
    items[#items+1] = {"map-gen-preset-name." .. name}
  end

  map_gen_flow1.add{
    type = "drop-down",
    name =  "change-map-settings-mapgen-preset-drop-down",
    items = items,
    selected_index = 1
  }

  --seed
  local seed_label = map_gen_flow1.add{
    type = "label",
    caption = {"gui.change-map-settings-seed-caption"}
  }
  seed_label.style.top_padding = 4
  seed_label.style.left_padding = 8
  map_gen_flow1.add{
    type = "textfield",
    name = "change-map-settings-seed-textfield",
    text = "0",
    numeric = true,
    allow_decimal = false,
    allow_negative = false
  }

  -- rest of map gen settings
  local map_gen_flow2 = map_gen_frame.add{
    type = "flow",
    name = "change-map-settings-map-gen-flow-2",
    direction = "horizontal"
  }
  map_gen_gui.create(map_gen_flow2)

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
    column_count = 2,
    vertical_centering = false
  }
  config_table.style.horizontal_spacing = 12

  local map_settings = game.map_settings
  --make different advanced option groups
  map_settings_gui.make_pollution_settings(config_table, map_settings)
  map_settings_gui.make_expansion_settings(config_table, map_settings)
  map_settings_gui.make_evolution_settings(config_table, map_settings)
  gui.make_general_settings(config_table, surface)
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
    column_count = 2,
    style = "bordered_table"
  }
  config_more_option_general_table.style.column_alignments[2] = "center"

  config_more_option_general_table.add{
    type = "label",
    caption = {"gui-map-generator.peaceful-mode-checkbox"}
  }
  config_more_option_general_table.add{
    type = "checkbox",
    name = "change-map-settings-peaceful-checkbox",
    state = surface.peaceful_mode,
  }
  config_more_option_general_table.children[1].style.horizontally_stretchable = true
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
