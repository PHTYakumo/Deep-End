dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)

if EntityHasTag( root_id, "de_dark_curse" ) then
	if EntityHasTag( root_id, "player_unit" ) then EntityRemoveTag( root_id, "de_dark_curse" ) end
else
	if not EntityHasTag( root_id, "curse_NOT" ) then EntityAddTag( root_id, "de_dark_curse" ) end
end

EntityKill(entity_id)

