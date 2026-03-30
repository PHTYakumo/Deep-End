dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/heavenly_wrath_explosion_end.xml", x, y, 0, 0 )
