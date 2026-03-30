dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/magic/fungal_shift.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), entity_id )

local function spawn( x,y )
	EntityLoad( "data/entities/particles/treble_eye.xml", x,y )
end

for i=1,24 do
	spawn( pos_x + rand(-150,150), pos_y + rand(-120,120) )
	fungal_shift( entity_id, pos_x, pos_y, false )
	GlobalsSetValue( "fungal_shift_last_frame", "-30000" )
end