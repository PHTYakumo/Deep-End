dofile_once("data/scripts/lib/utilities.lua")

local tiems = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if tiems % 2 == 1 then return end

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/particles/particle_explosion/explosion_trail_swirl_green_slow.xml", x, y )
if tiems > 0 then return end

EntityAddComponent( entity_id, "SineWaveComponent",
	{
		sinewave_freq = "1.5",
        sinewave_m = "1.5",
        lifetime = "-1",
	}
)