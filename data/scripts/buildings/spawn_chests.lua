dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
local count = Random( 1, 3 )

for i=1,count do
	EntityAddTag( EntityLoad( "data/entities/items/pickup/chest_random.xml", pos_x + Random( -360, 360 ), pos_y - 300 ), "deep_end_rain_chest" )
	GameScreenshake( 25 )
end
