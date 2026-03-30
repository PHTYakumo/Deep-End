dofile_once("data/scripts/lib/utilities.lua")

local tiems = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if tiems % 2 == 1 then return end

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/particles/particle_explosion/explosion_trail_swirl_orange_slow.xml", x, y )
if tiems > 0 then return end

EntityAddComponent( entity_id, "LuaComponent",
	{
		script_source_file = "data/scripts/projectiles/chaotic_arc.lua",
		execute_every_n_frame = "3",
	}
)

EntityAddComponent( entity_id, "LuaComponent",
	{
		script_source_file = "data/scripts/projectiles/chaotic_arc.lua",
		execute_every_n_frame = "4",
	}
)