dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local projs = EntityGetInRadiusWithTag( x, y, 20, "projectile" )

for i,v in ipairs( projs ) do
	local pcomp = EntityGetFirstComponent( v, "ProjectileComponent" )

	if pcomp ~= nil and not ( EntityHasTag( v, "projectile_converted" ) or EntityHasTag( v, "projectile_centipede" ) ) then
		ComponentSetValue2( pcomp, "explosion_dont_damage_shooter", false )
		ComponentSetValue2( pcomp, "friendly_fire", true )
		ComponentSetValue2( pcomp, "collide_with_shooter_frames", 1 )
	end
end