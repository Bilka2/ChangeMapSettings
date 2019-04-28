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
  
  local resources = util.get_table_of_resources()
  
  local resource_table = scroll_pane.add{
    type = "table",
    name = ENTIRE_PREFIX .. "resource-table",
    column_count = 4
  }
  resource_table.visible = true
  map_gen_gui.resource_table_header(resource_table)
  map_gen_gui.resource_options(resource_table, resources)
  
  local terrain_table = scroll_pane.add{
    type = "table",
    name = ENTIRE_PREFIX .. "terrain-table",
    column_count = 3
  }
  --terrain_table.visible = false
  map_gen_gui.terrain_table_header(terrain_table)
  map_gen_gui.terrain_options(terrain_table, resources)
end

map_gen_gui.resource_table_header = function(parent)
  parent.add{type = "label"}
  parent.add{
    type = "label",
    caption = {"gui-map-generator.frequency"},
    style = "caption_label"
  }
  parent.add{
    type = "label",
    caption = {"gui-map-generator.size"},
    style = "caption_label"
  }
  parent.add{
    type = "label",
    caption = {"gui-map-generator.richness"},
    style = "caption_label"
  }
end

map_gen_gui.terrain_table_header = function(parent, bool)
  parent.add{type = "label"}
  parent.add{
    type = "label",
    caption = {"gui-map-generator.frequency"},
    style = "caption_label"
  }
  parent.add{
    type = "label",
    caption = {"", {"gui-map-generator.size"}, "/", {"gui-map-generator.cliff-continuity"}},
    style = "caption_label"
  }
end

map_gen_gui.resource_options = function(parent, resources)
  --resources
  for _, control in pairs(game.autoplace_control_prototypes) do
    if resources[control.name] then
      map_gen_gui.make_autoplace_options(control.name, parent, true)
    end
  end
end

map_gen_gui.terrain_options = function(parent, resources)
  --starting area
  parent.add{
    type = "label",
    caption = {"gui-map-generator.starting-area-size"}
  }
  parent.add{type = "label"}
  parent.add{
    type = "textfield",
    name = ENTIRE_PREFIX .. "starting-area-size",
    style = "short_number_textfield"
  }
  
  --water
  map_gen_gui.make_autoplace_options("water", parent, false)
  
  --terrain (trees + biter bases)
  for _, control in pairs(game.autoplace_control_prototypes) do
    if not resources[control.name] then
      map_gen_gui.make_autoplace_options(control.name, parent, false)
    end
  end
  --cliffs
  map_gen_gui.make_autoplace_options("cliffs", parent, false)
end

map_gen_gui.make_autoplace_options = function(name, parent, richness)
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
  if richness then
    parent.add{
      type = "textfield",
      name = ENTIRE_PREFIX .. name .. "-richn",
    style = "short_number_textfield"
    }
  end
end

map_gen_gui.reset_to_defaults = function(parent)
  -- resource table --
  local resource_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .."resource-table"]
  local terrain_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .."terrain-table"]
  local resources = util.get_table_of_resources()
  --water stuff
  terrain_table[ENTIRE_PREFIX .. "water-freq"].text = "1"
  terrain_table[ENTIRE_PREFIX .. "water-size"].text = "1"
  --starting area
  terrain_table[ENTIRE_PREFIX .. "starting-area-size"].text = "1"
  -- resources and terrain
  local autoplace_control_prototypes = game.autoplace_control_prototypes
  for _, control in pairs(autoplace_control_prototypes) do
    if resources[control.name] then
      resource_table[ENTIRE_PREFIX .. control.name .. "-freq"].text = "1"
      resource_table[ENTIRE_PREFIX .. control.name .. "-size"].text = "1"
      resource_table[ENTIRE_PREFIX .. control.name .. "-richn"].text = "1"
    else
      terrain_table[ENTIRE_PREFIX .. control.name .. "-freq"].text = "1"
      terrain_table[ENTIRE_PREFIX .. control.name .. "-size"].text = "1"
    end
  end
  --cliffs
  terrain_table[ENTIRE_PREFIX .. "cliffs-freq"].text = "40"
  terrain_table[ENTIRE_PREFIX .. "cliffs-size"].text = "1"

end

map_gen_gui.set_to_current = function(parent, map_gen_settings)
  -- resource table --
  local resource_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .."resource-table"]
  local terrain_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .."terrain-table"]
  local resources = util.get_table_of_resources()

  --water stuff
  terrain_table[ENTIRE_PREFIX .. "water-freq"].text = tostring(map_gen_settings.terrain_segmentation)
  terrain_table[ENTIRE_PREFIX .. "water-size"].text = tostring(map_gen_settings.water)
  --starting area
  terrain_table[ENTIRE_PREFIX .. "starting-area-size"].text = tostring(map_gen_settings.starting_area)
  -- resources and terrain
  local autoplace_controls = map_gen_settings.autoplace_controls
  local valid_autoplace_controls = game.autoplace_control_prototypes
  if autoplace_controls then
    for name, autoplace_control in pairs(autoplace_controls) do
      if valid_autoplace_controls[name] then 
        if resources[name] then
          resource_table[ENTIRE_PREFIX .. name .. "-freq"].text = tostring(autoplace_control["frequency"])
          resource_table[ENTIRE_PREFIX .. name .. "-size"].text = tostring(autoplace_control["size"])
          resource_table[ENTIRE_PREFIX .. name .. "-richn"].text = tostring(autoplace_control["richness"])
        else
          terrain_table[ENTIRE_PREFIX .. name .. "-freq"].text = tostring(autoplace_control["frequency"]) -- WHAT THE FUCK these are the inverse of the values shown in the generate map gui EXCEPT FOR ENEMY BASES ?????
          terrain_table[ENTIRE_PREFIX .. name .. "-size"].text = tostring(autoplace_control["size"])
        end
      end
    end
  end
  
  local cliff_settings = map_gen_settings.cliff_settings
  terrain_table[ENTIRE_PREFIX .. "cliffs-freq"].text = tostring(cliff_settings.cliff_elevation_interval)
  terrain_table[ENTIRE_PREFIX .. "cliffs-size"].text = tostring(cliff_settings.richness) -- WHAT THE FUCK why is it RICHNESS???
end

map_gen_gui.read = function(parent, player)
  local map_gen_settings = {}
  -- Autoplace controls --
  local autoplace_control_prototypes = game.autoplace_control_prototypes
  local resource_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .. "resource-table"]
  local autoplace_controls_mine = {}
  local resources = util.get_table_of_resources()
  --Resource settings--
  --resources
  for _, control in pairs(autoplace_control_prototypes) do
    if resources[control.name] then
      autoplace_controls_mine[control.name] = {
        frequency = util.textfield_to_number_with_error(resource_table[ENTIRE_PREFIX .. control.name .. "-freq"], player),
        size = util.textfield_to_number_with_error(resource_table[ENTIRE_PREFIX .. control.name .. "-size"], player),
        richness = util.textfield_to_number_with_error(resource_table[ENTIRE_PREFIX .. control.name .. "-richn"], player)
      }
    end
  end
  --Terrain settings--
  local terrain_table = parent[ENTIRE_PREFIX .. "resource-scroll-pane"][ENTIRE_PREFIX .. "terrain-table"]
  --water stuff
  map_gen_settings.terrain_segmentation = util.textfield_to_number_with_error(terrain_table[ENTIRE_PREFIX .. "water-freq"], player)
  map_gen_settings.water = util.textfield_to_number_with_error(terrain_table[ENTIRE_PREFIX .. "water-size"], player)
  --starting area
  map_gen_settings.starting_area = util.textfield_to_number_with_error(terrain_table[ENTIRE_PREFIX .. "starting-area-size"], player)
  --biters
  --terrain
  for _, control in pairs(autoplace_control_prototypes) do
    if not resources[control.name] then
      autoplace_controls_mine[control.name] = {
        frequency = util.textfield_to_number_with_error(terrain_table[ENTIRE_PREFIX .. control.name .. "-freq"], player),
        size = util.textfield_to_number_with_error(terrain_table[ENTIRE_PREFIX .. control.name .. "-size"], player)
      }
    end
  end
  map_gen_settings.autoplace_controls = autoplace_controls_mine
  
  local cliff_settings = {}
  cliff_settings.name = "cliff"
  cliff_settings.cliff_elevation_interval = util.textfield_to_number_with_error(terrain_table["change-map-settings-map-gen-cliffs-freq"], player)
  cliff_settings.richness = util.textfield_to_number_with_error(terrain_table["change-map-settings-map-gen-cliffs-size"], player)
  map_gen_settings.cliff_settings = cliff_settings
  
  return map_gen_settings
end


return map_gen_gui