dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent( entity_id )

local target_id = entity_id
if parent_id ~= NULL_ENTITY then target_id = parent_id end

if target_id ~= NULL_ENTITY then
	local projcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if projcomp == nil then return end
	
	ComponentSetValue2( projcomp, "on_collision_die", false )
	ComponentSetValue2( projcomp, "penetrate_entities", false )
	ComponentSetValue2( projcomp, "damage_every_x_frames", 1 )
end
