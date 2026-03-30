dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x + GameGetFrameNum(), y + entity_id)

if ( Random( 1, 25 ) <= 9 ) then
	EntityLoad( "data/custom_materials/rubber_ball.xml", x + Random( -5, 5 ), y + Random( -5, 5 ) )
end

EntityKill( entity_id )