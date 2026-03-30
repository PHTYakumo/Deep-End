dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local boss_id = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( boss_id )

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "disc_id" )
if ( comp ~= nil ) then
	SetRandomSeed( x + GameGetFrameNum(), y + entity_id )

	local id = ComponentGetValue2( comp, "value_int" )
	local radius = 45 + Random(-3,3)
	
	local count = 4
	local circle = math.pi * 2

	local inc = circle / count * id
	local dir = inc + ( ComponentGetValue2(GetUpdatedComponentID(),"mTimesExecuted") * 0.003 - 1 )^2 * 9 * circle

	local nx = x + math.cos(dir) * radius
	local ny = y - math.sin(dir) * radius

	EntitySetTransform( entity_id, nx, ny )
end