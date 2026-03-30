dofile_once("data/scripts/lib/utilities.lua")

function shot( projectile_id )
	if projectile_id == NULL_ENTITY then return end
	local comps = EntityGetComponent( projectile_id, "ProjectileComponent" )

	if comps ~= nil then for i,v in ipairs( comps ) do
		ComponentSetValue2( v, "collide_with_tag", "player_unit" )
		ComponentSetValue2( v, "friendly_fire", false )
		ComponentSetValue2( v, "explosion_dont_damage_shooter", true )
	end end
end