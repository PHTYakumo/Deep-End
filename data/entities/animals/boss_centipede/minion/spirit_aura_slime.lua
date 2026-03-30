dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local pid = EntityGetClosestWithTag( x, y, "player_unit" )
local projs = EntityGetInRadiusWithTag( x, y, 56, "projectile" )

if pid == nil then return end
local px, py = EntityGetTransform( pid )

for i,v in ipairs( projs ) do
	local vcomp = EntityGetFirstComponent( v, "VelocityComponent" )

	if vcomp ~= nil then
		local vx, vy = ComponentGetValueVector2( vcomp, "mVelocity" )
		local speed = 0.5

		if EntityHasTag( v, "projectile_converted" ) or EntityHasTag( v, "projectile_centipede" ) then speed = 1.5 end

		vx, vy = vx * speed, vy * speed
		ComponentSetValueVector2( vcomp, "mVelocity", vx, vy )
	end
end