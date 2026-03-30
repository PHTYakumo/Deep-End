dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y, r, sx, sy = EntityGetTransform( entity_id )

sy = math.abs( math.cos( GameGetFrameNum() ) )

EntitySetTransform( entity_id, x, y, r, sx, sy)

