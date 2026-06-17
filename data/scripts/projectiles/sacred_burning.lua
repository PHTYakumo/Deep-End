dofile_once("data/scripts/lib/utilities.lua")

local entity_id = EntityGetRootEntity( GetUpdatedEntityID() )
EntityInflictDamage( entity_id, 0.24, "DAMAGE_HOLY", "$damage_holy", "NONE", 0, 0, entity_id )
