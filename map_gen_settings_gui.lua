local util = require("utilities")
local MOD_PREFIX = "change-map-settings-"
local GUI_PREFIX = "map-gen-"
local ENTIRE_PREFIX = MOD_PREFIX .. GUI_PREFIX
local map_gen_gui = {}

map_gen_gui.create = function(parent)
  local scroll_pane = parent.add{
    type = "scroll-pane",
    name = ENTIRE_PREFIX .. "resource-scroll-pane",
  }
  scroll_pane.style.maximal_height = 400
  scroll_pane.visible = true

  --map_gen_gui.create_map_type_selector(parent) TODO: Bilka

  map_gen_gui.create_resource_table(scroll_pane)
  map_gen_gui.create_controls_with_scale_table(parent)
  map_gen_gui.create_cliffs_table(parent)
  --map_gen_gui.create_moisture_and_terrain_type_table(parent) TODO: Bilka
  map_gen_gui.create_enemies_table(parent)
end

map_gen_gui.create_resource_table = function(parent)
  local table = parent.add{
    type = "table",
    name = ENTIRE_PREFIX .. "resource-table",
    column_count = 4,
    style = "bordered_table"
  }
  table.visible = true
  -- header
  table.add{type = "label"}
  table.add{
    type = "label",
    caption = {"gui-map-generator.frequency"},
    style = "caption_label",
    tooltip = {"gui-map-generator.resource-frequency-description"}
  }
  table.add{
    type = "label",
    caption = {"gui-map-generator.size"},
    style = "caption_label",
    tooltip = {"gui-map-generator.resource-size-description"}
  }
  table.add{
    type = "label",
    caption = {"gui-map-generator.richness"},
    style = "caption_label",
    tooltip = {"gui-map-generator.resource-richness-description"}
  }

  -- resources
  for _, control in pairs(game.autoplace_control_prototypes) do
    if control.category == "resource" then
      map_gen_gui.make_autoplace_options(control.name, table, true)
    end
  end
end

map_gen_gui.create_controls_with_scale_table = function(parent)
  local table = parent.add{
    type = "table",
    name = ENTIRE_PREFIX .. "controls-with-scale-table",
    column_count = 3,
    style = "bordered_table"
  }
  -- header
  table.add{type = "label"}
  table.add{
    type = "label",
    caption = {"gui-map-generator.scale"},
    style = "caption_label",
    tooltip = {"gui-map-generator.terrain-scale-description"}
  }
  table.add{
    type = "label",
    caption = {"gui-map-generator.coverage"},
    style = "caption_label",
    tooltip = {"gui-map-generator.terrain-coverage-description"}
  }
  table.children[1].style.horizontally_stretchable = true

  -- water
  map_gen_gui.make_autoplace_options("water", table, false)

  -- trees and custom mod stuff
  for _, control in pairs(game.autoplace_control_prototypes) do
    if control.category == "terrain" then
      map_gen_gui.make_autoplace_options(control.name, table, false)
    end
  end
end

map_gen_gui.create_cliffs_table = function(parent)
  local table = parent.add{
    type = "table",
    name = ENTIRE_PREFIX .. "cliffs-table",
    column_count = 3,
    style = "bordered_table"
  }
  -- header
  table.add{type = "label"}
  table.add{
    type = "label",
    caption = {"gui-map-generator.cliff-frequency"},
    style = "caption_label",
    tooltip = {"gui-map-generator.cliff-frequency-description"}
  }
  table.add{
    type = "label",
    caption = {"gui-map-generator.cliff-continuity"},
    style = "caption_label",
    tooltip = {"gui-map-generator.cliff-continuity-description"}
  }
  table.children[1].style.horizontally_stretchable = true

  -- cliffs
  map_gen_gui.make_autoplace_options("cliffs", table, false)
end

map_gen_gui.create_enemies_table = function(parent)
  local table = parent.add{
    type = "table",
    name = ENTIRE_PREFIX .. "enemies-table",
    column_count = 3,
    style = "bordered_table"
  }
  -- header
  table.add{type = "label"}
  table.add{
    type = "label",
    caption = {"gui-map-generator.frequency"},
    style = "caption_label",
    tooltip = {"gui-map-generator.enemy-frequency-description"}
  }
  table.add{
    type = "label",
    caption = {"gui-map-generator.size"},
    style = "caption_label",
    tooltip = {"gui-map-generator.enemy-size-description"}
  }
  table.children[1].style.horizontally_stretchable = true

  -- biter bases
  for _, control in pairs(game.autoplace_control_prototypes) do
    if control.category == "enemy" then
      map_gen_gui.make_autoplace_options(control.name, table, false)
    end
  end

  -- starting area size
  table.add{
    type = "label",
    caption = {"gui-map-generator.starting-area-size"}
  }
  table.add{type = "label"}
  table.add{
    type = "textfield",
    name = ENTIRE_PREFIX .. "starting-area-size",
    style = "short_number_textfield"
  }
end

map_gen_gui.make_autoplace_options = function(name, parent, has_richness)
  if name ~= "cliffs" and name ~= "water" then
    parent.add{
      type = "label",
      caption = {"autoplace-control-names." .. name}
    }
  else
    parent.add{
      type = "label",
      caption = {"gui-map-generator." .. name}
    }
  end
  parent.add{
    type = "textfield",
    name = ENTIRE_PREFIX .. name .. "-freq",
    style = "short_number_textfield"
  }
  parent.add{
    type = "textfield",
    name = ENTIRE_PREFIX .. name .. "-size",
    style = "short_number_textfield"
  }
  if has_richness then
    parent.add{
      type = "textfield",
      name = ENTIRE_PREFIX .. name .. "-richn",
      style = "short_number_textfield"
    }
  end
end

map_gen_gui.reset_to_defaults = function(parent)
  local resource_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .."resource-table"]
  local controls_with_scale_table = parent[ENTIRE_PREFIX .."controls-with-scale-table"]
  local enemies_table = parent[ENTIRE_PREFIX .."enemies-table"]

  -- water stuff
  controls_with_scale_table[ENTIRE_PREFIX .. "water-freq"].text = "1"
  controls_with_scale_table[ENTIRE_PREFIX .. "water-size"].text = "1"
  -- starting area
  enemies_table[ENTIRE_PREFIX .. "starting-area-size"].text = "1"

  -- resources and terrain and enemies
  local autoplace_control_prototypes = game.autoplace_control_prototypes
  for _, control in pairs(autoplace_control_prototypes) do
    if control.category == "resource" then
      resource_table[ENTIRE_PREFIX .. control.name .. "-freq"].text = "1"
      resource_table[ENTIRE_PREFIX .. control.name .. "-size"].text = "1"
      resource_table[ENTIRE_PREFIX .. control.name .. "-richn"].text = "1"
    elseif control.category == "terrain" then
      controls_with_scale_table[ENTIRE_PREFIX .. control.name .. "-freq"].text = "1"
      controls_with_scale_table[ENTIRE_PREFIX .. control.name .. "-size"].text = "1"
    elseif control.category == "enemy" then
      enemies_table[ENTIRE_PREFIX .. control.name .. "-freq"].text = "1"
      enemies_table[ENTIRE_PREFIX .. control.name .. "-size"].text = "1"
    end
  end

  --cliffs
  local cliffs_table = parent[ENTIRE_PREFIX .."cliffs-table"]
  cliffs_table[ENTIRE_PREFIX .. "cliffs-freq"].text = "1"
  cliffs_table[ENTIRE_PREFIX .. "cliffs-size"].text = "1"
end

map_gen_gui.set_to_current = function(parent, map_gen_settings)
  local resource_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .."resource-table"]
  local controls_with_scale_table = parent[ENTIRE_PREFIX .."controls-with-scale-table"]
  local enemies_table = parent[ENTIRE_PREFIX .."enemies-table"]

  -- water stuff
  controls_with_scale_table[ENTIRE_PREFIX .. "water-freq"].text = util.number_to_string(1 / map_gen_settings.terrain_segmentation) -- inverse
  controls_with_scale_table[ENTIRE_PREFIX .. "water-size"].text = util.number_to_string(map_gen_settings.water)
  -- starting area
  enemies_table[ENTIRE_PREFIX .. "starting-area-size"].text = util.number_to_string(map_gen_settings.starting_area)

  -- resources and terrain and enemies
  local autoplace_controls = map_gen_settings.autoplace_controls
  local valid_autoplace_controls = game.autoplace_control_prototypes
  if autoplace_controls then
    for name, autoplace_control in pairs(autoplace_controls) do
      if valid_autoplace_controls[name] then
        if valid_autoplace_controls[name].category == "resource" then
          resource_table[ENTIRE_PREFIX .. name .. "-freq"].text = util.number_to_string(autoplace_control["frequency"])
          resource_table[ENTIRE_PREFIX .. name .. "-size"].text = util.number_to_string(autoplace_control["size"])
          resource_table[ENTIRE_PREFIX .. name .. "-richn"].text = util.number_to_string(autoplace_control["richness"])
        elseif valid_autoplace_controls[name].category == "terrain" then
          controls_with_scale_table[ENTIRE_PREFIX .. name .. "-freq"].text = util.number_to_string(1 / autoplace_control["frequency"]) -- inverse
          controls_with_scale_table[ENTIRE_PREFIX .. name .. "-size"].text = util.number_to_string(autoplace_control["size"])
        elseif valid_autoplace_controls[name].category == "enemy" then
          enemies_table[ENTIRE_PREFIX .. name .. "-freq"].text = util.number_to_string(autoplace_control["frequency"])
          enemies_table[ENTIRE_PREFIX .. name .. "-size"].text = util.number_to_string(autoplace_control["size"])
        end
      end
    end
  end

  -- cliffs
  local cliffs_table = parent[ENTIRE_PREFIX .."cliffs-table"]
  local cliff_settings = map_gen_settings.cliff_settings
  cliffs_table[ENTIRE_PREFIX .. "cliffs-freq"].text = util.number_to_string(40 / cliff_settings.cliff_elevation_interval) -- inverse with 40
  cliffs_table[ENTIRE_PREFIX .. "cliffs-size"].text = util.number_to_string(cliff_settings.richness)
end

map_gen_gui.read = function(parent, player)
  local map_gen_settings = {}
  local resource_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .. "resource-table"]
  local controls_with_scale_table = parent[ENTIRE_PREFIX .."controls-with-scale-table"]
  local enemies_table = parent[ENTIRE_PREFIX .."enemies-table"]

  -- water stuff
  map_gen_settings.terrain_segmentation = 1 / util.textfield_to_number_with_error(controls_with_scale_table[ENTIRE_PREFIX .. "water-freq"], player) -- inverse
  map_gen_settings.water = util.textfield_to_number_with_error(controls_with_scale_table[ENTIRE_PREFIX .. "water-size"], player)
  -- starting area
  map_gen_settings.starting_area = util.textfield_to_number_with_error(enemies_table[ENTIRE_PREFIX .. "starting-area-size"], player)

  local autoplace_control_prototypes = game.autoplace_control_prototypes
  local autoplace_controls_mine = {}
  -- resources and terrain and enemies
  for _, control in pairs(autoplace_control_prototypes) do
    if control.category == "resource" then
      autoplace_controls_mine[control.name] = {
        frequency = util.textfield_to_number_with_error(resource_table[ENTIRE_PREFIX .. control.name .. "-freq"], player),
        size = util.textfield_to_number_with_error(resource_table[ENTIRE_PREFIX .. control.name .. "-size"], player),
        richness = util.textfield_to_number_with_error(resource_table[ENTIRE_PREFIX .. control.name .. "-richn"], player)
      }
    elseif control.category == "terrain" then
      autoplace_controls_mine[control.name] = {
        frequency = 1 / util.textfield_to_number_with_error(controls_with_scale_table[ENTIRE_PREFIX .. control.name .. "-freq"], player), -- inverse
        size = util.textfield_to_number_with_error(controls_with_scale_table[ENTIRE_PREFIX .. control.name .. "-size"], player)
      }
    elseif control.category == "enemy" then
      autoplace_controls_mine[control.name] = {
        frequency = util.textfield_to_number_with_error(enemies_table[ENTIRE_PREFIX .. control.name .. "-freq"], player),
        size = util.textfield_to_number_with_error(enemies_table[ENTIRE_PREFIX .. control.name .. "-size"], player)
      }
    end
  end
  map_gen_settings.autoplace_controls = autoplace_controls_mine

  -- cliffs
  local cliffs_table = parent[ENTIRE_PREFIX .."cliffs-table"]
  local cliff_settings = {}
  cliff_settings.name = "cliff"
  cliff_settings.cliff_elevation_interval = 40 / util.textfield_to_number_with_error(cliffs_table["change-map-settings-map-gen-cliffs-freq"], player) -- inverse with 40
  cliff_settings.richness = util.textfield_to_number_with_error(cliffs_table["change-map-settings-map-gen-cliffs-size"], player)
  map_gen_settings.cliff_settings = cliff_settings

  return map_gen_settings
end


return map_gen_gui