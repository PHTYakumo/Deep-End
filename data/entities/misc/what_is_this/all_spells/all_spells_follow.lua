dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/newgame_plus.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local players = EntityGetWithTag( "player_unit" )

if #players > 0 then
    SetRandomSeed( #players + entity_id, GameGetFrameNum() )

    x, y = EntityGetTransform(players[Random(1,#players)])

    EntitySetTransform( entity_id, x, y )
	EntityApplyTransform( entity_id, x, y )
end

