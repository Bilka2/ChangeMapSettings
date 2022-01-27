local util = require("__ChangeMapSettings__/utilities")
local mod_gui = require("__core__/lualib/mod-gui")
local map_gen_gui = require("__ChangeMapSettings__/map_gen_settings_gui")
local map_settings_gui = require("__ChangeMapSettings__/map_settings_gui")
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
  local main_flow = player.gui.screen.add{
    type = "frame",
    name = "change-map-settings-main-flow",
    direction = "horizontal",
    style = "invisible_frame"
  }
  main_flow.visible = false
  main_flow.force_auto_center()

  -- map settings
  local map_settings_frame = main_flow.add{
    type = "frame",
    caption = {"gui.change-map-settings-title"},
    name = "change-map-settings-map-settings-frame",
    direction = "vertical"
  }
  map_settings_frame.drag_target = main_flow
  gui.make_map_settings(map_settings_frame, player.surface)

  -- start button at the bottom
  gui.make_start_button(map_settings_frame, false)


  -- map gen settings
  local map_gen_frame = main_flow.add{
    type = "frame",
    caption = {"gui.change-map-settings-map-gen-title"},
    name = "change-map-settings-map-gen-frame",
    direction = "vertical"
  }
  map_gen_frame.drag_target = main_flow
  gui.make_map_gen_settings(map_gen_frame)

  -- start button at the bottom
  gui.make_start_button(map_gen_frame, true)
end

gui.make_map_settings = function(parent, surface)
  local inner_frame = parent.add{
    type = "frame",
    direction = "vertical",
    style = "window_content_frame_packed"
  }

  -- tool buttons
  do
    local frame = inner_frame.add{
      type = "frame",
      direction = "horizontal",
      style = "subheader_frame"
    }
    frame.add{
      type = "flow",
      direction = "horizontal",
      style = "pusher"
    }
    frame.add{
      type = "sprite-button",
      name = "change-map-settings-use-current-button",
      style = "tool_button",
      sprite = "utility/refresh",
      tooltip = {"gui.change-map-settings-use-current-button-caption"}
    }
    frame.add{
      type = "sprite-button",
      name = "change-map-settings-default-button",
      style = "tool_button_red",
      sprite = "utility/reset",
      tooltip = {"gui.change-map-settings-default-button-caption"}
    }
  end

  local table_holder = inner_frame.add{
    type = "frame",
    name = "change-map-settings-map-settings-table-holder",
    style = "b_inner_frame_no_border"
  }

  local config_table = table_holder.add{
    type = "table",
    column_count = 2,
    vertical_centering = false
  }
  config_table.style.horizontal_spacing = 12

  local map_settings = game.map_settings
  --make different map gen option groups
  map_settings_gui.make_pollution_settings(config_table, map_settings)
  map_settings_gui.make_expansion_settings(config_table, map_settings)
  map_settings_gui.make_evolution_settings(config_table, map_settings)
  gui.make_general_map_settings(config_table, surface)
end

gui.make_general_map_settings = function(parent, surface)
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
    caption = util.add_info_icon_to_string({"gui-map-generator.peaceful-mode-checkbox"}),
    tooltip = {"gui-map-generator.peaceful-mode-description"}
  }
  config_more_option_general_table.add{
    type = "checkbox",
    name = "change-map-settings-peaceful-checkbox",
    state = surface.peaceful_mode,
  }
  config_more_option_general_table.children[1].style.horizontally_stretchable = true
end

gui.get_map_settings_container = function(player)
  return player.gui.screen["change-map-settings-main-flow"]["change-map-settings-map-settings-frame"].children[1]["change-map-settings-map-settings-table-holder"].children[1]
end

gui.get_peaceful_mode_checkbox = function(player)
  return gui.get_map_settings_container(player)["change-map-settings-config-more-general-flow"]["change-map-settings-config-more-general-table"]["change-map-settings-peaceful-checkbox"]
end

gui.make_start_button = function(parent, map_gen)
  local start_button_flow = parent.add{
    type = "flow",
    direction = "horizontal"
  }
  start_button_flow.style.top_padding = 8
  start_button_flow.add{
    type = "flow",
    direction = "horizontal",
    style = "pusher"
  }
  start_button_flow.add{
    type = "button",
    name = "change-map-settings-start-" .. (map_gen and "map-gen-" or "") .. "button",
    tooltip = {"gui.change-map-settings-start-"  .. (map_gen and "map-gen-" or "") .. "button-tooltip"},
    caption = {"gui.change-map-settings-start-button-caption", {"gui.change-map-settings-"  .. (map_gen and "map-gen-" or "") .. "title"}},
    style = "confirm_button"
  }
end

gui.make_map_gen_settings = function(parent)
  local inner_frame = parent.add{
    type = "frame",
    direction = "vertical",
    style = "deep_frame"
  }

  do -- subheader
    local tool_button_frame = inner_frame.add{
      type = "frame",
      name = "change-map-settings-map-gen-button-frame",
      direction = "horizontal",
      style = "subheader_frame"
    }

    -- presets
    local presets = {}
    for name, preset in pairs(game.map_gen_presets) do
      if not preset.basic_settings then
        goto continue
      end
      if table_size(preset.basic_settings) == 1 and preset.basic_settings.property_expression_names and table_size(preset.basic_settings.property_expression_names) == 0 then
        goto continue -- vanilla marathon preset that does not have map gen settings affecting properties has an empty property_expression_names table for some reason
      end
      presets[#presets+1] = {"map-gen-preset-name." .. name}
      ::continue::
    end
    tool_button_frame.add{
      type = "drop-down",
      name = "change-map-settings-preset-dropdown",
      items = presets
    }
    tool_button_frame.add{
      type = "line",
      direction = "vertical"
    }

    -- seed
    local seed_label = tool_button_frame.add{
      type = "label",
      caption = {"gui.change-map-settings-seed-caption"},
      style = "caption_label"
    }
    seed_label.style.top_padding = 4
    seed_label.style.left_padding = 8
    tool_button_frame.add{
      type = "textfield",
      name = "change-map-settings-seed-textfield",
      text = "0",
      numeric = true,
      allow_decimal = false,
      allow_negative = false
    }
    tool_button_frame.add{
      type = "line",
      direction = "vertical"
    }

    -- tool_buttons
    tool_button_frame.add{
      type = "flow",
      direction = "horizontal",
      style = "pusher"
    }
    tool_button_frame.add{
      type = "sprite-button",
      name = "change-map-settings-use-current-map-gen-button",
      style = "tool_button",
      sprite = "utility/refresh",
      tooltip = {"gui.change-map-settings-use-current-button-caption"}
    }
    tool_button_frame.add{
      type = "sprite-button",
      name = "change-map-settings-default-map-gen-button",
      style = "tool_button_red",
      sprite = "utility/reset",
      tooltip = {"gui.change-map-settings-default-button-caption"}
    }
  end

  -- rest of map gen settings
  local map_gen_flow = inner_frame.add{
    type = "flow",
    name = "change-map-settings-map-gen-flow",
    direction = "horizontal"
  }
  map_gen_gui.create(map_gen_flow)
end

gui.get_map_gen_settings_container = function(player)
  return player.gui.screen["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"].children[1]["change-map-settings-map-gen-flow"]
end

gui.get_seed_field = function(player)
  local tool_button_frame = player.gui.screen["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"].children[1]["change-map-settings-map-gen-button-frame"]
  return tool_button_frame["change-map-settings-seed-textfield"]
end

gui.get_preset_dropdown = function(player)
  local tool_button_frame = player.gui.screen["change-map-settings-main-flow"]["change-map-settings-map-gen-frame"].children[1]["change-map-settings-map-gen-button-frame"]
  return tool_button_frame["change-map-settings-preset-dropdown"]
end

gui.kill = function(player)
  local button_flow = mod_gui.get_button_flow(player)
  if button_flow["change-map-settings-toggle-config"] then
    button_flow["change-map-settings-toggle-config"].destroy()
  end
  if player.gui.screen["change-map-settings-main-flow"] then
    player.gui.screen["change-map-settings-main-flow"].destroy()
  end

  --migration from pre 5.0.0
  local frame_flow = mod_gui.get_frame_flow(player)
  if frame_flow["change-map-settings-main-flow"] then
    frame_flow["change-map-settings-main-flow"].destroy()
  end

  --migration from 2.0.0
  if frame_flow["change-map-settings-config-more-frame"] then
		frame_flow["change-map-settings-config-more-frame"].destroy()
	end
end

return gui
