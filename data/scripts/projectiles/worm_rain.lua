dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + GetUpdatedComponentID(), pos_x + pos_y + entity_id )

local worm_type = { "misc/worm_big_worm_rain", "animals/worm_end", "animals/worm_skull" }

for i=1,Random(2,7) do
    local x = pos_x + Random( -200, 200 )
    local y = pos_y + Random( -320, -180 )

    local eid = EntityLoad( "data/entities/" .. worm_type[Random(1,#worm_type)] .. ".xml", x, y )
end

local targets = EntityGetInRadiusWithTag( pos_x, pos_y, 216, "hittable" )

for i,v in pairs( targets ) do
	EntityAddRandomStains( v, CellFactory_GetType("magic_liquid_worm_attractor"), 400 )
end

GameScreenshake( 10 )