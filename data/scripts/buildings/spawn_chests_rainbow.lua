dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
GameScreenshake( 66 )

if entity_id ~= nil then
	pos_x, pos_y = pos_x + Random( -64, 64 ), pos_y - Random( 0, 128 )
	EntityAddTag( EntityLoad( "data/entities/items/pickup/chest_random_harder_" .. Random(1,7) .. ".xml", pos_x, pos_y ), "deep_end_rain_chest" )
end

