dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
if EntityHasTag( entity_id, "de_effect_cannon" ) then EntityRemoveTag( entity_id, "de_effect_cannon" ) end