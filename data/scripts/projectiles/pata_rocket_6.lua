dofile_once("data/scripts/lib/utilities.lua")

local tiems = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )
if tiems % 2 == 1 then return end

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/particles/particle_explosion/explosion_trail_swirl_blue_slow.xml", x, y )
if tiems > 0 then return end

local vcomp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if vcomp == nil then return end

local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
ComponentSetValueVector2( vcomp, "mVelocity", -vx, -vy )

EntityAddComponent( entity_id, "SineWaveComponent",
	{
		sinewave_freq = "1",
        sinewave_m = "1",
        lifetime = "-1",
	}
)

EntityAddComponent( entity_id, "SineWaveComponent",
	{
		sinewave_freq = "1",
        sinewave_m = "0.5",
        lifetime = "-1",
	}
)

EntityAddComponent( entity_id, "SineWaveComponent",
	{
		sinewave_freq = "0.5",
        sinewave_m = "1",
        lifetime = "-1",
	}
)