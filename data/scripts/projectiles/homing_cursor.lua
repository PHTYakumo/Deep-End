dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )
local dir = Random( 0, 100 ) * 0.01 * math.pi * 2

local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local shooter,px,py

if comp2 ~= nil then shooter = ComponentGetValue2( comp2, "mWhoShot" ) end

if shooter ~= nil and shooter ~= NULL_ENTITY then
	local wand_id = find_the_wand_held( shooter )
	if wand_id ~= nil and wand_id ~= NULL_ENTITY then px,py,dir = EntityGetTransform( wand_id ) end
end

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vx,vy = ComponentGetValueVector2( comp, "mVelocity")
	
	local dist = get_magnitude( vy, vx )
	local dir2 = -math.atan2( vy, vx )
	
	local delta = math.atan2( math.sin( dir + dir2 ), math.cos( dir + dir2 ) )
	local newdir = dir2 - delta * 0.8
	
	vx = math.cos( newdir ) * dist
	vy = -math.sin( newdir ) * dist

	ComponentSetValueVector2( comp, "mVelocity", vx, vy)
end)