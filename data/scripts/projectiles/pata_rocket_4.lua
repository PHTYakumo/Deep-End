dofile_once("data/scripts/lib/utilities.lua")

local tiems = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if tiems % 2 == 1 then return end

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/particles/particle_explosion/explosion_trail_swirl_pink_slow.xml", x, y )
if tiems > 0 then return end

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if vcomp == nil then return end

local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
ComponentSetValueVector2( vcomp, "mVelocity", vx * 5, vy * 5 )

EntityAddComponent( entity_id, "LuaComponent",  -- spiraling_shot, the files of these two spells in the game were accidentally reversed
	{
		script_source_file = "data/scripts/projectiles/orbit_shot_init.lua",
		execute_every_n_frame = "1",
		remove_after_executed = "1",
	}
)

EntityAddComponent( entity_id, "LuaComponent",
	{
		script_source_file = "data/scripts/projectiles/orbit_shot.lua",
		execute_every_n_frame = "1",
	}
)

EntityAddComponent( entity_id, "LuaComponent",
	{
		script_source_file = "data/scripts/projectiles/orbit_shot.lua",
		execute_every_n_frame = "1",
	}
)