dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

if EntityHasTag( entity_id, "card_action" ) then
	if EntityHasTag( entity_id, "card_action_lua_enabled" ) then EntityRemoveTag( entity_id, "card_action_lua_enabled" ) end
else
	local components = EntityGetComponentIncludingDisabled( entity_id, "ItemComponent" )
	if components ~= nil then for i=1,#components do ComponentSetValue2( components[i], "preferred_inventory", "FULL" ) end end
	-- GamePrint("FULL")
end