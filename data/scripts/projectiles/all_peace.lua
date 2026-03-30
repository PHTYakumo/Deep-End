dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x + entity_id, y - entity_id )
local projectiles = EntityGetWithTag( "projectile" )

if #projectiles > 0 then
	for i,projectile_id in ipairs( projectiles ) do
		local tags = EntityGetTags( projectile_id )
		
		if tags == nil or string.find( tags, "projectile_boss_spirit" ) == nil then
			local px, py = EntityGetTransform( projectile_id )
			local pcomps = EntityGetComponent( projectile_id, "ProjectileComponent" )
			
			if pcomps ~= nil then for j,comp_id in ipairs( pcomps ) do
				ComponentSetValue( comp_id, "on_death_explode", "0" )
				ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
			end end

			shoot_projectile( entity_id, "data/entities/animals/boss_spirit/lance.xml", px, py, Random(-100,100), Random(-100,100) )
			EntityKill( projectile_id )
		end
	end
else
	shoot_projectile( entity_id, "data/entities/animals/boss_spirit/lance.xml", x, y, Random(-100,100), Random(-100,100) )
end