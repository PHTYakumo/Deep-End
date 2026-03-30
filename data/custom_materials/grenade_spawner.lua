dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )

local sprnd = Random( 1, 100 )

if sprnd <= 7 then -- 7%
	EntityLoad( "data/custom_materials/grenade.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
elseif sprnd <= 13 then -- 6%
	EntityLoad( "data/custom_materials/grenade_tier_2.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
elseif sprnd <= 16 then -- 3%
	EntityLoad( "data/custom_materials/grenade_tier_3.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
elseif sprnd <= 20 then -- 4%
	EntityLoad( "data/custom_materials/grenade_anti.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) - 10 )
end

EntityKill( entity_id )