dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local projs = EntityGetInRadiusWithTag( x, y, 40, "projectile" )

for i,v in ipairs( projs ) do
	local pcomp = EntityGetFirstComponent( v, "ProjectileComponent" )

	if pcomp ~= nil and not ( EntityHasTag( v, "projectile_converted" ) or EntityHasTag( v, "projectile_centipede" ) ) then
		ComponentSetValue2( pcomp, "penetrate_entities", false )
		ComponentSetValue2( pcomp, "on_collision_die", true )
		ComponentSetValue2( pcomp, "dont_collide_with_tag", "boss" )
	end
end