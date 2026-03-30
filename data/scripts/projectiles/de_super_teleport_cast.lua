dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )
local dir = Random( 0, 100 ) * 0.01 * math.pi * 2

local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local shooter,tx,ty

if comp2 ~= nil then shooter = ComponentGetValue2( comp2, "mWhoShot" ) end

if shooter ~= nil and shooter ~= NULL_ENTITY then
	local wand_id = find_the_wand_held( shooter )
	if wand_id ~= nil and wand_id ~= NULL_ENTITY then tx,ty,dir = EntityGetTransform( wand_id ) end
end

tx = x + math.cos(dir) * 120
ty = y + math.sin(dir) * 120

local success,ex,ey = RaytracePlatforms( x, y, tx, ty )

if success == false then
	ex = tx
	ey = ty
end

EntitySetTransform( entity_id, ex, ey )