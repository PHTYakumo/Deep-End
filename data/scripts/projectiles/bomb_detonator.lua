dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local radius = 128
local projectiles = EntityGetInRadiusWithTag( x, y, radius, "projectile" )

if #projectiles > 0 then for i=1,#projectiles do
	local projectile_id = projectiles[i]
	local comp = EntityGetFirstComponent( projectile_id, "ProjectileComponent" )
	
	if comp ~= nil and entity_id ~= projectile_id then
		local testa = EntityGetFirstComponent( projectile_id, "ExplosionComponent" )
		local testb = EntityGetFirstComponent( projectile_id, "ExplodeOnDamageComponent" )

		local test1 = ComponentGetValue2( comp, "on_death_explode" )
		local test2 = ComponentGetValue2( comp, "on_lifetime_out_explode" )

		if testa ~= nil or testb ~= nil or test1 or test2 then
			ComponentSetValue2( comp, "on_death_explode", true )
			ComponentSetValue2( comp, "on_lifetime_out_explode", true )

			ComponentSetValue2( comp, "explosion_dont_damage_shooter", false )
			ComponentSetValue2( comp, "on_death_gfx_leave_sprite", false )
		end
		
		EntityKill( projectile_id )
		if i >= 32 then break end
	end
end end