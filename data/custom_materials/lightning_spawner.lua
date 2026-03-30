dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )

local sprnd = Random( 1, 50 )

if ( sprnd <= 3 ) then
	EntityLoad( "data/custom_materials/ball_lightning.xml", x + Random( -5, 5 ), y + Random( -5, 5 ) )
elseif ( sprnd <= 6 ) then
	EntityLoad( "data/entities/projectiles/lightning_thunderburst.xml", x + Random( -5, 5 ), y + Random( -5, 5 ) )
end

EntityKill( entity_id )