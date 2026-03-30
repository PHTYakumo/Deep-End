dofile_once("data/scripts/lib/utilities.lua")

if ComponentGetValue2( GetUpdatedComponentID(), "mTimesExecuted" ) > 16 then return end
local entity_id = GetUpdatedEntityID()

local x, y = EntityGetTransform( entity_id )
local px, py = x, y

local comp = EntityGetFirstComponent( entity_id, "SpriteComponent" )
if comp ~= nil then ComponentSetValue2( comp, "alpha", math.min( ComponentGetValue2( comp, "alpha" ) + 0.06, 1 ) ) end

local pl = EntityGetClosestWithTag( x, y, "player_unit" )
if pl ~= nil then px, py = EntityGetTransform( pl ) end

x = ( x + px ) * 0.5
y = ( y + py ) * 0.5

EntitySetTransform( entity_id, x, y )
EntityApplyTransform( entity_id, x, y )