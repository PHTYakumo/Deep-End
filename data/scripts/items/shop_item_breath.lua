dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local comp_id = GetUpdatedComponentID()

local executed_times = ComponentGetValue2( comp_id, "mTimesExecuted" )
if executed_times < 2 then return end

if EntityGetFirstComponent( entity_id, "ItemCostComponent", "shop_cost" ) == nil then
	EntitySetComponentIsEnabled( entity_id, comp_id, false )
	return
end

local x, y, r, sx, sy = EntityGetTransform(entity_id)
-- SetRandomSeed( x, y )

local t1 = math.sin( 0.00999 * math.pi * ( executed_times - 2 ) )
local t2 = math.sin( 0.00999 * math.pi * ( executed_times - 1 )  )

r = r + 0.25 * ( t2 - t1 )
r = clamp ( r, -0.5, 0.5 )

t1 = math.cos( 0.00999 * math.pi * ( executed_times - 2 ) )
t2 = math.cos( 0.00999 * math.pi * ( executed_times - 1 )  )

if sx + sy > 2 then
	sx = sx + 0.375 * ( t2 - t1 )
	sy = sx
elseif sx > sy then
	sy = sy - 0.125 * ( t2 - t1 )
	sy = clamp ( sy, sx / 2, sx - 0.001 )
elseif sx < sy then
	sx = sx - 0.125 * ( t2 - t1 )
	sx = clamp ( sx, sy / 2, sy - 0.001 )
else
	sx = sx - 0.1 * ( t2 - t1 )
	sy = sx
end

EntitySetTransform( entity_id, x, y, r, sx, sy )
EntityApplyTransform( entity_id, x, y, r, sx, sy )
