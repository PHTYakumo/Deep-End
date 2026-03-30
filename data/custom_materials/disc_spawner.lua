dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x + GameGetFrameNum(), y + entity_id)

if ( Random( 1, 25 ) <= 8 ) then
	EntityLoad( "data/custom_materials/disc_bullet.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
end

EntityKill( entity_id )