function get_vaild_hp_scale( n )
	local hp_scale = 2 + n*2 + n^1.5
	if n < 0 then hp_scale = 1/( n^2 * 0.1 - n ) end
	return hp_scale
end

function DEEP_END_do_newgame_any_dimension( newgame )
	local pre_newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	local newgame_n = newgame
	local trip = newgame_n - pre_newgame_n

	if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) and newgame ~= 0 then newgame_n = 10000 end 

	SessionNumbersSetValue( "NEW_GAME_PLUS_COUNT", newgame_n )
	SessionNumbersSetValue( "DESIGN_SCALE_ENEMIES", "1" )

	local hp_attack_speed,hp_scale = 1,1,1

	if newgame_n > -100 and newgame_n < 100 then
		hp_attack_speed = clamp( 0.7^newgame_n, 0.0000015, 500000 )
		hp_scale = get_vaild_hp_scale( newgame_n )
	elseif newgame_n >= 100 then
		hp_attack_speed = 0.0000015
		hp_scale = 1200
	elseif newgame_n <= -100 then
		hp_attack_speed = 500000
		hp_scale = 0.0009
	end

	SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MIN", hp_scale )
	SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_HP_SCALE_MAX", hp_scale )
	SessionNumbersSetValue( "DESIGN_NEW_GAME_PLUS_ATTACK_SPEED", hp_attack_speed )

	local player_entity = EntityGetClosestWithTag( 0, 0, "player_unit")

	EntityAddChild( player_entity, EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml" ) )
	EntityAddChild( player_entity, EntityLoad( "data/entities/misc/effect_blindness_immediate.xml" ) )

	local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )
	if damagemodels ~= nil then
		for i,damagemodel in ipairs(damagemodels) do
			local mult = clamp( trip, -15, 15 )
			local ceiling = clamp( newgame, -15, 15 )

			local damage_multipliers_list = 
			{
				"projectile",
				"explosion",
				"electricity",
				"fire",
				"ice",
				"radioactive",
				"poison",
				"drill",
				"slice",
				"melee",
				"healing",
				"physics_hit"
			}
			
			for i=1,#damage_multipliers_list do
				local damage_multipliers_mult = ComponentObjectGetValue2( damagemodel, "damage_multipliers", damage_multipliers_list[i] )
				damage_multipliers_mult = clamp( damage_multipliers_mult * 2^mult, 0, 2^ceiling )
				ComponentObjectSetValue2( damagemodel, "damage_multipliers", damage_multipliers_list[i], damage_multipliers_mult )
			end
		end
	end

	local text = GameTextGetTranslatedOrNot("$deep_end_new_game_")

	if newgame_n < -9999 or newgame_n > 9999 then
		text = text .. " ?"
		if newgame_n < 0 then text = text .. "??" end

		GamePrintImportant( text, "$deep_end_new_game_for_newgame_over", "data/ui_gfx/decorations/next_ng.png" )
		BiomeMapLoad_KeepPlayer( "data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml" )
	elseif newgame_n > 0 then
		text = text .. "+"
		if newgame_n > 1 then text = text .. tostring(newgame_n) end

		GamePrintImportant( text, " ", "data/ui_gfx/decorations/next_ng.png" )

		if newgame_n ~= 55 then
			BiomeMapLoad_KeepPlayer( "data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml" )
		else
			BiomeMapLoad_KeepPlayer( "data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes.xml" )
		end
	elseif newgame_n < 0 then
		text = text .. "-"
		if math.abs( newgame_n ) > 1 then text = text .. tostring(math.abs(newgame_n)) end

		GamePrintImportant( text, "$deep_end_new_game_for_newgame_minus", "data/ui_gfx/decorations/next_ng.png" )
		
		if newgame_n ~= -579 then
			BiomeMapLoad_KeepPlayer( "data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes.xml" )
		else
			BiomeMapLoad_KeepPlayer( "data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml" )
		end
	elseif newgame_n == 0 then
		text = text .. "0"

		GamePrintImportant( text, "$deep_end_new_game_for_newgame_zero", "data/ui_gfx/decorations/next_ng.png" )
		BiomeMapLoad_KeepPlayer( "data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes.xml" )
	end

	GamePrint( "$dAbyss_1" )
	SessionNumbersSave()
end

function do_newgame_plus()
	-- GameDoEnding2()
	-- BiomeMapLoad( "mods/nightmare/files/biome_map.lua" )

	local pre_newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	local newgame_n = pre_newgame_n + 1
	-- print( newgame_n )

	SessionNumbersSetValue( "NEW_GAME_PLUS_COUNT", newgame_n )
	DEEP_END_do_newgame_any_dimension( newgame_n )
end

--[[
	damage_multipliers of player can be in chaos
]]--