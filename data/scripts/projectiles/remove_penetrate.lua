dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

if entity_id ~= nil and entity_id ~= NULL_ENTITY then
	local projcomp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
	if projcomp ~= nil then ComponentSetValue2( projcomp, "penetrate_entities", false ) end
end
