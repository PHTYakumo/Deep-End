dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), entity_id )

local players = EntityGetInRadiusWithTag( x, y, 108, "player_unit" )
x = x + Random( -6, 6 )
y = y + Random( -11, -4 )

if ( Random( 1, 7 ) == 7 ) and ( #players > 0 ) then
    -- EntityLoad( "data/entities/projectiles/deck/spore_pod.xml",  x + Random( -12, 12 ), y + Random( -9, 6 ) )
    shoot_projectile( entity_id, "data/entities/misc/perks/spore_pod.xml", x, y, Random( -2, 2 ), -Random( 18, 42 ) )
elseif ( Random( 1, 13 ) >= 7 ) then
    local spk = Random( 1, 5 )
    
    for i=1,spk do
		shoot_projectile( root_id, "data/entities/misc/perks/spore_pod_spike.xml", x, y-8, Random( -72, 72 ), -Random( 96, 36 ) )
	end
end

-- spore pod can break the box open hahaaaaaaaaaaaaaaaa
