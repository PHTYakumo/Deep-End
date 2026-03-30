dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local key = "DEEP_END_MAP_SPECIAL_MATERIAL_SPAWN"
local is_called = GlobalsGetValue( key ) 

if is_called == "bh" then
	GlobalsSetValue( key, "null" )
else
	GlobalsSetValue( key, "bh" )
	SetRandomSeed( x + GameGetFrameNum(), y + entity_id)

	local sprnd = Random( 1, 25 )

	if ( sprnd <= 8 ) then
		EntityLoad( "data/custom_materials/black_hole.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) )
	elseif ( sprnd <= 16 ) then
		EntityLoad( "data/custom_materials/white_hole.xml", x + Random( -10, 10 ), y + Random( -10, 10 ) )
	end
end

EntityKill( entity_id )