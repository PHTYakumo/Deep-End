dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
local times = ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" )

EntityInflictDamage( entity_id, 0.08 + 0.04 * times, "NONE", "$ULTIMATE", "NONE", 0, 0, entity_id )
