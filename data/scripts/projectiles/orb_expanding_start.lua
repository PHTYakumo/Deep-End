dofile_once("data/scripts/lib/utilities.lua")

local damage_m = 3.0

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local projectile_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local storage_comp = get_variable_storage_component( entity_id, "base_damage" )
if projectile_comp == nil or storage_comp == nil then return end

-- store or recall base damage
damage_m = math.max( ( ComponentGetValue2( projectile_comp, "damage" ) - damage_m ), 0 ) * 5 + damage_m
ComponentSetValue2( storage_comp, "value_float", damage_m )

-- GamePrint(tostring(damage_m))