dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
local damagemodel = EntityGetFirstComponent( entity_id, "DamageModelComponent" )

if entity_id == nil or damagemodel == nil then return end
local air = ComponentGetValue2( damagemodel, "air_in_lungs" )

air = math.max( air - 3, 0 )
ComponentSetValue2( damagemodel, "air_in_lungs", air )