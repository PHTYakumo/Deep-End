dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

if ( entity_id ~= nil ) and ( entity_id ~= NULL_ENTITY ) then
	local comp = EntityGetFirstComponent( entity_id, "CharacterDataComponent" )
	
	if ( comp ~= nil ) then
		ComponentSetValue2( comp, "mFlyingTimeLeft", 2^13 ) -- wild
	end

	EntityRemoveStainStatusEffect( entity_id, "DEEP_END_GRAVITY_EFFECT", 10 )
	EntityRemoveStainStatusEffect( entity_id, "UNSTABLE_TELEPORTATION", 10 )
	EntityRemoveStainStatusEffect( entity_id, "TELEPORTATION", 10 )
end