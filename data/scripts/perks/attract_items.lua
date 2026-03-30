dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local items = EntityGetWithTag( "gold_nugget" )
local distance_full = tonumber( GlobalsGetValue( "PERK_ATTRACT_ITEMS_RANGE", "100" ) )

if #items > 0 then for i,item_id in ipairs(items) do	
	local px, py = EntityGetTransform( item_id )
	if math.abs( x - px ) * 0.8 + math.abs( y - py ) < distance_full then EntitySetTransform( item_id, x, y ) end
end end