dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local t = EntityGetInRadiusWithTag( pos_x, pos_y, 220, "player_unit" )

if #t > 0 then
	local eid = EntityLoad( "data/entities/animals/boss_dragon.xml", pos_x, pos_y )
	EntityAddChild( eid, EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml", pos_x, pos_y ) )
			
	EntityAddComponent( eid, "LuaComponent", 
	{ 
		script_source_file = "data/scripts/projectiles/worm_rain.lua",
		execute_every_n_frame = "60",
	} )

	for i = 1,#t do EntityAddChild( t[i], EntityLoad( "data/entities/misc/effect_protection_all_once_no_ui.xml", pos_x, pos_y ) ) end
	
	EntityLoad( "data/entities/particles/image_emitters/magical_symbol_fast.xml", pos_x, pos_y )
	EntityKill( entity_id )
end
