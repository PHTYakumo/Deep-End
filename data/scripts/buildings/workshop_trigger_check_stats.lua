dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/game_helpers.lua" )

function DEEP_END_spawn_card( name, x, y )
	local eid = CreateItemActionEntity( name, x, y )

	EntitySetTransform( eid, x, y, 0, 0.762, 0.762 )
	EntityApplyTransform( eid, x, y, 0, 0.762, 0.762 )

	EntityAddComponent( eid, "ItemCostComponent", 
	{ 
		_tags="shop_cost,enabled_in_world", 
		cost="0",
		stealable="0",
	} )

	EntityAddComponent( eid, "LuaComponent",
	{ 
		_tags="enabled_in_world",
		script_source_file="data/scripts/items/shop_item_breath.lua",
		execute_every_n_frame="2",
	} )
end

function DEEP_END_speed_run_bonus( x, y, better )
	local giant_dollar = load_gold_entity( "data/entities/items/pickup/blood_dollar.xml", x-75, y-64, true )
	local dollar_comps = EntityGetComponent( giant_dollar, "VariableStorageComponent" )
	local money = 600

	local package = nil

	if ( better ) then
		package = EntityLoad( "data/entities/items/pickup/speed_run_package_better.xml", x+194, y )
		money = 8000
		if ( y > 15000 ) then money = 12000 end
	else
		package = EntityLoad( "data/entities/items/pickup/speed_run_package.xml", x+194, y )
	end

	EntityAddTag( package, "item_shop" )

	if ( dollar_comps ~= nil ) then
		for i,comp in ipairs( dollar_comps ) do
			local n = ComponentGetValue2( comp, "name" )

			if ( n == "gold_value" ) then
				ComponentSetValue2( comp, "value_int", money )
			elseif ( n == "hp_value" ) then
				ComponentSetValue2( comp, "value_float", math.floor( y * 0.001 ) )
			end
		end
	end

	return package 
end

function check_speed_run( time, depth, x, y ) --[[ Why not use GameGetRealWorldTimeSinceStarted()? ]]--
	local player_entity = EntityGetClosestWithTag( x, y, "player_unit")

	time = math.ceil( math.max( time, tonumber(StatsGetValue("playtime")) - 0.5 ) * 100 ) / 100

	local ddl
	local next_ddl
	local stage

	if ( depth > 1536 ) and ( depth < 2048 ) then
		ddl = 90
		next_ddl = 210
		stage = 1

		if ( time<=ddl ) then
			-- DEEP_END_spawn_card( "SLOW_BULLET", x, y )
			-- DEEP_END_spawn_card( "DE_HOOK_V2", x, y )
			-- EntityLoad( "data/entities/items/pickup/potion_movement_faster.xml", x+194, y-1 )
			EntityLoad( "data/entities/items/wands/for_speed_run_1.xml", x, y )

			local package = DEEP_END_speed_run_bonus( x, y, false )
			EntityAddTag( package, "give_potion" )
		end

	elseif ( depth > 4608 ) and ( depth < 5120 ) then
		ddl = 210
		next_ddl = 300
		stage = 2

		if ( time<=ddl ) then
			DEEP_END_spawn_card( "HEAVY_SPREAD", x-6, y )
			DEEP_END_spawn_card( "DIGGER", x+6, y )

			DEEP_END_speed_run_bonus( x, y, false )
		end

	elseif ( depth > 8704 ) and ( depth < 9216 ) then
		ddl = 300
		next_ddl = 390
		stage = 3

		if ( time<=ddl ) then
			DEEP_END_spawn_card( "SPEED", x-6, y )
			DEEP_END_spawn_card( "TELEPORT_PROJECTILE", x+6, y )

			DEEP_END_speed_run_bonus( x, y, true )
		end

	elseif ( depth > 13824 ) and ( depth < 14336 ) then
		ddl = 390
		next_ddl = 495
		stage = 4

		if ( time<=ddl ) then
			DEEP_END_spawn_card( "ACCELERATING_SHOT", x-6, y )
			DEEP_END_spawn_card( "BLACK_HOLE", x+6, y )
			-- ENERGY_SHIELD
			DEEP_END_speed_run_bonus( x, y, true )
		end

	elseif ( depth > 19456 ) and ( depth < 19968 ) then
		ddl = 495
		next_ddl = 600
		stage = 5
		
		if ( time<=ddl ) then
			-- DEEP_END_spawn_card( "LONG_DISTANCE_CAST", x, y )
			-- DEEP_END_spawn_card( "LIFETIME_DOWN", x, y )
			-- EntityLoad( "data/entities/items/pickup/potion_polymorph_protection.xml", x+194, y-1 )
			EntityLoad( "data/entities/items/wands/for_speed_run_2.xml", x, y )

			local package = DEEP_END_speed_run_bonus( x, y, true )
			EntityAddTag( package, "give_potion" )
		end

	elseif ( depth > 25600 ) and ( depth < 26112 ) then
		ddl = 600
		next_ddl = 720
		stage = 6

		if ( time<=ddl ) then
			DEEP_END_spawn_card( "MATTER_EATER", x-6, y )
			DEEP_END_spawn_card( "PIPE_BOMB", x+6, y )

			DEEP_END_speed_run_bonus( x, y, true )
		end

	elseif ( depth > 32256 ) and ( depth < 32768 ) then
		ddl = 720
		stage = 7

		if ( time<=ddl ) then
			DEEP_END_spawn_card( "LAVA_TO_BLOOD", x-6, y )
			DEEP_END_spawn_card( "BLOOD_TO_ACID", x+6, y )

			DEEP_END_speed_run_bonus( x, y, true )

			if ( not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
				EntityAddTag( player_entity, "speed_runner_in_deep_end" )
			end
		end
	end

	local text_s = GameTextGetTranslatedOrNot("$speed_run_broadcast_0")
	local text_a = GameTextGetTranslatedOrNot("$speed_run_broadcast_1") .. tostring( time ) .. text_s
	text_a = text_a .. " / " .. GameTextGetTranslatedOrNot("$speed_run_broadcast_2") .. tostring( ddl ) .. text_s
	
	GamePrint( text_a )

	if ( time <= 720 ) then
		text_a = GameTextGetTranslatedOrNot("$speed_run_broadcast_3")
		text_a = text_a .. tostring( next_ddl ) .. text_s

		if ( depth > 32000 ) then
			text_a = GameTextGetTranslatedOrNot("$speed_run_final_stage") 
		elseif ( depth < 32000 ) and ( next_ddl > time ) then
			text_s = GameTextGetTranslatedOrNot("$speed_run_broadcast_4")
			text_a = text_a .. " ( " .. tostring( next_ddl - time ) .. text_s
		end

		GamePrint( text_a )
	end

	return stage
end

--[[

stage	depth		chunk		total		interval
1->2	1910		3.5			90 			90
2->3	4982		9.5			210 		120
3->4	9078		17.5		300 		90
4->5	14198		27.5		390 		90
5->6	19830		38.5		495 		105
6->7	25974		50.5		600			105
7->8	32630		63.5		720 		120

]]--

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	local tc_factor = 24 * 60 * 0.46673621460507444389576775117977 --[[ Time correction factor calculated by @Tsumugi·Wenders ]]--

	local world_entity_id = GameGetWorldStateEntity()
	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
	local costs = 8
	
	if ( world_entity_id ~= nil ) and ( newgame_n == 0 ) then
		local comp_worldstate = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" )

		if ( comp_worldstate ~= nil ) then
			local time_speed = ComponentGetValue2( comp_worldstate, "time_dt" )
			local time_total = ComponentGetValue2( comp_worldstate, "time_total" )

			local adjusted_time = time_total * tc_factor / time_speed
			
			if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
				if ( y > 30000 ) then GamePrint( "$speed_run_final_stage_mania" ) end
			else
				costs = check_speed_run( adjusted_time, y, x-93, y+41 ) -- StatsGetValue("playtime")
			end
		end
	end

	-- Note! 
	--  * For global stats use StatsGetValue("enemies_killed")
	--  * For biome stats use StatsBiomeGetValue("enemies_killed")
	--
	-- the difference is that StatsBiomeGetValue() tracks the stats diff since calling StatsResetBiome()
	-- which is what workshop_exit calls
	--
	--
	-- this does the workshop rewards for playing in a certain way
	-- 1) killed none

	local year, month, day = GameGetDateAndTimeLocal()
	day = year + month + day + costs

	if GameHasFlagRun( "deep_end_wealth_perk_curse" ) then 
		GameRemoveFlagRun( "deep_end_wealth_perk_curse" )
	elseif ( costs < 7 ) then
		local eid = EntityLoad( "data/entities/items/pickup/chest_random_harder_" .. tostring( day % 2 + 1 ) .. ".xml", x-73, y-22 )
		-- change_entity_ingame_name( eid, "$item_chest_treasure_pacifist" )
		if GlobalsGetValue( "TEMPLE_PEACE_WITH_GODS" ) ~= "1" then
			costs = 40 * 4^costs
			costs = tostring(costs)
			
			costs = math.floor( tonumber(costs) * 0.1^(#costs-1) ) * 10^(#costs-1)
			costs = tostring(costs)

			EntityAddTag( eid, "item_shop" )

			EntityAddComponent( eid, "ItemCostComponent", 
			{ 
				cost=costs,
			} )

			EntityAddComponent( eid, "SpriteComponent", 
			{ 
				_tags="shop_cost,enabled_in_world",
				image_file="data/fonts/font_pixel_white.xml",
				is_text_sprite="1",
				offset_x=tostring( #costs * 2.45 + 1.4 ),
				offset_y="15",
				update_transform="1",
				update_transform_rotation="1",
				text=costs,
				z_index="-1",
			} )
		end
	end

	-- local enemies_killed = tonumber( StatsBiomeGetValue("enemies_killed") )
	-- print(enemies_killed)
end