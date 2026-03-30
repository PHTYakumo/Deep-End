dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local player_entity = EntityGetClosestWithTag( x, y, "player_unit")

if player_entity == nil then return end

local px, py = EntityGetTransform( player_entity )
player_entity = math.abs( px - x ) + math.abs( py - y ) 

if player_entity >= 666 then return end

SetRandomSeed( GameGetFrameNum() - entity_id, px + y )

x = px + Random( 25, 225 ) * (-1)^Random( 1, 4 )
y = py - Random( -55, 95 )

EntitySetTransform( entity_id, x, y )
EntityApplyTransform( entity_id, x, y )