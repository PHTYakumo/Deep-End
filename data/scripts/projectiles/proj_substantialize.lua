dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

if entity_id ~= NULL_ENTITY then
	local projcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if projcomp == nil then return end

	ComponentSetValue2( projcomp, "collide_with_world", true )
	ComponentSetValue2( projcomp, "penetrate_world", false )

	local sprtcomp = EntityGetFirstComponent( entity_id, "SpriteComponent" )
	if sprtcomp == nil then return end

	ComponentSetValue2( sprtcomp, "alpha", 0.99 )
	ComponentSetValue2( sprtcomp, "update_transform_rotation", false )
end
