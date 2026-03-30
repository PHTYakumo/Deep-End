dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local boss_id = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( boss_id )

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "wizard_orb_id" )
if ( comp ~= nil ) then
	local id = ComponentGetValue2( comp, "value_int" )
	
	local count = 3
	local amount = 7
	local tid = math.floor( id / amount )
	local circle = math.pi * 2
	local inc_1 = circle / count
	local inc_2 = circle / amount
	
	local dir_1 = inc_1 * ( tid + 1 ) + GameGetFrameNum() * 0.008 -- the phase of death_orb
	local dir_2 = inc_2 * ( id - tid * amount ) + GameGetFrameNum() * 0.008 * 3 -- the phase of blood_orb
	local dir_3 = dir_1 * 2 + math.pi / count -- the phase of the axis-rotation
	local ox = 12.3 * math.cos( dir_2 ) -- ellipse
	local oy = 10 * math.sin( dir_2 ) -- 12.3 * math.sin( dir_2 + phase difference )

	local cx = math.cos( dir_3 ) * ox - math.sin( dir_3 ) * oy -- let the axis rotates with time
	local cy = math.sin( dir_3 ) * ox + math.cos( dir_3 ) * oy
	
	local nx = x + math.cos( dir_1 ) * 50 + cx -- let blood_orb follow death_orb
	local ny = y - 20 + math.sin( dir_1 ) * 50 + cy
	
	EntitySetTransform( entity_id, nx, ny )
end