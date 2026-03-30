-- RegisterSpawnFunction( 0xffbf26a9, "spawn_runes" )
-- RegisterSpawnFunction( 0xff6b26a6, "spawn_bigtorch" )
dofile( "data/scripts/item_spawnlists.lua" )
dofile_once( "data/scripts/perks/abyss_func.lua" )

function runestone_activate( entity_id )
	local status = 0
	
	local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( variablestorages ~= nil ) then
		for j,storage_id in ipairs(variablestorages) do
			local var_name = ComponentGetValue2( storage_id, "name" )
			if ( var_name == "active" ) then
				status = ComponentGetValue2( storage_id, "value_int" )
				
				status = 1 - status
				
				ComponentSetValue2( storage_id, "value_int", status )
				
				if ( status == 1 ) then
					EntitySetComponentsWithTagEnabled( entity_id, "activate", true )
				else
					EntitySetComponentsWithTagEnabled( entity_id, "activate", false )
				end
			end
		end
	end
end

function spawn_apparition(x, y)
	SetRandomSeed( x, y )
	local PlaceItems1 	= 1
	local PlaceItems2 	= 2
	local Spawn 		= 3

	local level = 0 -- TODO: fetch biome level somehow
	local state,apparition_entity_id = SpawnApparition( x, y, level )

	-- local r = ProceduralRandom(x + 5.352, y - 4.463)
	-- if (r > 0.1) then

	local place_items = function()
		for i=1,4 do
			local rx = x + Random( -10, 10 )
				
			spawn_candles(rx, y)
		end
	end

	if state == PlaceItems1 or state == PlaceItems2 then
		place_items()
		print( tostring(x) .. ", " .. tostring(y) ) -- DEBUG:
	elseif state == Spawn then
		LoadPixelScene( "data/biome_impl/grave.png", "data/biome_impl/grave_visual.png", x-10, y-15, "", true )
		--[[
		GamePrint( "___________________________" )
		GamePrint( "" )
		GamePrint( "A chill runs up your spine!" )
		GamePrint( "___________________________" )
		--]]
		print( tostring(x) .. ", " .. tostring(y) ) -- DEBUG:
	end
end

function spawn_persistent_teleport(x, y)
	--[[
	local r = ProceduralRandom(x + 5.352, y - 4.463)
	if (r > 0.1) then
		local level = 0 -- TODO: fetch biome level somehow
		SpawnPersistentTeleport( x, y )
	end
	]]--
end

function spawn_persistent_teleport(x, y)
	--spawn(g_persistent_teleport,x,y,0,0)
end

function spawn_candles(x, y)
	SetRandomSeed( x, y )
	local rnd = Random( 1, 1000 )
	if (rnd <= 666) then
		spawn(g_candles,x,y,0,0)
	end
end

function spawn_wands(x, y)
	if g_items ~= nil then spawn(g_items,x-5,y,0,0) end
end

function spawn_potions( x, y )
	SetRandomSeed( x, y )
	local rnd = Random( 1, 10000 )
	local chosen = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" ))

	if (rnd <= 4000) and ( chosen < 3 ) then
		spawn_from_list( "potion_spawnlist", x, y )
	elseif (rnd <= 5000) and ( chosen < 3 ) then -- 50.00%
		spawn_from_list( "potion_spawnlist", x+Random(-2,3), y )
	elseif (rnd <= 9000) then -- 40.00%
		spawn_from_list( "potion_spawnlist", x-3, y )
		spawn_from_list( "potion_spawnlist", x+4, y )
	elseif (rnd <= 9350) then -- 3.50%
		EntityLoad( "data/entities/items/pickup/ammo_box.xml", x, y-6 )
	elseif (rnd <= 9700) then -- 3.50%
		EntityLoad( "data/entities/items/pickup/utility_box.xml", x, y-6 )
	elseif (rnd <= 9950) then -- 2.50%
		EntityLoad( "data/entities/items/pickup/speed_run_package.xml", x, y )
	elseif (rnd <= 9999) then -- 0.49%
		EntityLoad( "data/entities/items/pickup/speed_run_package_better.xml", x, y )
	else -- 0.01%
		EntityLoad( "data/entities/items/pickup/potion_mimic.xml", x, y )
	end
end

function spawn_ghostlamp(x, y)
	spawn2(g_ghostlamp,x,y,0,0)
end

function parallel_check( x, y )
	if ( y < 0 ) then
		local pw = GetParallelWorldPosition( x, y )
		
		if ( pw ~= 0 ) then
			local r = ProceduralRandom( x + 35, y - 253 )
			local rx = ProceduralRandom( x - 35, y + 243 )
			
			SetRandomSeed( x + 35, y - 253 )
			
			r = Random( 1, 100 )
			rx = Random( 0, 512 )
			
			if ( r >= 75 ) then
				-- print( "TENTACLE AT " .. tostring( x + rx ) .. ", " .. tostring( y ) )
				local boss = EntityLoad( "data/entities/animals/parallel/tentacles/parallel_tentacles.xml", x + rx, y )

				if not EntityHasTag( boss, "holy_mountain_creature" ) then EntityAddTag( boss, "holy_mountain_creature" ) end

				EntityAddComponent( boss, "LuaComponent", {
					script_damage_about_to_be_received = "data/entities/animals/boss_wizard/orbit/dmg_cap.lua",
					execute_every_n_frame = "-1",
				} )
			end
		end
	end
end

function spawn_mimic_sign( x, y, good )
	impl_raytrace_x = function( x0, y0, x_direction, max_length )
		local hit_something,hit_x,hit_y = Raytrace( x0, y0, x0 + (x_direction * max_length), y0 )
		return hit_x
	end

	local min_x = impl_raytrace_x( x, y, -1, 32 )
	local max_x = impl_raytrace_x( x, y, 1, 32 )

	if ( ( x - min_x ) >= 24 and Raytrace( x - 16, y, x - 16, y - 26 ) == false ) then
		local hit_something, temp_x, max_y = Raytrace( x - 16, y - 25, x - 16, y + 32 )
		LoadPixelScene( "data/biome_impl/mimic_sign.png", "data/biome_impl/mimic_sign_visual.png", min_x, max_y - 23, "", true, true )
	elseif ( ( max_x - x ) >= 24 and Raytrace( x + 16, y, x + 16, y - 26 ) == false ) then
		local hit_something, temp_x, max_y = Raytrace( x + 16, y - 25, x + 16, y + 32 )
		LoadPixelScene( "data/biome_impl/mimic_sign.png", "data/biome_impl/mimic_sign_visual.png", max_x - 22, max_y - 23, "", true, true )
	end

	-- if good then EntityLoad( "data/entities/items/pickup/utility_box.xml", x - 23, y ) end
end


function spawn_heart( x, y )
	local r = ProceduralRandom( x, y )
	SetRandomSeed( x, y )

	local anything_except_heart_spawn_percent = 0.699999

	if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then anything_except_heart_spawn_percent = 1.0 end
	
	local year, month, day = GameGetDateAndTimeLocal()

	if ( month == 2 ) and ( day == 14 ) then anything_except_heart_spawn_percent = anything_except_heart_spawn_percent * 0.5 end

	SetRandomSeed( x+day, y-month ) -- it's harder to replay the same seed

	if ( r > anything_except_heart_spawn_percent ) then
		local rnd = Random( 1, 777 )

		if ( Random( 1, 77 ) <= 7 ) then
			spawn_mimic_sign( x, y, true )
		elseif ( Random( 1, 77 ) <= 17 ) then
			spawn_mimic_sign( x, y, false )
		end
		
		if ( rnd < 7 ) then -- 0.77%
			if GlobalsGetValue( "DEEP_END_REMOVE_FOG_OF_WAR" ) == "t" then
				local entity = EntityLoad( "data/entities/items/pickup/heart.xml", x, y )
			else
				local entity = EntityLoad( "data/entities/animals/illusions/dark_alchemist.xml", x, y )

				EntityRemoveTag( entity, "de_mimic" )
				de_enemy_give_perk( entity )
				EntityAddTag( entity, "de_mimic" )
			end
		elseif ( rnd < 27 ) then -- 2.57%
			local entity = EntityLoad( "data/entities/items/pickup/speed_run_package.xml", x, y+6 )
		elseif ( rnd < 37 ) then -- 1.29%
			local entity = EntityLoad( "data/entities/items/pickup/speed_run_package_better.xml", x, y+6 )
		elseif ( rnd < 750 ) then -- 91.76%
			local entity = EntityLoad( "data/entities/items/pickup/heart.xml", x, y )
		elseif ( rnd < 770 ) then -- 2.57%
			local entity = EntityLoad( "data/entities/items/pickup/heart_better.xml", x, y )
		else -- 1.03%
			local entity = EntityLoad( "data/entities/items/pickup/heart_evil.xml", x, y )
		end
	else
		local rnd = Random( 1, 100 )
		
		if (rnd < 96) or (y < 512 * 5) then
			rnd = Random( 1, 777 )
			
			if ( Random( 1, 37 ) < 7 ) then spawn_mimic_sign( x, y, true )
			elseif ( Random( 1, 37 ) < 17 ) then spawn_mimic_sign( x, y, false ) end

			if ( y < -512 ) then
				local entity = EntityLoad( "data/entities/items/pickup/chest_random_harder_" .. Random(3,7) .. ".xml", x, y )
			elseif ( rnd < 776 ) then
				local entity = EntityLoad( "data/entities/items/pickup/chest_random.xml", x, y )
			else
				local entity = EntityLoad( "data/entities/items/pickup/chest_random_super.xml", x, y )
			end
		else
			rnd = Random( 1, 91 )

			if ( Random( 1, 13 ) < 7 ) then spawn_mimic_sign( x, y, false )
			elseif ( Random( 1, 13 ) == 7 ) then spawn_mimic_sign( x, y, true ) end

			if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) or GlobalsGetValue( "DEEP_END_REMOVE_FOG_OF_WAR" ) == "t" then
				if Random( 1, 40 ) > 20 then
					local entity = EntityLoad( "data/entities/items/pickup/ammo_box.xml", x, y )
				else
					local entity = EntityLoad( "data/entities/items/pickup/utility_box.xml", x, y )
				end
			else
				if ( rnd < 37 ) then
					local entity = EntityLoad( "data/entities/animals/chest_mimic.xml", x, y )

					de_enemy_give_perk( entity )
					EntityAddTag( entity, "de_mimic" )
				else
					local entity = EntityLoad( "data/entities/items/pickup/chest_leggy.xml", x, y )
				end
			end
		end
	end
end

function spawn_potion_altar(x, y)
	local r = ProceduralRandom( x, y )
	
	if (r > 0.96) then
		LoadPixelScene( "data/biome_impl/potion_altar.png", "data/biome_impl/potion_altar_visual.png", x-5, y-15, "", true )
	end
end

function spawn_debug_mark( x,y )
	EntityLoad( "data/entities/_debug/debug_marker.xml", x, y )
end

function spawn_portal( x, y )
	if ( BIOME_NAME == "crypt" ) then
		EntityLoad( "data/entities/buildings/teleport_boss_arena.xml", x, y - 4 )
	else
		EntityLoad( "data/entities/buildings/teleport_liquid_powered.xml", x, y - 4 )
	end
end

function spawn_end_portal( x, y )
	EntityLoad( "data/entities/buildings/teleport_boss_arena.xml", x, y - 4 )
end


function spawn_runes( x, y )
	--EntityLoad( "data/entities/buildings/runes.xml", x, y )
end

function spawn_fullhp(x, y)
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x, y )
end

function spawn_wand_trap( x, y )
	-- print(x)
	-- EntityLoad( "data/entities/buildings/wand_trap_circle_acid.xml", x, y )
	EntityLoad( "data/entities/props/physics_trap_circle_acid.xml", x, y )
end

function spawn_wand_trap_electricity_source( x, y )
	-- print(x)
	EntityLoad( "data/entities/buildings/wand_trap_electricity.xml", x, y )
end

function spawn_wand_trap_electricity( x, y )
	-- print(x)
	EntityLoad( "data/entities/props/physics_trap_electricity.xml", x, y )
end

function spawn_wand_trap_ignite( x, y )
	-- EntityLoad( "data/entities/buildings/wand_trap_ignite.xml", x, y )
	EntityLoad( "data/entities/props/physics_trap_ignite.xml", x, y )
end

function spawn_bigtorch(x, y)
	EntityLoad( "data/entities/props/physics_torch_stand.xml", x, y )
end

function spawn_moon(x, y)
	EntityLoad( "data/entities/buildings/moon_altar.xml", x, y )
end

function spawn_collapse( x, y )
	EntityLoad( "data/entities/misc/loose_chunks.xml", x, y )
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, 10 )
end