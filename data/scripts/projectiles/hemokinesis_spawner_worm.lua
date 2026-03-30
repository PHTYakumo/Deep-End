dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad("data/entities/projectiles/hemokinesis_prj_worm.xml", x, y)

EntityKill( entity_id )