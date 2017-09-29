require("mod-gui")
local gui = require("gui")
local util = require("utilities")

local function reset_to_default(player)
	local frame_flow = mod_gui.get_frame_flow(player)
	local more_config_table = frame_flow["change-map-settings-config-more-frame"]["change-map-settings-config-more-table"]
	-- MAP SETTINGS --
	--Evolution
	local evo_table = more_config_table["change-map-settings-config-more-evo-flow"]["change-map-settings-config-more-evo-table"]
	evo_table["change-map-settings-evolution-checkbox"].state = true
	evo_table["change-map-settings-evolution-factor-textfield"].text = "0"
	evo_table["change-map-settings-evolution-time-textfield"].text = "0.000004"
	evo_table["change-map-settings-evolution-destroy-textfield"].text = "0.002000"
	evo_table["change-map-settings-evolution-pollution-textfield"].text = "0.000015"
	--Pollution
	local pollution_table = more_config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
	pollution_table["change-map-settings-pollution-checkbox"].state = true
	pollution_table["change-map-settings-pollution-diffusion-textfield"].text = "2"
	pollution_table["change-map-settings-pollution-dissipation-textfield"].text = "1"
	pollution_table["change-map-settings-pollution-tree-dmg-textfield"].text = "3500"
	pollution_table["change-map-settings-pollution-tree-absorb-textfield"].text = "500"
	--Enemy expansion
	local expansion_table = more_config_table["change-map-settings-config-more-expansion-flow"]["change-map-settings-config-more-expansion-table"]
	expansion_table["change-map-settings-enemy-expansion-checkbox"].state = true
	expansion_table["change-map-settings-expansion-distance-textfield"].text = "7"
	expansion_table["change-map-settings-expansion-min-size-textfield"].text = "5"
	expansion_table["change-map-settings-expansion-max-size-textfield"].text = "20"
	expansion_table["change-map-settings-expansion-min-cd-textfield"].text = "4"
	expansion_table["change-map-settings-expansion-max-cd-textfield"].text = "60"
end

local function use_current_map_gen(player)
	local frame_flow = mod_gui.get_frame_flow(player)
	local more_config_table = frame_flow["change-map-settings-config-more-frame"]["change-map-settings-config-more-table"]
	-- MAP SETTINGS --
	local map_settings = game.map_settings
	--Evolution
	local evo_table = more_config_table["change-map-settings-config-more-evo-flow"]["change-map-settings-config-more-evo-table"]
	evo_table["change-map-settings-evolution-checkbox"].state = map_settings.enemy_evolution.enabled
	evo_table["change-map-settings-evolution-factor-textfield"].text = util.float_to_string(game.forces["enemy"].evolution_factor)
	evo_table["change-map-settings-evolution-time-textfield"].text = util.float_to_string(map_settings.enemy_evolution.time_factor)
	evo_table["change-map-settings-evolution-destroy-textfield"].text = util.float_to_string(map_settings.enemy_evolution.destroy_factor)
	evo_table["change-map-settings-evolution-pollution-textfield"].text = util.float_to_string(map_settings.enemy_evolution.pollution_factor)
	--Pollution
	local pollution_table = more_config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
	pollution_table["change-map-settings-pollution-checkbox"].state = map_settings.pollution.enabled
	pollution_table["change-map-settings-pollution-diffusion-textfield"].text = tostring(map_settings.pollution.diffusion_ratio * 100)
	pollution_table["change-map-settings-pollution-dissipation-textfield"].text = tostring(map_settings.pollution.ageing)
	pollution_table["change-map-settings-pollution-tree-dmg-textfield"].text = tostring(map_settings.pollution.min_pollution_to_damage_trees)
	pollution_table["change-map-settings-pollution-tree-absorb-textfield"].text = tostring(map_settings.pollution.pollution_restored_per_tree_damage)
	--Enemy expansion
	local expansion_table = more_config_table["change-map-settings-config-more-expansion-flow"]["change-map-settings-config-more-expansion-table"]
	expansion_table["change-map-settings-enemy-expansion-checkbox"].state = map_settings.enemy_expansion.enabled
	expansion_table["change-map-settings-expansion-distance-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_distance)
	expansion_table["change-map-settings-expansion-min-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_min_size)
	expansion_table["change-map-settings-expansion-max-size-textfield"].text = tostring(map_settings.enemy_expansion.settler_group_max_size)
	expansion_table["change-map-settings-expansion-min-cd-textfield"].text = tostring(map_settings.enemy_expansion.min_expansion_cooldown / 3600)
	expansion_table["change-map-settings-expansion-max-cd-textfield"].text = tostring(map_settings.enemy_expansion.max_expansion_cooldown / 3600)
end

-- WOLRD GEN --
local function change_map_settings(player)
	local frame_flow = mod_gui.get_frame_flow(player)
	local more_config_table = frame_flow["change-map-settings-config-more-frame"]["change-map-settings-config-more-table"]
	-- MAP SETTINGS --
	local map_settings = game.map_settings
	--Evolution
	local evo_table = more_config_table["change-map-settings-config-more-evo-flow"]["change-map-settings-config-more-evo-table"]
	map_settings.enemy_evolution.enabled = evo_table["change-map-settings-evolution-checkbox"].state
	local evolution_factor = util.textfield_to_number(evo_table["change-map-settings-evolution-factor-textfield"])
	if evolution_factor and (evolution_factor >= 0) and (evolution_factor <= 1) then
		game.forces["enemy"].evolution_factor = evolution_factor
	else
		player.print({"msg.change-map-settings-invalid-evolution-factor"})
		return false
	end
	local evolution_time = util.textfield_to_number(evo_table["change-map-settings-evolution-time-textfield"])
	if evolution_time and (evolution_time >= 0) and (evolution_time <= 0.0001) then
		map_settings.enemy_evolution.time_factor = evolution_time
	else
		player.print({"msg.change-map-settings-invalid-evolution-time"})
		return false
	end
	local evolution_destroy = util.textfield_to_number(evo_table["change-map-settings-evolution-destroy-textfield"])
	if evolution_destroy and (evolution_destroy >= 0) and (evolution_destroy <= 0.01) then
		map_settings.enemy_evolution.destroy_factor = evolution_destroy
	else
		player.print({"msg.change-map-settings-invalid-evolution-destroy"})
		return false
	end
	local evolution_pollution = util.textfield_to_number(evo_table["change-map-settings-evolution-pollution-textfield"])
	if evolution_pollution and (evolution_pollution >= 0) and (evolution_pollution <= 0.0001) then
		map_settings.enemy_evolution.pollution_factor = evolution_pollution
	else
		player.print({"msg.change-map-settings-invalid-evolution-pollution"})
		return false
	end
	--Pollution
	local pollution_table = more_config_table["change-map-settings-config-more-pollution-flow"]["change-map-settings-config-more-pollution-table"]
	local pollution_enabled = pollution_table["change-map-settings-pollution-checkbox"].state
	if (pollution_enabled ~= map_settings.pollution.enabled) and (pollution_enabled == false) then
		for _, surface in pairs(game.surfaces) do
			surface.clear_pollution()
		end
	end
	map_settings.pollution.enabled = pollution_table["change-map-settings-pollution-checkbox"].state
	local pollution_diffusion = util.textfield_to_uint(pollution_table["change-map-settings-pollution-diffusion-textfield"])
	if pollution_diffusion and (pollution_diffusion >= 0) and (pollution_diffusion <= 25) then
		map_settings.pollution.diffusion_ratio = (pollution_diffusion / 100)
	else
		player.print({"msg.change-map-settings-invalid-pollution-diffusion"})
		return false
	end
	local pollution_dissipation = util.textfield_to_uint(pollution_table["change-map-settings-pollution-dissipation-textfield"])
	if pollution_dissipation and (pollution_dissipation > 0) and (pollution_dissipation <= 1000) then
		map_settings.pollution.ageing = pollution_dissipation
	else
		player.print({"msg.change-map-settings-invalid-pollution-dissipation"})
		return false
	end
	local pollution_tree_dmg = util.textfield_to_uint(pollution_table["change-map-settings-pollution-tree-dmg-textfield"])
	if pollution_tree_dmg and (pollution_tree_dmg >= 0) and (pollution_tree_dmg <= 9999) then
		map_settings.pollution.min_pollution_to_damage_trees = pollution_tree_dmg
	else
		player.print({"msg.change-map-settings-invalid-pollution-tree-dmg"})
		return false
	end
	local pollution_tree_absorb = util.textfield_to_uint(pollution_table["change-map-settings-pollution-tree-absorb-textfield"])
	if pollution_tree_absorb and (pollution_tree_absorb >= 0) and (pollution_tree_absorb <= 9999) then
		map_settings.pollution.pollution_restored_per_tree_damage = pollution_tree_absorb
	else
		player.print({"msg.change-map-settings-invalid-pollution-tree-absorb"})
		return false
	end
	--Enemy expansion
	local expansion_table = more_config_table["change-map-settings-config-more-expansion-flow"]["change-map-settings-config-more-expansion-table"]
	map_settings.enemy_expansion.enabled = expansion_table["change-map-settings-enemy-expansion-checkbox"].state
	local expansion_distance = util.textfield_to_uint(expansion_table["change-map-settings-expansion-distance-textfield"])
	if expansion_distance and (expansion_distance >= 2) and (expansion_distance <= 20) then
		map_settings.enemy_expansion.max_expansion_distance = expansion_distance
	else
		player.print({"msg.change-map-settings-invalid-expansion-distance"})
		return false
	end
	local expansion_min_size = util.textfield_to_uint(expansion_table["change-map-settings-expansion-min-size-textfield"])
	if expansion_min_size and (expansion_min_size >= 1) and (expansion_min_size <= 20) then
		map_settings.enemy_expansion.settler_group_min_size = expansion_min_size
	else
		player.print({"msg.change-map-settings-invalid-expansion-min-size"})
		return false
	end
	local expansion_max_size = util.textfield_to_uint(expansion_table["change-map-settings-expansion-max-size-textfield"])
	if expansion_max_size and (expansion_max_size >= 1) and (expansion_max_size <= 50) then
		if expansion_max_size < map_settings.enemy_expansion.settler_group_min_size then
			player.print({"msg.change-map-settings-too-low-expansion-max-size"})
			return false
		else
			map_settings.enemy_expansion.settler_group_max_size = expansion_max_size
		end
	else
		player.print({"msg.change-map-settings-invalid-expansion-max-size"})
		return false
	end
	local expansion_min_cd = util.textfield_to_uint(expansion_table["change-map-settings-expansion-min-cd-textfield"])
	if expansion_min_cd and (expansion_min_cd >= 1) and (expansion_min_cd <= 60) then
		map_settings.enemy_expansion.min_expansion_cooldown = (expansion_min_cd * 3600)
	else
		player.print({"msg.change-map-settings-invalid-expansion-min-cd"})
		return false
	end
	local expansion_max_cd = util.textfield_to_uint(expansion_table["change-map-settings-expansion-max-cd-textfield"])
	if expansion_max_cd and (expansion_max_cd >= 5) and (expansion_max_cd <= 180) then
		if expansion_max_cd < (map_settings.enemy_expansion.min_expansion_cooldown / 3600) then
			player.print({"msg.change-map-settings-too-low-expansion-max-cd"})
			return false
		else
			map_settings.enemy_expansion.max_expansion_cooldown = (expansion_max_cd * 3600)
		end
	else
		player.print({"msg.change-map-settings-invalid-expansion-max-cd"})
		return false
	end
	for _, player in pairs(game.players) do
		gui.regen(player)
	end
end

script.on_event({defines.events.on_gui_click}, function(event)
	local player = game.players[event.player_index]
	local frame_flow = mod_gui.get_frame_flow(player)
	local clicked_name = event.element.name
	if clicked_name == "change-map-settings-toggle-config" then
		frame_flow["change-map-settings-config-more-frame"].style.visible = not frame_flow["change-map-settings-config-more-frame"].style.visible
	elseif clicked_name == "change-map-settings-use-current-button" then
		if player.admin then
			use_current_map_gen(player)
		else
			player.print({"msg.change-map-settings-start-admin-restriction"})
		end
	elseif clicked_name == "change-map-settings-start-button" then
		change_map_settings(player)
	elseif clicked_name == "change-map-settings-default-button" then
		reset_to_default(player)
	end
end)

script.on_event(defines.events.on_player_created, function(event) --create gui for joining player
	gui.regen(game.players[event.player_index])
end)

script.on_init(function()
	for _, player in pairs(game.players) do
		gui.regen(player)
	end
end)
