dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

entity_id = EntityGetRootEntity( entity_id )
if entity_id == NULL_ENTITY then return end

local comp = EntityGetFirstComponent( entity_id, "HomingComponent" )
if comp == nil then return end
		
local targeting = ComponentGetValue2( comp, "homing_targeting_coeff" )
local distance = ComponentGetValue2( comp, "detect_distance" )

targeting = math.min( 1024, targeting * 2 )
distance = math.min( 250, distance + 25 )

ComponentSetValue2( comp, "homing_targeting_coeff", targeting )
ComponentSetValue2( comp, "detect_distance", distance )
