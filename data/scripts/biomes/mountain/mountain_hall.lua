-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 8
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biomes/mountain/mountain.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk.lua" )

function spawn_wands( x, y ) end
function spawn_potions( x, y ) end

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffFF5A00, "spawn_crate" )
RegisterSpawnFunction( 0xffFF2D00, "spawn_waterspout" )
RegisterSpawnFunction( 0xffFF5A0A, "spawn_f_trigger" )
RegisterSpawnFunction( 0xffFF5A0B, "spawn_i_trigger" )
RegisterSpawnFunction( 0xffFF5A0C, "spawn_f" )
RegisterSpawnFunction( 0xffFF5A0D, "spawn_i" )
RegisterSpawnFunction( 0xffFF5A1A, "spawn_inventory" )
RegisterSpawnFunction( 0xffFF5A1B, "spawn_inventory_trigger" )
RegisterSpawnFunction( 0xffff5a0f, "spawn_music_trigger" )
RegisterSpawnFunction( 0xff33934c, "spawn_all_shopitems" )

g_small_enemies_helpless =
{
	total_prob = 2,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/sheep.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/deer.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/elk.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 5,    
		entity 	= "data/entities/animals/duck.xml"
	},
}

g_cartlike =
{
	total_prob = 2,
	{
		prob   		= 0.0,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= ""
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -3,    
		entity 	= "data/entities/props/physics_box_harmless_small.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -100,
		entity 	= "data/entities/props/physics_chandelier.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -1600,    
		entity 	= "data/entities/props/physics_logo.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -7,    
		entity 	= "data/entities/props/physics_skateboard.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -25,    
		entity 	= "data/entities/props/physics_stone_05.xml"
	},
}

function init( x, y, w, h )
	if GameGetIsGamepadConnected() then
		LoadPixelScene( "data/biome_impl/mountain/hall.png", "data/biome_impl/mountain/hall_visual.png", x, y, "data/biome_impl/mountain/hall_background_gamepad_updated.png", true )
	else
		LoadPixelScene( "data/biome_impl/mountain/hall.png", "data/biome_impl/mountain/hall_visual.png", x, y, "data/biome_impl/mountain/hall_background.png", true )
	end
	
	LoadPixelScene( "data/biome_impl/mountain/hall_instructions.png", "", x, y, "", true )
	
	LoadPixelScene( "data/biome_impl/mountain/hall_b.png", "data/biome_impl/mountain/hall_b_visual.png", x, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/hall_br.png", "data/biome_impl/mountain/hall_br_visual.png", x+512, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/hall_r.png", "data/biome_impl/mountain/hall_r_visual.png", x+512, y, "", true )
	LoadPixelScene( "data/biome_impl/mountain/hall_bottom.png", "", x-512, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain/hall_bottom_2.png", "", x+552, y+512, "", true )
	
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_pixelscene.xml", x+139, y+300, x+175, y+281)
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_pixelscene.xml", x+302, y+341, x+348, y+345)
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_pixelscene.xml", x+325, y+342, x+374, y+371)
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_long_pixelscene.xml", x+216, y+278, x+272, y+314)
	
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_short_pixelscene.xml", x+243, y+285)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_short_pixelscene.xml", x+281, y+325)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_short_pixelscene.xml", x+356, y+354)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_shorter_pixelscene.xml", x+184, y+276)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_shorter_pixelscene.xml", x+286, y+331)
end

function spawn_small_enemies(x, y) end

function spawn_crate(x, y)
	spawn(g_cartlike,x,y)
end

function spawn_waterspout(x, y)
	EntityLoad("data/entities/props/dripping_water.xml", x, y)
end

function spawn_chest(x, y)
	--EntityLoadCameraBound( "data/entities/items/building_chest_stash.xml", x, y )
	-- entity_load("data/entities/items/building_chest_stash.xml")
	-- entity_load_chest(x,y,"chest_tutorial",8)
end

function spawn_f( x, y )
	if (GameGetIsGamepadConnected() == false) then
		EntityLoad( "data/entities/particles/image_emitters/controls_f.xml", x, y )
	else
		EntityLoad( "data/entities/particles/image_emitters/controls_stickpress.xml", x+1, y )
	end
end

function spawn_i( x, y )
	if (GameGetIsGamepadConnected() == false) then
		EntityLoad( "data/entities/particles/image_emitters/controls_i.xml", x, y )
	else
		EntityLoad( "data/entities/particles/image_emitters/controls_back.xml", x-1, y+1 )
	end
end

function spawn_inventory( x, y )
	if (GameGetIsGamepadConnected() == false) then
		EntityLoad( "data/entities/particles/image_emitters/controls_inventory.xml", x, y )
	else
		EntityLoad( "data/entities/particles/image_emitters/controls_inventory_gamepad.xml", x, y )
	end
end

function spawn_f_trigger( x, y )
	EntityLoad( "data/entities/buildings/controls_f_trigger.xml", x, y )
end

function spawn_i_trigger( x, y )
	EntityLoad( "data/entities/buildings/controls_i_trigger.xml", x, y )
end

function spawn_inventory_trigger( x, y )
	EntityLoad( "data/entities/buildings/controls_inventory_trigger.xml", x, y )
end

function spawn_music_trigger( x, y )
	EntityLoad( "data/entities/buildings/music_trigger_mountain_hall.xml", x, y )
end

function spawn_all_perks( x, y )
	SetRandomSeed( x, y )

	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )

	if ( newgame_n == 0 ) then
		local crnd = Random( 0, 100 ) -- 101
		if ModSettingGet( "DEEP_END.ORIGINAL_SPELLS" ) then crnd = Random( 0, 90 ) end

		if ( crnd <= 26 ) then
			CreateItemActionEntity( "DE_SOAHC_ARC_PASSIVE", x - 19, y + 7 )
		elseif ( crnd <= 54 ) then
			CreateItemActionEntity( "DE_FLOATING_WANNO", x - 19, y + 7 )
		elseif ( crnd <= 75 ) then
			CreateItemActionEntity( "DE_SNIPERSCOPE", x - 19, y + 7 )
		elseif ( crnd <= 90 ) then
			CreateItemActionEntity( "SWARM_WASP", x - 19, y + 7 )
		else
			CreateItemActionEntity( "SWARM_FLY", x - 19, y + 7 )
		end

		crnd = Random( 0, 100 ) -- 101

		if ( crnd <= 19 ) then
			CreateItemActionEntity( "DE_ENERGY_SHIELD_POD", x + 24, y - 63 )
		elseif ( crnd <= 38 ) then 
			CreateItemActionEntity( "DE_ENERGY_SHIELD_BACK", x + 24, y - 63 )
		elseif ( crnd <= 57 ) then 
			CreateItemActionEntity( "ENERGY_SHIELD_SECTOR", x + 24, y - 63 )
		elseif ( crnd <= 80 ) then 
			CreateItemActionEntity( "ENERGY_SHIELD", x + 24, y - 63 )
		else
			CreateItemActionEntity( "DE_ENERGY_SHIELD_SATELLITE", x + 24, y - 63 )
			CreateItemActionEntity( "DE_ENERGY_SHIELD_SATELLITE", x + 24, y - 63.5 )
			CreateItemActionEntity( "DE_ENERGY_SHIELD_SATELLITE", x + 24, y - 64 )
		end

		crnd = Random( 0, 100 ) -- 101

		if ( crnd <= 0 ) then
			CreateItemActionEntity( "TORCH_ELECTRIC", x - 29, y + 7 )
		elseif ( crnd <= 28 ) then
			CreateItemActionEntity( "DE_DEATH_RAY_TORCH", x - 29, y + 7 )
		elseif ( crnd <= 56 ) then
			CreateItemActionEntity( "DE_GHOSTY_TORCH", x - 29, y + 7 )
		else
			CreateItemActionEntity( "TORCH", x - 29, y + 7 )
		end

		EntityLoad( "data/entities/props/physics_barrel_burning_starting.xml", 820, -90 )
	end

	if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
		local hoh_f = math.floor( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL_FACTOR" ) + 0.5 )
		local str_hf = "level:" .. tostring(hoh_f)
		
		if hoh_f > 40 then str_hf = "level:error!" end

		SetRandomSeed( y + hoh_f, x + newgame_n )

		local rnd = 0
		local starting_perk
		local opts = { "PROTECTION_EXPLOSION", "PROTECTION_MELEE", "PROTECTION_ELECTRICITY", "PROTECTION_FIRE", "PROTECTION_RADIOACTIVITY" }
	
		for i=1,5 do
			rnd = Random( 1, #opts )
			starting_perk = perk_spawn( x + 9 + 20 * ( i - 1 ), y - 2, opts[rnd], true )

			EntityAddComponent( starting_perk, "LuaComponent", 
			{ 
				script_item_picked_up="data/scripts/perks/perk_choose_one.lua", -- script_death ?
			} )

			EntityAddTag( starting_perk, "perk_choose_one")
			table.remove( opts, rnd )
		end

		if ( math.abs(x) < 10000 ) then
			opts = { "REMOVE_FOG_OF_WAR", "UNLIMITED_SPELLS", "NO_MORE_SHUFFLE" }

			for i=1,3 do
				rnd = Random( 1, #opts )

				local hoh_perk = perk_spawn( x -464 + 20 * ( i - 1 ), y + 6, opts[rnd], true )
				local hoh_perk_itemcomp = EntityGetFirstComponent( hoh_perk, "ItemComponent" )

				ComponentSetValue2( hoh_perk_itemcomp, "auto_pickup", true )
				table.remove( opts, rnd )
			end
		end

		local rid = EntityLoad( "data/entities/items/pickup/perk_reroll.xml", x - 465, y + 50 )
		local reroll_comp = EntityGetFirstComponent( rid, "ItemCostComponent" )	

		if ( reroll_comp ~= nil ) then EntitySetComponentIsEnabled( rid, reroll_comp, false ) end

		reroll_comp = EntityGetComponent( rid, "SpriteComponent", "shop_cost" )
		
		if ( reroll_comp ~= nil ) then
			for a,b in ipairs( reroll_comp ) do
				EntitySetComponentIsEnabled( rid, b, false )
			end
		end
		
		EntitySetComponentsWithTagEnabled( rid, "perk_reroll_disable", false )

		EntityAddComponent2( rid, "SpriteComponent",
		{
			_tags="enabled_in_world",
			image_file="data/fonts/font_pixel_white.xml", 
			is_text_sprite=true, 
			offset_x=1.5*(#str_hf+0.6), 
			offset_y=19.5, 
			update_transform=true, 
			update_transform_rotation=false,
			text = str_hf, 
			has_special_scale=true,
			special_scale_x=0.9,
			special_scale_y=0.9,
			z_index=-1,
		})

		hoh_f = math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_HP" ) + 0.5 )
		str_hf = "HPX" .. tostring(hoh_f)

		if ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then str_hf = str_hf .. "!!!" end
		
		EntityAddComponent2( rid, "SpriteComponent",
		{
			_tags="enabled_in_world",
			image_file="data/fonts/font_pixel_white.xml", 
			is_text_sprite=true, 
			offset_x=1.2*(#str_hf+5.4), 
			offset_y=13.0, 
			update_transform=true, 
			update_transform_rotation=false,
			text = str_hf, 
			has_special_scale=true,
			special_scale_x=0.7,
			special_scale_y=0.7,
			z_index=-0.99,
		})

		hoh_f = math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_AMOUNT" ) + 0.5 )
		str_hf = "NumX" .. tostring(hoh_f)

		if ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then str_hf = str_hf .. "!!!" end

		EntityAddComponent2( rid, "SpriteComponent",
		{
			_tags="enabled_in_world",
			image_file="data/fonts/font_pixel_white.xml", 
			is_text_sprite=true, 
			offset_x=1.2*(#str_hf+6.0), 
			offset_y=5.0, 
			update_transform=true, 
			update_transform_rotation=false,
			text = str_hf, 
			has_special_scale=true,
			special_scale_x=0.7,
			special_scale_y=0.7,
			z_index=-0.99,
		})
	else
		if ( math.abs(x) < 10000 ) and ( not ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then
			--perk_spawn( 227, -108, "ABYSS", true ) 
			--perk_spawn( 395, -380, "ABYSS", true ) 
		end

		if ( ModSettingGet( "DEEP_END.EVERYONE_IS_POWERFUL" ) ) then
			local opts =
			{
				"REMOVE_FOG_OF_WAR", "UNLIMITED_SPELLS", "NO_MORE_SHUFFLE", "EDIT_WANDS_EVERYWHERE", "RESPAWN", "SAVING_GRACE",
				"DE_DUPLICATE", "PERKS_LOTTERY", "WAND_EXPERIMENTER", "TRICK_BLOOD_MONEY", "NO_WAND_EDITING", "EXTRA_HP",
				"VOMIT_RATS", "MOLD", "WAND_RADAR", "RADAR_ENEMY", "FIRE_GAS", "TELEKINESIS"
				
			}
			
			-- perk_spawn_with_name( x - 444, y - 10, "EDIT_WANDS_EVERYWHERE", true )
			perk_spawn_many( x - 474, y + 6, true, opts )
			
			local rid = EntityLoad( "data/entities/items/pickup/perk_reroll.xml", x - 465, y + 50 )
			local reroll_comp = EntityGetFirstComponent( rid, "ItemCostComponent" )	

			if ( reroll_comp ~= nil ) then EntitySetComponentIsEnabled( rid, reroll_comp, false ) end

			reroll_comp = EntityGetComponent( rid, "SpriteComponent", "shop_cost" )
			
			if ( reroll_comp ~= nil ) then
				for a,b in ipairs( reroll_comp ) do
					EntitySetComponentIsEnabled( rid, b, false )
				end
			end
		
			EntitySetComponentsWithTagEnabled( rid, "perk_reroll_disable", false )

			local hah_f = math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_HP" ) + 0.5 )
			local str_hf = "HPX" .. tostring(hah_f)

			if ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then str_hf = str_hf .. "!!!" end

			if ( hah_f > 1 ) or ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then
				EntityAddComponent2( rid, "SpriteComponent",
				{
					_tags="enabled_in_world",
					image_file="data/fonts/font_pixel_white.xml", 
					is_text_sprite=true, 
					offset_x=1.2*(#str_hf+5.4), 
					offset_y=23.0, 
					update_transform=true, 
					update_transform_rotation=false,
					text = str_hf, 
					has_special_scale=true,
					special_scale_x=0.7,
					special_scale_y=0.7,
					z_index=-0.99,
				})
			end

			hah_f = math.floor( ModSettingGet( "DEEP_END.HELL_AND_HELL_AMOUNT" ) + 0.5 )
			str_hf = "NumX" .. tostring(hah_f)

			if ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then str_hf = str_hf .. "!!!" end

			if ( hah_f > 1 ) or ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) then
				EntityAddComponent2( rid, "SpriteComponent",
				{
					_tags="enabled_in_world",
					image_file="data/fonts/font_pixel_white.xml", 
					is_text_sprite=true, 
					offset_x=1.2*(#str_hf+6.0), 
					offset_y=15.0, 
					update_transform=true, 
					update_transform_rotation=false,
					text = str_hf, 
					has_special_scale=true,
					special_scale_x=0.7,
					special_scale_y=0.7,
					z_index=-0.99,
				})
			end

			-- choose one
			SetRandomSeed( x, y + newgame_n )

			local rnd = 0
			opts = { "REMOVE_FOG_OF_WAR", "UNLIMITED_SPELLS", "NO_MORE_SHUFFLE" }
		
			for i=1,3 do
				rnd = Random( 1, #opts )

				local starting_perk = perk_spawn( x + 12 + 20 * ( i - 1 ), y - 1, opts[rnd], true )

				EntityAddComponent( starting_perk, "LuaComponent", 
				{ 
					script_item_picked_up="data/scripts/perks/perk_choose_one.lua", -- script_death ?
				} )

				EntityAddTag( starting_perk, "perk_choose_one")
				table.remove( opts, rnd )
			end
		end
	end

	if ( math.abs(x) < 10000 ) and ( newgame_n == 0 ) then
		SetRandomSeed( y, x )

		if ( ModSettingGet( "DEEP_END.ALWAYS_CAN_DASH" ) ) then
			local perk_dash = perk_spawn( 227, -87, "DASH", true ) -- DESIGN_PLAYER_START_POS_X, DESIGN_PLAYER_START_POS_Y
			EntityAddTag( perk_dash, "dash")

			local itemcomp = EntityGetFirstComponent( perk_dash, "ItemComponent" )
			ComponentSetValue2( itemcomp, "auto_pickup", true )
		else
			local perk_dash = perk_spawn( 278, -96, "DASH", true )
			EntityAddTag( perk_dash, "dash")
		end
		
		if ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) or not ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
			local starting_perk = perk_spawn( 240, -252, "STRENGTH", true )
			EntityAddTag( starting_perk, "neow")

			starting_perk = perk_spawn( 269, -252, "WEALTH", true )
			EntityAddTag( starting_perk, "neow")

			starting_perk = perk_spawn( 298, -252, "HEALTH", true )
			EntityAddTag( starting_perk, "neow")

			starting_perk = perk_spawn( 327, -252, "CHAOS", true )
			EntityAddTag( starting_perk, "neow")
		end

		if ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) then EntityLoad( "data/entities/items/pickup/pouch_static.xml", 60, -425 ) end
		
		EntityLoad( "data/entities/items/pickup/powder_stash.xml", 50, -400 )
		EntityLoad( "data/entities/items/pickup/powder_stash.xml", 60, -400 )
		EntityLoad( "data/entities/items/pickup/powder_stash.xml", 70, -400 )

		EntityLoad( "data/entities/items/pickup/recycling_bin.xml", 353, -247 )

		local friend_rnd = Random( -345, 345 )

		if ( friend_rnd == 284 ) or ( friend_rnd == 22 ) then
			EntityLoad( "data/entities/animals/friend.xml", 277, -250 )

			SetRandomSeed( friend_rnd, x + y )
			local killer_rnd = Random( 10, 25 )

			for i=1,killer_rnd do
				local killer_id = EntityLoad( "data/entities/animals/ultimate_killer.xml", Random( -50, 50 ) + 300, Random( -35, 35 ) - 117 )

				local hcomp = EntityGetFirstComponent( killer_id, "BossHealthBarComponent" )
				if hcomp ~= nil then EntityRemoveComponent( killer_id, hcomp ) end
			end
		else
			local fox_num = math.max( math.floor( friend_rnd^0.5 / 32 ), 1 )
			for i=1,fox_num do EntityLoad( "data/entities/animals/fox.xml", 101+math.floor(124*i/fox_num), -81-math.floor(44*i/fox_num) ) end

			EntityAddComponent( EntityLoad( "data/entities/animals/fox.xml", 277, -135 ), "LuaComponent", 
			{
				script_death="data/scripts/animals/mr_fox_death.lua",
				execute_every_n_frame="-1",
				remove_after_executed="0",
			} )

			EntityLoad( "data/entities/animals/ultimate_killer.xml", 380, -135 )
			-- EntityLoad( "data/entities/animals/ultimate_ultra_killer.xml", 840, -1530 )

			for i=1,10 do EntityLoad( "data/entities/animals/gazer.xml", x+960+16*i, y-144-16*i ) end
		end

		-- CreateItemActionEntity( "EXPLODING_DEER", -14075, 180 )
		-- EntityLoad( "data/entities/buildings/forge_item_check.xml", 1540, 9640 )
	elseif ( math.abs(x) < 10000 ) and ( newgame_n == 1 ) then
		EntityLoad( "data/entities/items/pickup/chest_random_super.xml", 353, -247 )
	end
end

function spawn_all_shopitems( x, y )
	SetRandomSeed( x, y )

	if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
		for i=1,3 do
			local eid = EntityLoad( "data/entities/items/wands/wand_good/wand_good_" .. tostring(i) .. ".xml", x + (i - 1) * 25 + 34, y + 4 )

			EntityAddComponent( eid, "ItemCostComponent", 
			{
				cost="0",
				stealable="0",
			} )
		end
	elseif ( ModSettingGet( "DEEP_END.EVERYONE_IS_POWERFUL" ) ) then
		local chosen = tonumber(ModSettingGet( "DEEP_END.MAP_TYPE" ))
		local opts = { "wand_unshuffle_02", "wand_unshuffle_03", "wand_level_03_better", "wand_level_04" }
		local count = 4
		local item_width = 25

		if chosen > 2 then opts = { "wand_unshuffle_03", "wand_unshuffle_04", "wand_level_04", "wand_level_04_better" } end

		for i=1,count do
			local opt = Random( 1, #opts )
			local eid = EntityLoad( "data/entities/items/" .. opts[opt] .. ".xml", x + (i - 1) * item_width + 4.5, y + 4 )

			EntityAddComponent( eid, "ItemCostComponent", 
			{ 
				cost="0",
				stealable="0",
			} )

			EntitySetTransform( eid, x + (i - 1) * item_width + 4.5, y + 4, 0, 1.2675, 1.2675 )
			EntityApplyTransform( eid, x + (i - 1) * item_width + 4.5, y + 4, 0, 1.2675, 1.2675 )
		end
	end
end