dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetParent( entity_id )

if player_id ~= NULL_ENTITY and entity_id ~= player_id then
	local cid = EntityGetFirstComponentIncludingDisabled( player_id, "LuaComponent", "precise_hunt_dmg" )
	if cid ~= nil and cid ~= NULL_ENTITY then EntityRemoveComponent( player_id, cid ) end
end
