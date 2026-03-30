dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local p = EntityGetInRadiusWithTag( x, y, 96, "player_unit" )

if p[1] ~= nil then
	SetRandomSeed( x + GameGetFrameNum(), y + entity_id)

	local sprnd = Random( 1, 200 )

	if ( sprnd == 2 ) then
		EntityLoad( "data/entities/animals/ghoul.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
	elseif ( sprnd == 3 ) then
		EntityLoad( "data/entities/animals/frog.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
	elseif ( sprnd == 4 ) then
		EntityLoad( "data/entities/animals/frog_big.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
	elseif ( sprnd == 5 ) then
		EntityLoad( "data/entities/animals/miniblob.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
	elseif ( sprnd == 6 ) then
		EntityLoad( "data/entities/animals/duck.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
	end

	local rainrnd = Random( 1, 100000 )

	if ( rainrnd < 14 ) then
		EntityLoad( "data/entities/projectiles/deck/cloud_water.xml", x + Random( -10, 10 ), y -22 )
	elseif ( rainrnd > 99993 ) then
		EntityLoad( "data/entities/projectiles/deck/cloud_thunder.xml", x + Random( -10, 10 ), y -22 )
	end
end

EntityKill( entity_id )