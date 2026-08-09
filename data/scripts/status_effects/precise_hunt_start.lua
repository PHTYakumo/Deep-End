dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = EntityGetParent( entity_id )

if player_id ~= NULL_ENTITY and entity_id ~= player_id then
	EntityAddComponent( player_id, "LuaComponent", 
	{
		_tags="precise_hunt_dmg",
		script_damage_about_to_be_received = "data/scripts/status_effects/precise_hunt_dmg.lua",
		execute_every_n_frame = "-1",
	} )
end