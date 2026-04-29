dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local projs = EntityGetInRadiusWithTag( x, y, 60, "projectile" )

for i,v in ipairs( projs ) do
	local vcomp = EntityGetFirstComponent( v, "VelocityComponent" )

	if vcomp ~= nil then
		local speed = 0.4
		if EntityHasTag( v, "projectile_converted" ) or EntityHasTag( v, "projectile_centipede" ) then speed = 1.6 end

		local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
		vx, vy = vx * speed, vy * speed
		ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )
	end
end