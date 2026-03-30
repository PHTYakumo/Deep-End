-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile( "data/scripts/biome_scripts.lua" )
dofile( "data/scripts/items/generate_shop_item.lua" )
dofile( "data/scripts/biomes/temple_shared.lua" )
dofile_once("data/scripts/biomes/temple_altar_top_shared.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff6d934c, "spawn_hp" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xff33935F, "spawn_cheap_shopitem" )
RegisterSpawnFunction( 0xff10822d, "spawn_workshop" )
RegisterSpawnFunction( 0xff5a822d, "spawn_workshop_extra" )
RegisterSpawnFunction( 0xffFAABBA, "spawn_motordoor" )
RegisterSpawnFunction( 0xffFAABBB, "spawn_pressureplate" )
RegisterSpawnFunction( 0xffA85454, "spawn_control_workshop" )
RegisterSpawnFunction( 0xff03DEAD, "spawn_areachecks" )
RegisterSpawnFunction( 0xff7345DF, "spawn_perk_reroll" )
RegisterSpawnFunction( 0xffc128ff, "spawn_rubble" )
RegisterSpawnFunction( 0xffa7a707, "spawn_lamp_long" )
RegisterSpawnFunction( 0xff9f2a00, "spawn_statue" )
RegisterSpawnFunction( 0xffC41860, "spawn_vines" )
RegisterSpawnFunction( 0xffff3ec8, "spawn_scroll" )

g_lamp =
{
	total_prob = 0,
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/temple_lantern.xml"
	},
}

g_rubble =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 2.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_01.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_02.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_03.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_04.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_05.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_temple_rubble_06.xml"
	},
}

g_vines =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_long.xml"
	},
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_short.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_shorter.xml"
	},
}

function spawn_small_enemies( x, y ) end
function spawn_big_enemies( x, y ) end
function spawn_items( x, y ) end
function spawn_props( x, y ) end
function spawn_props2( x, y ) end
function spawn_props3( x, y ) end
function load_pixel_scene( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_candles( x, y ) end
function spawn_potions( x, y ) end

function init( x, y, w, h )
	spawn_altar_top_deep_end(x, y, false)

	LoadPixelScene( "data/biome_impl/temple/altar_right.png", "data/biome_impl/temple/altar_right_visual.png", x, y-40+300, "data/biome_impl/temple/altar_right_background.png", true )
	LoadPixelScene( "data/biome_impl/temple/altar_right_extra.png", "", x, y-40+300+282, "", true )
end

function spawn_hp( x, y )
	if GameHasFlagRun( "deep_end_wealth_perk_curse" ) then return end
	
	EntityLoad( "data/entities/items/pickup/heart_fullhp_temple.xml", x-16, y )
	EntityLoad( "data/entities/items/pickup/heart_refresh.xml", x+16, y )
end

function spawn_shopitem( x, y )
	if GameHasFlagRun( "deep_end_wealth_perk_curse" ) then return end
	
	EntityLoad( "data/entities/items/shop_item.xml", x, y )
end

function spawn_shopitem( x, y )
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	generate_shop_item( x, y, false )
end

function spawn_cheap_shopitem( x, y )
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	generate_shop_item( x, y, true )
end

function spawn_workshop( x, y )
	EntityLoad( "data/entities/buildings/workshop.xml", x, y )
	EntityLoad( "data/entities/buildings/workshop_show_hint.xml", x, y )
end

function spawn_workshop_extra( x, y )
	EntityLoad( "data/entities/buildings/workshop_allow_mods.xml", x, y )
end

function spawn_motordoor( x, y )
	EntityLoad( "data/entities/props/physics_templedoor2.xml", x, y )
end

function spawn_pressureplate( x, y )
	EntityLoad( "data/entities/props/temple_pressure_plate.xml", x, y )
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y,0,10)
end

function spawn_lamp_long(x, y)
	spawn(g_lamp,x,y,0,15)
end

function spawn_control_workshop(x,y)
	EntityLoad( "data/entities/buildings/workshop_exit.xml", x, y )
end

function spawn_perk_reroll( x, y )
	if ( ModSettingGet( "DEEP_END.HELL_AND_HELL_PERK" ) ) or ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", "-2" ) end

	local rid = EntityLoad( "data/entities/items/pickup/perk_reroll.xml", x, y )
	local reroll_comp = EntityGetFirstComponent( rid, "ItemCostComponent" )
			
	if ( reroll_comp ~= nil ) then EntitySetComponentIsEnabled( rid, reroll_comp, false ) end
	
	reroll_comp = EntityGetComponent( rid, "SpriteComponent", "shop_cost" )
	
	if ( reroll_comp ~= nil ) then
		for a,b in ipairs( reroll_comp ) do
			EntitySetComponentIsEnabled( rid, b, false )
		end
	end
	
	EntitySetComponentsWithTagEnabled( rid, "perk_reroll_disable", false )

	if ( ModSettingGet( "DEEP_END.HEAVEN_OR_HELL" ) ) then
		local hoh_f = math.floor(ModSettingGet( "DEEP_END.HEAVEN_OR_HELL_FACTOR" )+0.5)
		local str_hf = "level:" .. tostring(hoh_f)

		if hoh_f > 40 then str_hf = "level:error!" end
		
		EntityAddComponent2( rid, "SpriteComponent",
		{
			_tags="enabled_in_world",
			image_file="data/fonts/font_pixel_white.xml", 
			is_text_sprite=true, 
			offset_x=1.5*(#str_hf+1), 
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
	end
end

function spawn_areachecks( x, y )
	
	if( temple_should_we_spawn_checkers( x, y ) ) then
		--[[ EntityLoad( "data/entities/buildings/temple_areacheck_horizontal.xml", x - 190 - 24, y - 69 - 20 )
		EntityLoad( "data/entities/buildings/temple_areacheck_horizontal.xml", x - 190 + 32, y + 140 + 12 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 109 + 32, y )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 109 + 32, y + 50 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 109 + 32, y + 100 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 69 + 32 - 16, y - 69 - 20 )
		EntityLoad( "data/entities/buildings/temple_areacheck_vertical_stub.xml", x + 69 + 32 - 16, y - 69  ) ]]--
		-- EntityLoad( "data/entities/buildings/temple_areacheck_vertical.xml", x - 120, y )
	end

end

function spawn_wands( x, y ) end

function spawn_rubble(x, y)
	spawn(g_rubble,x,y,5,0)
end

function spawn_statue( x, y )
	EntityRemoveTag( EntityLoad( "data/entities/props/temple_statue_02.xml", x , y ), "homing_target" )
end

function spawn_vines( x, y )
	spawn( g_vines, x, y )
end

function spawn_scroll(x, y)
	EntityLoad( "data/entities/items/pickup/temple_travel_mark.xml", x-8, y-24 )
	EntityLoad( "data/entities/animals/fox.xml", x-40, y-72 )

	if math.abs(x) > 10000 then
		local chef = EntityLoad( "data/entities/misc/miner_chef.xml", x+72, y-40 )
		EntityAddRandomStains( chef, CellFactory_GetType("magic_liquid_berserk"), 56 )
	end
end
