dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )

local x, y = EntityGetTransform( entity_id )
local targets = EntityGetInRadiusWithTag( x, y, 33, "homing_target" )

local comp = EntityGetFirstComponent( root_id, "ProjectileComponent" )
if comp == nil or #targets == 0 then return end

local shooter = ComponentGetValue2( comp, "mWhoShot" )
SetRandomSeed( #targets - shooter, entity_id - root_id )

local target = targets[1]
local loop = 0

while loop < #targets * 2 do
	target = targets[Random(1,#targets)]
	loop = loop + 1

	if target ~= shooter and GameGetGameEffect( target, "CHARM" ) == 0 and EntityGetHerdRelation( shooter, target ) < 60 then
		local tx, ty = EntityGetFirstHitboxCenter( target )
		tx, ty = tx + Random( -100, 100 ) * 0.01, ty + Random( -100, 100 ) * 0.01

		EntitySetTransform( root_id, tx, ty )
		EntityApplyTransform( root_id, tx, ty )

		break
	end
end
