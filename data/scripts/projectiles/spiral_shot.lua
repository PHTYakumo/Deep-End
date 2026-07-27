dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local len, minl = 6, 3

local c = EntityGetAllChildren( entity_id, "spiral_part" )

if c ~= nil then if #c > 0 then for i=1,#c do
	local circle = math.pi * 2
	local dir =  circle * i / #c + GameGetFrameNum() * 0.015
	
	local nx = x + math.cos( dir ) * ( math.sin( 2 * dir )^2 * 12 - 4 )
	local ny = y + math.sin( dir ) * ( math.sin( 2 * dir )^2 * 12 - 4 )
	
	EntitySetTransform( c[i], nx, ny )
	EntityApplyTransform( c[i], nx, ny )
end end end