-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 8
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/director_helpers_design.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/biomes/deep_end_imitated_biomes.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )

RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xffbe704d, "spawn_specialshop" )

------------ small enemies -------------------------------

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/monk.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/gazer.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/spitmonster.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/bloodcrystal_physics.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/worm_end.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/thunderskull.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/necromancer_super.xml"
	},
	{
		prob   		= 0.02,
		min_count	= 2,
		max_count	= 2,    
		entity 	= "data/entities/animals/robobase/drone_shield.xml",
	},
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
}

g_small_enemies_sky =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/skygazer.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/spearbot.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/skycrystal_physics.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/the_end/worm_skull.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_storm.xml"
	},
	{
		prob   		= 0.005,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/thunderskull.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/wizard_tele.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/thundermage_big.xml"
	},
}

g_big_enemies_sky =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.8,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith.xml"
	},
	{
		prob   		= 0.03,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/wraith_glowing.xml"
	},
}


------------ items -------------------------------

g_items =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	{
		prob   		= 7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_10.xml"
	},
	{
		prob   		= 5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_unshuffle_10.xml"
	},
	{
		prob   		= 3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_100.xml"
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_torch_stand.xml"
	},
}

g_props =
{
	total_prob = 0,
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= ""
	},
	--[[
	These are very buggy, commented out for now
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,
		offset_y	= -4,
		entity 	= "data/entities/buildings/spike.xml"
	},
	]]--
}

g_unique_enemy =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
}

g_large_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
}

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/cathedral.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/crypt/mining.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
}

g_ghostlamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_chain_torch_ghostly.xml"
	},
}

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y)
	spawn(g_small_enemies_sky,x,y)
end

function spawn_big_enemies(x, y)
	spawn(g_big_enemies_sky,x,y)
	-- spawn_hp_mult(g_big_enemies,x,y,0,0,16,"the_end")
end

function spawn_items(x, y)
	local r = ProceduralRandom( x-11.631, y+10.2257 )
	
	if (r > 0.38) then
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", x-10, y-17, "", true )
	end
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x+6, y-4)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x+4,y,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x+5,y+5)
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x-1,y,0,0)
	-- spawn_hp_mult(g_unique_enemy,x-1,y,0,0,16,"the_end")
end

function spawn_large_enemies(x, y)
	spawn(g_large_enemies,x-1,y,0,0)
	-- spawn_hp_mult(g_large_enemies,x-1,y,0,0,16,"the_end")
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function spawn_moon( x, y )
	if ( y <= 0 ) then
		EntityLoad( "data/entities/buildings/moon_altar.xml", x, y )
	else
		EntityLoad( "data/entities/buildings/dark_moon_altar.xml", x, y )
	end
end

function spawn_wands(x, y)
	spawn(g_items,x-5,y,0,0)
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, 10 )
end

function spawn_specialshop( x, y )
	generate_shop_item( x, y, false, 10 )
end

function spawn_chest(x, y)
	generate_shop_item( x, y, false, 10 )
end

function spawn_unique_enemy2(x, y)
end

function spawn_unique_enemy3(x, y)
end