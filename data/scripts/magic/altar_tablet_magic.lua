dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )

local tablets = EntityGetWithTag( "tablet" )
local worm_crystals = EntityGetWithTag( "worm_crystal" )
local hand_statues = EntityGetWithTag( "statue_hand" )

-- chest rain is done only once
-- if( GlobalsGetValue("MISC_CHEST_RAIN") ~= "1" ) then
local chests = EntityGetWithTag( "chest" )

if #chests > 0 then
	local collected = 0
	local players = EntityGetWithTag( "player_unit" )
	
	if #players > 0 then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,chest_id in ipairs(chests) do
			local cx, cy = EntityGetTransform( chest_id )
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if distance < 128 and not EntityHasTag( chest_id, "deep_end_rain_chest" ) then
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
				EntityKill( chest_id )

				collected = collected + 1
			end
		end

		if collected > 0 then
			GlobalsSetValue("MISC_CHEST_RAIN", "HAMIS" )
			AddFlagPersistent( "misc_chest_rain" )

			GamePrintImportant( "$log_altar_magic_deep_end_hamis_party", "" )
			EntityAddChild( player_id, EntityLoad("data/entities/misc/what_is_this/hamis_party.xml", px, py) )
		end
	end
end

-- if( GlobalsGetValue("MISC_UTIL_RAIN") ~= "1" ) then
local chests = EntityGetWithTag( "utility_box" )

if #chests > 0 then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	local rain = GlobalsGetValue("MISC_UTIL_RAIN" )
	
	if #players > 0 and #rain < 3 then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,chest_id in ipairs(chests) do
			local cx, cy = EntityGetTransform( chest_id )
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if distance < 128 then
				EntityAddChild( player_id, EntityLoad("data/entities/misc/chest_rain.xml", px, py) )
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)

				EntityKill( chest_id )
				collected = true
			end
		end
	end
	
	if collected then
		GlobalsSetValue("MISC_UTIL_RAIN", GlobalsGetValue("MISC_UTIL_RAIN" ) .. "0" )			
		GamePrintImportant( "$log_altar_magic", "" )
		
		AddFlagPersistent( "misc_util_rain" )
	end
end

-- if( GlobalsGetValue("MISC_SUN_EFFECT") ~= "1" ) then
local suns = EntityGetWithTag( "sunrock" )

if ( #suns > 0 ) then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,chest_id in ipairs(suns) do
			local cx, cy = EntityGetTransform( chest_id )
			
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if ( distance < 72 ) then
				EntityLoad("data/entities/items/pickup/sun/newsun.xml", cx, cy )
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
				collected = true
				EntityKill( chest_id )
			end
		end
	end
	
	if collected then
		GlobalsSetValue("MISC_SUN_EFFECT", "1" )			
		GamePrintImportant( "$log_altar_magic", "" )
		
		AddFlagPersistent( "misc_sun_effect" )
	end
end

-- if( GlobalsGetValue("MISC_DARKSUN_EFFECT") ~= "1" ) then
local suns = EntityGetWithTag( "darksunrock" )

if ( #suns > 0 ) then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,chest_id in ipairs(suns) do
			local cx, cy = EntityGetTransform( chest_id )
			
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if ( distance < 72 ) then
				EntityLoad("data/entities/items/pickup/sun/newsun_dark.xml", cx, cy )
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
				collected = true
				EntityKill( chest_id )
			end
		end
	end
	
	if collected then
		GlobalsSetValue("MISC_DARKSUN_EFFECT", "1" )			
		GamePrintImportant( "$log_altar_magic", "" )
		
		AddFlagPersistent( "misc_darksun_effect" )
	end
end

local greed_crystals = EntityGetWithTag( "greed_crystal" )

if ( #greed_crystals > 0 ) then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,crystal_id in ipairs( greed_crystals ) do
			local cx, cy = EntityGetTransform( crystal_id )
			
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if ( distance < 64 ) then
				if( GlobalsGetValue("MISC_GREED_RAIN") ~= "1" ) then
					local eid = EntityLoad("data/entities/misc/greed_curse/greed_rain.xml", px, py)
					EntityAddChild( player_id, eid )
				else
					local eid = EntityLoad("data/entities/misc/greed_curse/greed_rain_simple.xml", px, py)
					EntityAddChild( player_id, eid )
				end
				
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
				collected = true
				EntityKill( crystal_id )
			end
		end
	end
	
	if collected then
		GlobalsSetValue("MISC_GREED_RAIN", "1" )			
		GamePrintImportant( "$log_altar_magic", "" )
		
		AddFlagPersistent( "misc_greed_rain" )
	end
end

if ( #worm_crystals > 0 ) then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,crystal_id in ipairs(worm_crystals) do
			local cx, cy = EntityGetTransform( crystal_id )
			
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if ( distance < 64 ) then
				local eid = EntityLoad("data/entities/misc/worm_rain.xml", px, py)
				EntityAddChild( player_id, eid )
				collected = true
				EntityKill( crystal_id )
			end
		end
	end
	
	if collected then
		GamePrintImportant( "$log_altar_magic_worm", "" )
		
		AddFlagPersistent( "misc_worm_rain" )
	end
end

if ( #hand_statues > 0 ) then
	local collected = false
	
	for _,statue_id in ipairs(hand_statues) do
		local cx, cy = EntityGetTransform( statue_id )
		
		if ( get_distance(x, y, cx, cy) < 64 ) then
			collected = true
			-- spawn bots with monk arms in a circle formation
			local count = 12
			local spawn_x = 400
			local spawn_y = 0
			local rot_inc = math.pi * 2 / count

			for i=1,count do
				local eid = EntityLoad("data/entities/animals/drone_lasership.xml", x + spawn_x, y + spawn_y)
				local arms = EntityLoad("data/entities/misc/monk_arms_standalone.xml", x + spawn_x, y + spawn_y)

				EntityAddChild( eid, arms )
				spawn_x, spawn_y = vec_rotate(spawn_x, spawn_y, rot_inc)
			end
			-- statue disappears
			EntityKill(statue_id)
			EntityLoad("data/entities/buildings/statue_hand_fx.xml", cx, cy)
		end
	end

	if collected then
		GamePrintImportant( "$log_altar_magic_monster", "" )
		AddFlagPersistent( "misc_monk_bots" )
	end
end

if ( #tablets > 0 ) then
	local collected = false
	
	local tx = 0
	local ty = 0
	for i,tablet_id in ipairs(tablets) do
		local in_world = false
		local components = EntityGetComponent( tablet_id, "PhysicsBodyComponent" )
		
		if( components ~= nil ) then
			in_world = true
		end
		
		tx, ty = EntityGetTransform( tablet_id )
		SetRandomSeed( tx+236, ty-4125 )
		
		if in_world then
			local distance = math.abs(x - tx) + math.abs(y - ty)
		
			if ( distance < 56 ) then
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", tx, ty)
				EntityConvertToMaterial( tablet_id, "gold")
				collected = true
				EntityKill( tablet_id )
			end
		end
	end
	
	if collected then
		local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
		local tablets_eaten = 0
		
		if( variablestorages ~= nil ) then
			for i,variablestorage in ipairs(variablestorages) do
				if ( ComponentGetValue2( variablestorage, "name" ) == "tablets_eaten" ) then
					tablets_eaten = ComponentGetValueInt( variablestorage, "value_int" )
					
					tablets_eaten = tablets_eaten + 1

					ComponentSetValue( variablestorage, "value_int", tablets_eaten )
				end
			end
		end
		
		local spawn_monster = false
		
		if ( tablets_eaten > 1 ) then
			spawn_monster = true
			EntityLoad( "data/entities/animals/boss_limbs/boss_limbs.xml", x, y )
			
			AddFlagPersistent( "misc_altar_tablet" )
		end
		
		if ( spawn_monster == false ) then
			GamePrintImportant( "$log_altar_magic", "" )
		else
			EntityLoad("data/entities/particles/image_emitters/altar_tablet_curse_symbol.xml", tx, ty)
			GamePrintImportant( "$log_altar_magic_monster", "" )
		end
	end
end

-- fish rain
-- if( GlobalsGetValue("MISC_FISH_RAIN") ~= "1" ) then
local animals = EntityGetInRadiusWithTag( x, y, 128, "helpless_animal" )

if ( #animals > 0 ) then

	-- for i,animal in ipairs(animals) do
	-- if EntityGetFirstComponent( animal, "AdvancedFishAIComponent" ) == nil then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )

		for i,fish in ipairs(animals) do
			if( EntityGetFirstComponent( fish, "AdvancedFishAIComponent" ) ~= nil ) then
				local fx, fy = EntityGetTransform( fish )
				local distance = math.abs( x - fx ) + math.abs( y - fy )
			
				if ( distance < 64 ) then
					if( collected == false ) then
						local eid = EntityLoad("data/entities/misc/fish_rain.xml", px, py)
						EntityAddChild( player_id, eid )
						EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", fx, fy)
					end
					collected = true
					EntityKill( fish )
				end
			end
		end
	end
	
	if collected then
		GamePrintImportant( "$log_altar_magic_worm", "" )
		GlobalsSetValue("MISC_FISH_RAIN", "1" )			
		AddFlagPersistent( "misc_fish_rain" )
	end
end

-- potion mimic rain
-- if( GlobalsGetValue("MISC_MIMIC_POTION_RAIN") ~= "1" ) then
local animals = EntityGetInRadiusWithTag( x, y, 128, "mimic_potion" )
local mat_mimic = CellFactory_GetType( "mimic_liquid")

if ( #animals > 0 ) then

	-- for i,animal in ipairs(animals) do
	-- if EntityGetFirstComponent( animal, "AdvancedFishAIComponent" ) == nil then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )

		for i,animal in ipairs(animals) do
			local fx, fy = EntityGetTransform( animal )
			local distance = math.abs( x - fx ) + math.abs( y - fy )
		
			local mat = GetMaterialInventoryMainMaterial( animal )
			local alive = (mat == mat_mimic)
			local from_sky = EntityHasTag( animal, "mimic_potion_sky" )

			if ( distance < 64 and alive and EntityGetParent( animal ) == NULL_ENTITY ) then
				if( collected == false ) then
					local eid = EntityLoad("data/entities/misc/mimic_potion_rain.xml", px, py)
					if from_sky then
						EntityAddTag( eid, "mimic_potion_sky" )
					end
					EntityAddChild( player_id, eid )
					EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", fx, fy)
				end
				collected = true
				EntityKill( animal )
			end
		end
	end
	
	if collected then
		GamePrintImportant( "$log_altar_magic_worm", "" )
		GlobalsSetValue("MISC_MIMIC_POTION_RAIN", "1" )			
		AddFlagPersistent( "misc_mimic_potion_rain" )
	end
end

local gourd = EntityGetInRadiusWithTag( x, y, 128, "gourd" )

if #gourd > 0 then
	local players = EntityGetWithTag( "player_unit" )
	local dropped = false

	for i,animal in ipairs(gourd) do if EntityGetRootEntity(animal) == animal then dropped = true end end

	if #players > 0 and dropped then
		local eid = EntityLoad("data/entities/animals/statue.xml", x + Random( -50, 50 ), y + 200 )
		if not EntityHasTag( eid, "robot" ) then EntityAddTag( eid, "robot" ) end

		EntityAddChild( eid, EntityLoad("data/entities/misc/monk_arms_standalone.xml", x, y + 200 ) )
		EntityAddChild( eid, EntityLoad("data/entities/misc/effect_de_personal_laser_permanent.xml", x, y + 200 ) )

		for i=1,12 do
			eid = EntityLoad("data/entities/animals/statue.xml", x + Random( -50, 50 ), y + 150 )
			if not EntityHasTag( eid, "robot" ) then EntityAddTag( eid, "robot" ) end

			EntityAddChild( eid, EntityLoad("data/entities/misc/monk_arms_standalone.xml", x, y + 150 ) )
			EntityAddChild( eid, EntityLoad("data/entities/misc/effect_de_personal_laser_permanent.xml", x, y + 150 ) )
		end
			
		EntityAddComponent( eid, "LuaComponent", 
		{
			script_death="data/scripts/animals/mr_fox_death.lua",
			execute_every_n_frame="-1",
			remove_after_executed="0",
		} )

		EntityLoad("data/entities/buildings/statue_hand_fx.xml", x, y)
		for i,animal in ipairs(gourd) do EntityKill( animal ) end
	end
end

local deep_end_wall_chest = EntityGetInRadiusWithTag( x, y, 128, "deep_end_wall_chest" )

if ( #deep_end_wall_chest > 0 ) then
	EntityLoad("data/entities/items/pickup/chest_random_super.xml", x, y )
	EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)

	GamePrintImportant( "$log_altar_magic", "" )
	-- don't celebrate too soon, be careful of hamis!
	for i,animal in ipairs(deep_end_wall_chest) do EntityKill( animal ) end
end

local deep_end_drone_physics_hell = EntityGetInRadiusWithTag( x, y, 128, "deep_end_drone_physics_hell" )

if ( #deep_end_drone_physics_hell > 0 ) then
	local players = EntityGetWithTag( "player_unit" )

	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )

		local boss_pl = EntityLoad("data/entities/animals/boss_robot/boss_robot.xml", px-128, py)
		if not EntityHasTag( boss_pl, "holy_mountain_creature" ) then EntityAddTag( boss_pl, "holy_mountain_creature" ) end
		
		boss_pl = EntityLoad("data/entities/animals/boss_meat/boss_meat.xml", px+128, py)
		if not EntityHasTag( boss_pl, "holy_mountain_creature" ) then EntityAddTag( boss_pl, "holy_mountain_creature" ) end

		GamePrintImportant( "$log_altar_magic_deep_end_boss_summon", "" )
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", px-16, py )
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", px+16, py )
		GameScreenshake( 120 )

		for i,animal in ipairs(deep_end_drone_physics_hell) do EntityKill( animal ) end
	end
end

local deep_end_super_fish = EntityGetInRadiusWithTag( x, y, 128, "super_fish" )

if ( #deep_end_super_fish > 0 ) then
	local players = EntityGetWithTag( "player_unit" )

	if ( #players > 0 ) then
		EntityLoad( "data/entities/animals/boss_fish/mini/fish_giga.xml", 2300, 350 )

		GameScreenshake( 120 )
		GamePrintImportant( "$log_altar_magic_deep_end_boss_summon", "" )
		
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", 2300, 400 )
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", x, y )

		for i,animal in ipairs(deep_end_super_fish) do EntityKill( animal ) end

		for i,pid in ipairs(players) do
			local px, py = EntityGetTransform( player_id )

			EntitySetTransform( pid, 2300, 200 )
			--EntityApplyTransform( pid, 2300, 200 )
		end
	end
end

local deep_end_chaos = EntityGetInRadiusWithTag( x, y, 64, "chaos_frankenstein" )

if ( #deep_end_chaos > 0 ) then
	GamePrintImportant( "$log_altar_magic_deep_end_chaos", "" )
	for i,animal in ipairs(deep_end_chaos) do EntityKill( animal ) end
end

local deep_end_bin_gold = EntityGetInRadiusWithTag( x, y, 64, "deep_end_bin_gold" )

if ( #deep_end_bin_gold > 0 ) then
	local players = EntityGetWithTag( "player_unit" )

	if ( #players > 0 ) then
		local tip_do_print = false
		for i,animal in ipairs(players) do
			if not EntityHasTag( animal, "de_map_tp" ) then
				tip_do_print = true

				EntityAddTag( animal, "de_map_tp" )
			end
		end

		for i,animal in ipairs(deep_end_bin_gold) do EntityKill( animal ) end

		if tip_do_print then GamePrintImportant( "$deep_end_map_tele_1", "$deep_end_map_tele_2", "data/ui_gfx/decorations/next_ng.png" ) end
	end
end