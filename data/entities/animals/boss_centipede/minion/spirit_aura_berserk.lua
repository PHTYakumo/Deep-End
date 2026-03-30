dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pid = EntityGetClosestWithTag( x, y, "player_unit" )
local projs = EntityGetInRadiusWithTag( x, y, 32, "projectile" )

if pid == nil then return end
local px, py = EntityGetTransform( pid )

for i,v in ipairs( projs ) do
	if EntityHasTag( v, "projectile_converted" ) or EntityHasTag( v, "projectile_centipede" ) then
		local vcomp = EntityGetFirstComponent( v, "VelocityComponent" )

		if vcomp ~= nil then
			local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
			local speed = get_magnitude( vx, vy )

			vx, vy = px - x, py - y
			vx, vy = vec_normalize(vx, vy)

			vx = vx * speed
			vy = vy * speed

			ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )
		end

		local pcomp = EntityGetFirstComponent( v, "ProjectileComponent" )
		if pcomp ~= nil then ComponentSetValue2( pcomp, "collide_with_world", false ) end
	end
end