dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local key = "DEEP_END_MAP_SPECIAL_MATERIAL_SPAWN"
local is_called = GlobalsGetValue( key ) 

if is_called == "regen" then
	GlobalsSetValue( key, "null" )
else
	GlobalsSetValue( key, "regen" )
	SetRandomSeed( x + GameGetFrameNum(), y + entity_id)

	if Random( 1, 25 ) <= 20 then EntityLoad( "data/custom_materials/regeneration_field.xml", x + Random( -5, 5 ), y + Random( -5, 5 ) ) end
end

EntityKill( entity_id )