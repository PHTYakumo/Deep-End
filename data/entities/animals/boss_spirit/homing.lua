dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local player = EntityGetWithTag( "player_unit" )

if ( entity_id ~= nil ) and ( #player > 0 ) then
    local px,py = EntityGetTransform( player[1] )

    SetRandomSeed( GameGetFrameNum(), py + x )

    local tx = x + ( px - x ) * Random( 80, 100 ) / 100
    local ty = y + ( py -4 - y ) * Random( 80, 100 ) / 100

    EntitySetTransform( entity_id, tx, ty )
    EntityApplyTransform( entity_id, tx, ty )
end