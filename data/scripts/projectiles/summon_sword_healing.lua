dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( entity_id )

if player_id ~= NULL_ENTITY and entity_id ~= player_id then
	local comp = EntityGetFirstComponent( player_id, "DamageModelComponent" )

	if comp ~= nil then
		local hp = clamp( ComponentGetValue2( comp, "hp" ) + 0.012, 0.04, ComponentGetValue2( comp, "max_hp" ) )
		ComponentSetValue2( comp, "hp", hp ) 
	end
end