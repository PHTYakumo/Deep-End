dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/magic/fungal_shift.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local function spawn( x, y )
	EntityLoad( "data/entities/particles/treble_eye.xml", x, y )
end

SetRandomSeed( GameGetFrameNum(), entity_id )

spawn( pos_x + rand( -150, 150 ), pos_y + rand( -120, 120 ) )
fungal_shift( entity_id, pos_x, pos_y, false )