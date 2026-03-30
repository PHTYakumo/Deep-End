dofile_once("data/scripts/lib/utilities.lua")

local pos_x, pos_y = EntityGetTransform( GetUpdatedEntityID() )
EntityLoad( "data/entities/particles/particle_explosion/explosion_trail_swirl_pink.xml", pos_x, pos_y )
	